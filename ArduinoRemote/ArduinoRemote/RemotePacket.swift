//
//  RemotePacket.swift
//  ArduinoRemote
//
//  Created by Tristan Pollard on 2016-06-20.
//  Copyright © 2016 Tristan Pollard. All rights reserved.
//

import Foundation

enum PacketType: UInt8{
    case integer = 1
    case string = 2
    case byteArr = 3
    case actionPacket = 4
}

class RemotePacket: NSObject, EncodablePacket{
    
    func encodePacket() -> NSData {
        return NSData()
    }
    
    //Byte 1: Type
    //UInt16: Length
    func encodeObject(obj: AnyObject) -> NSData{
        switch obj {
            case let aInt as Int:
                return encodeInt16(UInt16(aInt))
            case let uInt32 as UInt32:
                return encodeInt16(UInt16(uInt32))
            case let uInt16 as UInt16:
                return encodeInt16(uInt16)
            case let uInt8 as UInt8:
                return encodeInt16(UInt16(uInt8))
            case let str as String:
                return encodeString(str)
            case let remoteAction as RemoteActionPacket:
                return remoteAction.encodePacket()
            
            
        default:
            print("Unknown Object")
        }
        
        return NSData()
    }
    
    func encodeInt16Array(arr: [UInt16]) -> NSData{
        
        let data = NSMutableData()
        
        let type = PacketType.byteArr
        data.appendData(packetTypeToData(type))
        
        var length = arr.count*sizeof(UInt16)
        data.appendBytes(&length, length: sizeof(UInt16))
        
        for i in arr{
            var intData = i
            data.appendBytes(&intData, length: sizeof(UInt16))
        }
        
        return data
    }
    
    func encodeString(str: String) -> NSData{
        
        let data = NSMutableData()
        let type = PacketType.string
        data.appendData(packetTypeToData(type))
        
        var length = UInt16(str.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
        data.appendBytes(&length, length: sizeof(UInt16))
        
        let strData = str.dataUsingEncoding(NSUTF8StringEncoding)
        data.appendData(strData!)
        
        return data
    }
    
    func encodeInt16(int: UInt16) -> NSData{
        let data = NSMutableData()
        let type = PacketType.integer
        data.appendData(packetTypeToData(type))
        
        var length = sizeof(UInt16)
        data.appendBytes(&length, length: length)
        
        var intData = int
        data.appendBytes(&intData, length: length)
     
        return data
    }
    
    
    func packetTypeToData(sub: PacketType) -> NSData{
        var type = sub.rawValue
        return NSData(bytes: &type, length: sizeof(UInt8))
    }
    
    func endPacketData() -> NSData{
        var endInt: UInt16 = UInt16(0xffff)
        return NSData(bytes: &endInt, length: sizeof(UInt16))
    }
    
    static func swapUInt16Data(data : NSData) -> NSData {
        
        // Copy data into UInt16 array:
        let count = data.length / sizeof(UInt16)
        var array = [UInt16](count: count, repeatedValue: 0)
        data.getBytes(&array, length: count * sizeof(UInt16))
        
        // Swap each integer:
        for i in 0 ..< count {
            array[i] = array[i].byteSwapped // *** (see below)
        }
        
        // Create NSData from array:
        return NSData(bytes: &array, length: count * sizeof(UInt16))
    }
    
}
