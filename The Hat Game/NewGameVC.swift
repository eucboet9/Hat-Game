//
//  NewGameVC.swift
//  The Hat
//
//  Created by Руслан Тхакохов on 05.08.15.
//  Copyright (c) 2015 Руслан Тхакохов. All rights reserved.
//

import UIKit
import CoreData

class NewGameVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate {

    private struct Storyboard {
        static let ReuseIdentifier = "Pair Cell"
        static let SegueIdentifier = "Play Segue"
    }
    
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var numberOfWordsLabel: UILabel!
    @IBOutlet weak var stepperView: UIStepper!
    @IBOutlet weak var addPairButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    
    private var game: Game? {
        if pairs.count < 2 {
            reportError("At least 2 pairs are required!")
            return nil
        }
        if stepperView.value == 0 {
            reportError("Too few words!")
            return nil
        }
        if chosenDictionary == nil {
            reportError("You haven't specified the dictionary!")
            return nil
        }
        
        return Game(pairs: pairs, numberOfWords: Int(stepperView.value), dictionary: chosenDictionary!)
    }
    
    private func reportError(text: String) {
        var alert = UIAlertController(title: "", message: text, preferredStyle: .Alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .Default) { (action: UIAlertAction!) -> Void in
        }
        
        alert.addAction(okAction)
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
    var dictionaries: [Dictionary]?
    var pairs = [Pair]()
    var chosenDictionary: Dictionary? {
        didSet {
            if chosenDictionary != nil {
                stepperView.maximumValue = Double(chosenDictionary!.words.count)
                stepperView.value = 0
                numberOfWordsChanged()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "dataLoaded", name: "DataLoadedNotification", object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        pairs.removeAll(keepCapacity: false)
        tableView.reloadData()
    }
    
    func dataLoaded() {
        println("notified")
        fetchDictionaries()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchDictionaries()
        stepperView.value = 0
        numberOfWordsChanged()
        pickerView.selectRow(0, inComponent: 0, animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addPair(sender: UIButton) {
        var alert = UIAlertController(title: "New pair", message: "", preferredStyle: .Alert)
        
        let saveAction = UIAlertAction(title: "Add", style: .Default) { (action: UIAlertAction!) -> Void in
            let textFieldA = alert.textFields![0] as! UITextField
            let textFieldB = alert.textFields![1] as! UITextField
            
            self.pairs.append(Pair(playerA: textFieldA.text, playerB: textFieldB.text))
            self.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Default) { (action: UIAlertAction!) -> Void in
        }
        
        alert.addTextFieldWithConfigurationHandler { (textField: UITextField!) -> Void in
            textField.placeholder = "First player"
        }
        alert.addTextFieldWithConfigurationHandler { (textField: UITextField!) -> Void in
            textField.placeholder = "Second player"
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func numberOfWordsChanged() {
        numberOfWordsLabel.text = "Words: \(Int(stepperView.value))"
    }
    
    func fetchDictionaries() {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        
        let qos = Int(QOS_CLASS_USER_INITIATED.value)
        
        dispatch_async(dispatch_get_global_queue(qos, 0), { () -> Void in
            let fetchRequest = NSFetchRequest(entityName: "Dictionary")
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "difficulty", ascending: true)]
            var error: NSError?
            let fetchedResults = managedContext.executeFetchRequest(fetchRequest, error: &error) as? [Dictionary]
            
            if let results = fetchedResults {
                self.dictionaries = results
            }
            
            self.chosenDictionary = self.dictionaries?.first
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.pickerView.reloadAllComponents()
                self.pickerView.selectRow(0, inComponent: 0, animated: false)
            })
        })

    }
    
    // MARK: - PickerView Delegate
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dictionaries?.count ?? 0
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return dictionaries![row].name
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        chosenDictionary = dictionaries![row]
    }
    
    //MARK: - TableView Delegate
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pairs.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.ReuseIdentifier) as! UITableViewCell
        
        let pair = pairs[indexPath.row]
        cell.textLabel?.text = "\(pair.playerA), \(pair.playerB)"
        
        return cell
    }
    
    // MARK: - Navigation

    @IBAction func restartGame(sender: UIStoryboardSegue) {
    
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        if let ident = identifier {
            return (game != nil) ? true : false
        }
        return false
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if let identifier = segue.identifier {
            switch identifier {
            case Storyboard.SegueIdentifier:
                if let gvc = segue.destinationViewController as? GameVC {
                    gvc.game = game!
                }
            default: break
            }
        }
        
    }
}
