//
//  ProtocolEncodablePacket.swift
//  ArduinoRemote
//
//  Created by Tristan Pollard on 2016-06-20.
//  Copyright © 2016 Tristan Pollard. All rights reserved.
//

import Foundation

protocol EncodablePacket {
    func encodePacket() -> NSData
}