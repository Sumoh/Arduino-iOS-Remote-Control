//
//  RemoteViewController.swift
//  ArduinoRemote
//
//  Created by Tristan Pollard on 2016-06-19.
//  Copyright © 2016 Tristan Pollard. All rights reserved.
//

import UIKit

class RemoteViewController: UITableViewController, RemoteServiceBrowserDelegate {

    var browser: RemoteServiceBrowser?
    var codes: [RemoteAction]?
    
    func didConnect() {
        //dalabel.text! = "\(text) - Connected"
    }
    
    func didDisconnect() {
        //dalabel.text! = "\(text) - Disconnected"
    }
    
    func servicesDidChange() {
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("Selected: \(codes![indexPath.row].description)")
        let packet = RemoteActionPacket(action: codes![indexPath.row])
        browser?.writePacket(packet)
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (codes?.count)!
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("kActionCell", forIndexPath: indexPath)
        cell.textLabel?.text = codes![indexPath.row].description
        cell.detailTextLabel?.text = "Temp"
        return cell
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
 
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let code: [UInt16] = [4470, 4380, 610, 1600, 600, 1640, 600, 1600, 620, 480, 620, 500, 610, 490, 610, 510, 600, 510, 600, 1600, 610, 1590, 620, 1610, 590, 520, 600, 510, 590, 510, 590, 510, 610, 490, 610, 510, 590, 1630, 570, 540, 580, 520, 590, 510, 600, 500, 590, 510, 600, 520, 590, 1630, 590, 520, 570, 1630, 600, 1610, 600, 1620, 590, 1630, 590, 1610, 600, 1620, 590];
        let descrip = "Power"
        let action = RemoteAction(code: code, descrip: descrip)
        codes?.append(action)
    }
    
    override func viewWillAppear(animated: Bool) {
        browser?.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    

}
