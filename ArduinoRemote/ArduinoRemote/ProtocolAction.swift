//
//  Action.swift
//  ArduinoRemote
//
//  Created by Tristan Pollard on 2016-06-23.
//  Copyright © 2016 Tristan Pollard. All rights reserved.
//

import Foundation

protocol Action {
    func decodePacket()
}