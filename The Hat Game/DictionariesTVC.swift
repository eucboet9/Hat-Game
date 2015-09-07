//
//  DictionariesTVC.swift
//  The Hat
//
//  Created by Руслан Тхакохов on 26.07.15.
//  Copyright (c) 2015 Руслан Тхакохов. All rights reserved.
//

import UIKit
import CoreData

class DictionariesTVC: UITableViewController {
    private var onlineDictionaries: Array<Dictionary>?
    private var customDictionaries: Array<Dictionary>?
    
    @IBOutlet weak var updateButton: UIBarButtonItem!
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = NSUserDefaults.standardUserDefaults()
        fetchLocal()
        
        //load from the db
        //reload the TV
        
        /*let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        
        onlineDictionaries = Array<Dictionary>()
        customDictionaries = Array<Dictionary>()
        
        var dict = NSEntityDescription.insertNewObjectForEntityForName("Dictionary", inManagedObjectContext: managedContext) as! Dictionary
        dict.name = "Dict 1"
        dict.language = "EN"
        dict.difficulty = 1
        onlineDictionaries?.append(dict)
        customDictionaries?.append(dict)
        
        dict = NSEntityDescription.insertNewObjectForEntityForName("Dictionary", inManagedObjectContext: managedContext) as! Dictionary
        dict.name = "Dict 2"
        dict.language = "EN"
        dict.difficulty = 2
        onlineDictionaries?.append(dict)
        customDictionaries?.append(dict)
        
        dict = NSEntityDescription.insertNewObjectForEntityForName("Dictionary", inManagedObjectContext: managedContext) as! Dictionary
        dict.name = "Dict 3"
        dict.language = "RU"
        dict.difficulty = 3
        onlineDictionaries?.append(dict)
        customDictionaries?.append(dict)*/
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private struct Storyboard {
        static let ReuseIdentifier = "Dictionary Cell"
        static let SegueIdentifier = "Word Segue"
        static let CustomID = 100
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (section == 0) ? (onlineDictionaries?.count ?? 0) : (customDictionaries?.count ?? 0)
    }

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "Online" : "Custom"
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.ReuseIdentifier, forIndexPath: indexPath) as! DictionaryCell

        let dict = (indexPath.section == 0) ? onlineDictionaries![indexPath.row] : customDictionaries![indexPath.row]
        cell.nameLabel.text = dict.name
        cell.languageLabel.text = "Language: \(dict.language)"
        cell.difficultyLabel.text = "Difficulty: \(dict.difficulty)"

        return cell
    }
    
    //MARK: - Data Fetching
    
    @IBAction func update(sender: AnyObject) {
        updateButton.enabled = false
        addButton.enabled = false
        
        customDictionaries?.removeAll()
        onlineDictionaries?.removeAll()
        tableView.reloadData()
        fetchOnline()
    }
    
    func fetchOnline() {
        let dataURL = NSURL(string: "http://rthakohov.3dn.ru/dictionaries.json")!
        
        let qos = Int(QOS_CLASS_USER_INITIATED.value)
        
        dispatch_async(dispatch_get_global_queue(qos, 0), { () -> Void in
            let data = NSData(contentsOfURL: dataURL)
            
            if let unwrappedData = data {
                let dataArray = NSJSONSerialization.JSONObjectWithData(unwrappedData, options: nil, error: nil) as! NSArray
                
                for var i = 0; i < dataArray.count; i++ {
                    let dict = dataArray[i] as! NSDictionary
                    
                    let dictObject = Dictionary.addDictionary(dict.valueForKey("id") as! NSNumber, name: dict.valueForKey("name") as! String, language: dict.valueForKey("language") as! String, difficulty: dict.valueForKey("difficulty") as! NSNumber, custom: dict.valueForKey("custom") as! Bool)
                    
                    let words = dict.valueForKey("words") as! Array<String>
                    for word in words {
                        let wordObject = Word.addWord(word)
                        if let unwrappedObject = wordObject {
                            dictObject.addWord(unwrappedObject)
                        } else {
                            println("failed to add word \(word)")
                        }
                    }
                }
                
            } else {
                println("failed to load json file")
            }
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.fetchLocal()
            })
            
        })

    }
    
    func fetchLocal() {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        
        let qos = Int(QOS_CLASS_USER_INITIATED.value)
        
        dispatch_async(dispatch_get_global_queue(qos, 0), { () -> Void in
            let fetchRequest = NSFetchRequest(entityName: "Dictionary")
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "difficulty", ascending: true)]
            var error: NSError?
            let fetchedResults = managedContext.executeFetchRequest(fetchRequest, error: &error) as? [Dictionary]
            
            if let results = fetchedResults {
                var customDicts = [Dictionary]()
                var onlineDicts = [Dictionary]()
                
                for dict in results {
                    if dict.custom == true {
                        customDicts.append(dict)
                    } else {
                        onlineDicts.append(dict)
                    }
                }
                
                self.customDictionaries = customDicts
                self.onlineDictionaries = onlineDicts
            }
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.tableView.reloadData()
                
                self.updateButton.enabled = true
                self.addButton.enabled = true
            })
        })
        
    }

    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return (indexPath.section == 1)
    }

    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let managedContext = appDelegate.managedObjectContext!
            managedContext.deleteObject(customDictionaries![indexPath.row])
            
            if managedContext.save(nil) == false {
                println("failed to delete dict from db")
                return
            }
            
            customDictionaries?.removeAtIndex(indexPath.row)
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

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        
        if let identifier = segue.identifier {
            switch identifier {
            case Storyboard.SegueIdentifier:
                if let wvc = segue.destinationViewController as? WordsTVC {
                    let cell = sender as! UITableViewCell
                    let index = tableView.indexPathForCell(cell)!
                    var dict: Dictionary
                    var words = [Word]()
                    if index.section == 0 {
                        dict = onlineDictionaries![index.row]
                    } else {
                        dict = customDictionaries![index.row]
                    }
                    for word in dict.words {
                        words.append(word as! Word)
                    }
                    wvc.words = words
                    wvc.dictionary = dict
                    wvc.title = dict.name
                }
                
            default:
                break
            }
        }
    }
    
    @IBAction func goBack(sender: UIStoryboardSegue) {
        if let advc = sender.sourceViewController as? AddDictionaryVC {
            let qos = Int(QOS_CLASS_USER_INITIATED.value)
            
            dispatch_async(dispatch_get_global_queue(qos, 0), { () -> Void in
                let id = (Dictionary.countDicts() ?? 0) + Storyboard.CustomID
                let dict = Dictionary.addDictionary(id, name: advc.name!, language: advc.language!, difficulty: advc.difficulty!, custom: true)
                self.customDictionaries?.append(dict)
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.tableView.reloadData()
                })
            })
        }
    }

}
