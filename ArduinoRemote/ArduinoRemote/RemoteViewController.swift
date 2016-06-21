//
//  RemoteViewController.swift
//  ArduinoRemote
//
//  Created by Tristan Pollard on 2016-06-19.
//  Copyright © 2016 Tristan Pollard. All rights reserved.
//

import UIKit

class RemoteViewController: UIViewController, RemoteServiceBrowserDelegate {

    @IBOutlet weak var dalabel: UILabel!
    var text = "Hello"
    var browser: RemoteServiceBrowser?
    
    @IBAction func powerPressed(sender: AnyObject) {
        if let browse = browser{
            let code: [UInt16] = [4470, 4380, 610, 1600, 600, 1640, 600, 1600, 620, 480, 620, 500, 610, 490, 610, 510, 600, 510, 600, 1600, 610, 1590, 620, 1610, 590, 520, 600, 510, 590, 510, 590, 510, 610, 490, 610, 510, 590, 1630, 570, 540, 580, 520, 590, 510, 600, 500, 590, 510, 600, 520, 590, 1630, 590, 520, 570, 1630, 600, 1610, 600, 1620, 590, 1630, 590, 1610, 600, 1620, 590];
            
            let action = RemoteAction(code: code, descrip: "Power Packet")
            let packet = RemoteActionPacket(action: action)
            browse.writePacket(packet)
        }else{
            print("Browser nil")
        }
    }
    
    func didConnect() {
        dalabel.text! = "\(text) - Connected"
    }
    
    func didDisconnect() {
        dalabel.text! = "\(text) - Disconnected"
    }
    
    func servicesDidChange() {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dalabel.text = text
    }
    
    override func viewWillAppear(animated: Bool) {
        browser?.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    

}
