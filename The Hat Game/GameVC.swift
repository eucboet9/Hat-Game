//
//  GameVC.swift
//  The Hat
//
//  Created by Руслан Тхакохов on 06.08.15.
//  Copyright (c) 2015 Руслан Тхакохов. All rights reserved.
//

import UIKit
import AVFoundation

class GameVC: UIViewController, AVAudioPlayerDelegate {
    
    var player: AVAudioPlayer?
    
    @IBOutlet weak var wordLabel: UILabel!
    @IBOutlet weak var abortButton: UIButton!
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var guessedWordsLabel: UILabel!

    private struct Storyboard {
        static let SegueIdentifier = "Results Segue"
    }
    
    var game: Game?
    var gameTimer: NSTimer?
    var timeLeft = 0
    var guessedWords = 0 {
        didSet {
            guessedWordsLabel.text = "Guessed: \(guessedWords)"
        }
    }
    var currentWord: Word?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initPlayer()
        // Do any additional setup after loading the view.
    }

    func initPlayer() {
        let url = NSURL.fileURLWithPath(NSBundle.mainBundle().pathForResource("beep-09", ofType: "mp3")!)
        var error: NSError?
        player = AVAudioPlayer(contentsOfURL: url, error: &error)
        if error == nil {
            player?.delegate = self
            player?.prepareToPlay()
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if game?.gameOver != nil && game!.gameOver == false {
            showNextPlayer()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func guessWord() {
        game?.guessWord()
        guessedWords++
        updateWord()
    }
    
    @IBAction func stopGame() {
        var alert = UIAlertController(title: "Exit", message: "Stop the game?", preferredStyle: .Alert)
        
        let yesAction = UIAlertAction(title: "Yes", style: .Default) { (action: UIAlertAction!) -> Void in
            
            self.finishGame()
        }
        
        let noAction = UIAlertAction(title: "No", style: .Default) { (action: UIAlertAction!) -> Void in
        }
        
        alert.addAction(yesAction)
        alert.addAction(noAction)
        
        presentViewController(alert, animated: true) { () -> Void in
        }

    }
    
    func showNextPlayer() {
        guessedWords = 0
        
        var alert = UIAlertController(title: "Next turn", message: "Pair: \(game!.getCurrentPair())\nPlayer: \(game!.getCurrentPlayer())", preferredStyle: .Alert)
        
        let okAction = UIAlertAction(title: "Go", style: .Default) { (action: UIAlertAction!) -> Void in
            
            self.timeLeft = 20
            self.updateWord()
            self.gameTimer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "timerFired", userInfo: nil, repeats: true)
        }
        
        alert.addAction(okAction)
        
        presentViewController(alert, animated: true) { () -> Void in
            println("show alert")
        }
    }

    func finishTurn() {
        
        wordLabel.text = ""
        
        var alert = UIAlertController(title: "The turn is over", message: "Have you guessed the last word?", preferredStyle: .Alert)
        
        let yesAction = UIAlertAction(title: "Yes", style: .Default) { (action: UIAlertAction!) -> Void in
            self.game?.guessWord()
            self.game?.finishTurn()
            
            if self.game?.hasMoreWords() == true {
                self.showNextPlayer()
            } else {
                self.finishGame()
            }
        }
        
        let noAction = UIAlertAction(title: "No", style: .Default) { (action: UIAlertAction!) -> Void in
            if self.currentWord != nil {
                self.game?.takeBackWord(self.currentWord!)
            }
            self.game?.finishTurn()
            
            if self.game?.hasMoreWords() == true {
                self.showNextPlayer()
            } else {
                self.finishGame()
            }
        }
        
        alert.addAction(yesAction)
        alert.addAction(noAction)
        
        presentViewController(alert, animated: true) { () -> Void in
            
        }

    }
    
    func timerFired() {
        if timeLeft == 0 {
            player?.play()
            gameTimer?.invalidate()
            finishTurn()
        } else {
            timeLeft--
            timeLabel.text = (timeLeft < 10) ? "00:0\(timeLeft)" : "00:\(timeLeft)"
        }
    }
    
    private func updateWord() {
        if let newWord = game?.getWord() {
            currentWord = newWord
            wordLabel.text = newWord.word
            
            
        } else {
            finishGame()
        }
    }
    
    func finishGame() {
        game?.gameOver = true
        gameTimer?.invalidate()
        
        var alert = UIAlertController(title: "", message: "The game is over", preferredStyle: .Alert)
        
        let resultsAction = UIAlertAction(title: "Results", style: .Default) { (action: UIAlertAction!) -> Void in
            
            //show results
            self.performSegueWithIdentifier(Storyboard.SegueIdentifier, sender: nil)
        }
        
        alert.addAction(resultsAction)
        
        presentViewController(alert, animated: true) { () -> Void in
            
        }

    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if let identifier = segue.identifier {
            switch identifier {
            case Storyboard.SegueIdentifier:
                if let nvc = segue.destinationViewController as? UINavigationController {
                    if let rvc = nvc.viewControllers[0] as? ResultsTVC {
                        rvc.pairs = game!.getResults()
                    }
                }
            default: break
            }
        }
    }
    

}
