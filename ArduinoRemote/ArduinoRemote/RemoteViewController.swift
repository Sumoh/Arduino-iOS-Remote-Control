//
//  RemoteViewController.swift
//  ArduinoRemote
//
//  Created by Tristan Pollard on 2016-06-19.
//  Copyright © 2016 Tristan Pollard. All rights reserved.
//

import UIKit

class RemoteViewController: UIViewController {

    @IBOutlet weak var dalabel: UILabel!
    var text = "Hello"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dalabel.text = text
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
