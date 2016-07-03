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
        
        let desc = encodeString(action.description)
        
        let byteArr = encodeInt16Array(action.rawCode)
        
        let endData = endPacketData()
        
        var length: UInt16 = UInt16(desc.length + byteArr.length + endData.length)
        data.appendBytes(&length, length: sizeof(UInt16))
        
        data.appendData(desc)
        data.appendData(byteArr)
        data.appendData(endData)
        
        return data
    }
    
    convenience init(action: RemoteAction) {
        self.init()
        self.action = action
    }
    

}