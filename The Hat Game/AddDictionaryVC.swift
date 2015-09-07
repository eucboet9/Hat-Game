//
//  AddDictionaryVC.swift
//  The Hat
//
//  Created by Руслан Тхакохов on 04.08.15.
//  Copyright (c) 2015 Руслан Тхакохов. All rights reserved.
//

import UIKit

class AddDictionaryVC: UIViewController {
    
    @IBOutlet weak var nameLabel: UITextField!
    @IBOutlet weak var languageLabel: UITextField!
    
    var difficulty: Int?
    var name: String?
    var language: String?
    
    @IBAction func add() {
        
    }
    
    @IBAction func cancel() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func difficultyChanged(sender: UISegmentedControl) {
        difficulty = sender.selectedSegmentIndex + 1
    }
    
    @IBAction func nameChanged(sender: UITextField) {
        name = (sender.text == "") ? nil : sender.text
    }
    
    @IBAction func languageChanged(sender: UITextField) {
        language = (sender.text == "") ? nil : sender.text
    }
    
    private func reportError(text: String) {
        var alert = UIAlertController(title: "", message: text, preferredStyle: .Alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .Default) { (action: UIAlertAction!) -> Void in
        }
        
        alert.addAction(okAction)
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        if name == nil {
            reportError("You need to specify a name!")
            return false
        } else if difficulty == nil {
            reportError("You need to specify difficulty!")
            return false
        } else if language == nil {
            reportError("You need to specify language!")
            return false
        }
        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
    }
    

}
