//
//  TableViewController.swift
//  ArduinoRemote
//
//  Created by Tristan Pollard on 2016-06-18.
//  Copyright © 2016 Tristan Pollard. All rights reserved.
//

import UIKit



class TableViewController: UITableViewController, RemoteServiceBrowserDelegate {
    
    let browser = RemoteServiceBrowser()
    
    @IBAction func refreshList(sender: AnyObject) {
        browser.restart()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        browser.startBrowser()
        browser.delegate = self
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {
        browser.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        //return 2;
        return browser.getServiceList().count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("kCell", forIndexPath: indexPath)
        let service = browser.getServiceList().objectAtIndex(indexPath.row) as! NSNetService
        cell.textLabel?.text = service.name
        cell.detailTextLabel?.text = String(service.port)
        // Configure the cell...

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        performSegueWithIdentifier("selectArduino", sender: self)
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "selectArduino"{
            if let indexPath = tableView.indexPathForSelectedRow{
                browser.connectToService(browser.serviceList.objectAtIndex(indexPath.row) as! NSNetService)
                let destsView = segue.destinationViewController as! RemoteViewController
                destsView.text = "Testing Arduino"
                destsView.browser = browser
            }
        }
    }
    
    func servicesDidChange() {
        tableView.reloadData()
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
