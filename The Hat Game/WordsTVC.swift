//
//  WordsTVC.swift
//  The Hat
//
//  Created by Руслан Тхакохов on 04.08.15.
//  Copyright (c) 2015 Руслан Тхакохов. All rights reserved.
//

import UIKit

class WordsTVC: UITableViewController {
    var words: [Word]?
    var dictionary: Dictionary?
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    @IBAction func addWord(sender: UIBarButtonItem) {
        var alert = UIAlertController(title: "Add word", message: "Add a new word", preferredStyle: .Alert)
        
        let saveAction = UIAlertAction(title: "Add", style: .Default) { (action: UIAlertAction!) -> Void in
            let textField = alert.textFields![0] as! UITextField
            let wordObject = Word.addWord(textField.text)
            if wordObject != nil {
                self.dictionary?.addWord(wordObject!)
                self.words?.append(wordObject!)
                sort(&self.words!, { $0.word < $1.word })
                self.tableView.reloadData()
            } else {
                println("Failed to add word \(textField.text)")
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Default) { (action: UIAlertAction!) -> Void in
        }
        
        alert.addTextFieldWithConfigurationHandler { (textField: UITextField!) -> Void in
            textField.placeholder = "Word"
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if dictionary?.custom == true {
            addButton.enabled = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    private struct Storyboard {
        static let ResueIdentifier = "Word Cell"
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return words?.count ?? 0
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.ResueIdentifier, forIndexPath: indexPath) as! UITableViewCell

        cell.textLabel?.text = words![indexPath.row].word

        return cell
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }

    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let managedContext = appDelegate.managedObjectContext!
            managedContext.deleteObject(words![indexPath.row])
            
            if managedContext.save(nil) == false {
                println("failed to delete dict from db")
                return
            }
            
            words?.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
