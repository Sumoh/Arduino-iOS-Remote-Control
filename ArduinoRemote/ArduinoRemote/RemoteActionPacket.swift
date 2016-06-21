//
//  RemoteActionPacket.swift
//  ArduinoRemote
//
//  Created by Tristan Pollard on 2016-06-20.
//  Copyright © 2016 Tristan Pollard. All rights reserved.
//

import Foundation

@objc(RemoteActionPacket)
class RemoteActionPacket : RemotePacket{
   
    var action: RemoteAction!
    let type = PacketType.actionPacket
    
    override func encodePacket() -> NSData {
        
        let data = NSMutableData()
        
        data.appendData(packetTypeToData(type))
        
        let desc = action.description
        data.appendData(encodeString(desc))
        
        let byteArr = action.rawCode
        data.appendData(encodeInt16Array(byteArr))
        
        data.appendData(endPacketData())
        
        return data
    }
    
    convenience init(action: RemoteAction) {
        self.init()
        self.action = action
    }
    

}