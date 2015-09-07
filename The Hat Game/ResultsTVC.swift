//
//  ResultsTVC.swift
//  The Hat
//
//  Created by Руслан Тхакохов on 06.08.15.
//  Copyright (c) 2015 Руслан Тхакохов. All rights reserved.
//

import UIKit

class ResultsTVC: UITableViewController {

    private struct Storyboard {
        static let ReuseIdentifier = "Result Cell"
    }
    
    var pairs: [Pair]? {
        didSet {
            if pairs != nil {
                sort(&pairs!, {$0.score > $1.score})
            }
        }
    }
    
    @IBAction func finish(sender: AnyObject) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return pairs?.count ?? 0
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.ReuseIdentifier, forIndexPath: indexPath) as! UITableViewCell

        let pair = pairs![indexPath.row]
        cell.textLabel?.text = "\(pair)"

        return cell
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
