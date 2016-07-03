//
//  RemoteServiceBrowser.swift
//  ArduinoRemote
//
//  Created by Tristan Pollard on 2016-06-18.
//  Copyright © 2016 Tristan Pollard. All rights reserved.
//

import Foundation
import CocoaAsyncSocket

@objc protocol RemoteServiceBrowserDelegate{
    optional func servicesDidChange();
    optional func didDisconnect();
    optional func didConnect();
}

class RemoteServiceBrowser: NSObject, NSNetServiceDelegate, NSNetServiceBrowserDelegate, GCDAsyncSocketDelegate {
    
    
    var socket: GCDAsyncSocket!
    var serviceList: NSMutableArray!
    var serviceBrowser: NSNetServiceBrowser!
    var service: NSNetService!
    var delegate: RemoteServiceBrowserDelegate?
    var packetsSent = 0
    
    func isConnectedToService(rService: NSNetService) -> Bool{
        if let temp = service{
            return (temp == rService && socket.isConnected)
        }
        
        return false
    }
    
    func startBrowser(){
        print("Browsing started...")
        if (serviceList != nil){
            serviceList.removeAllObjects()
        }else{
            serviceList = NSMutableArray()
        }
        
        serviceBrowser = NSNetServiceBrowser()
        serviceBrowser.delegate = self
        serviceBrowser.searchForServicesOfType("_tcp._tcp", inDomain: "")
        
    }
    
    func restart(){
        if let temp = socket{
            socket.disconnect()
        }
        serviceList.removeAllObjects()
        delegate?.servicesDidChange!()
        serviceBrowser.stop()
        serviceBrowser.searchForServicesOfType("_tcp._tcp", inDomain: "")
    }
    
    func netServiceBrowser(browser: NSNetServiceBrowser, didRemoveService service: NSNetService, moreComing: Bool) {
        if let serve = self.service{
            if serve == service{
                socket.disconnect()
            }
        }
        serviceList.removeObject(service)
        print("Lost service \(service.name)")
        delegate?.servicesDidChange!()
    }
    
    func netServiceBrowser(browser: NSNetServiceBrowser, didFindService service: NSNetService, moreComing: Bool) {
        serviceList.addObject(service)
        print("Found Service: \(service.name)")
        delegate?.servicesDidChange!()
    }
    
    
    func connectToService(rService: NSNetService){
        service = rService
        service.delegate = self;
        service.resolveWithTimeout(30.0)
    }
    
    func netServiceDidResolveAddress(sender: NSNetService) {
        print("\(sender.addresses)")
        if connectWithService(sender){
            
        }else{
            print("Not Connected")
        }
    }
    
    func writeData(data: NSData){
        if (!socket.isConnected){
            connectToService(service)
            return 
        }
        socket.writeData(data, withTimeout: 30.0, tag: packetsSent)
        packetsSent++
    }
    
    func writePacket(packet: RemotePacket){
        if (!socket.isConnected){
            connectToService(service)
            return
        }
        
        print("Writing Packet\n")
        print(packet.encodePacket())
        socket.writeData(packet.encodePacket(), withTimeout: 10.0, tag: packetsSent)
        packetsSent++
    }

    
    func socket(sock: GCDAsyncSocket!, didConnectToHost host: String!, port: UInt16) {
        print("CONNECTED")
        print(host)
        print(sock.connectedPort)
        delegate?.didConnect!()
    }
    
    func socketDidDisconnect(sock: GCDAsyncSocket!, withError err: NSError!) {
        delegate?.didDisconnect!()
    }
    
    private func connectWithService(sender: NSNetService) -> Bool{
        var connected = false
        var count = 0
        
        let addresses: NSArray = sender.addresses!
        
        if (socket == nil || !socket.isConnected){
            socket = GCDAsyncSocket(delegate: self, delegateQueue: dispatch_get_main_queue())
            
            while (!connected && addresses.count > count){
                let address: NSData = addresses.objectAtIndex(count) as! NSData
                count += 1
                do {
                    try socket.connectToAddress(address)
                }catch{
                    print("Failed to Connect")
                }
            }
            
        }
        
        return connected
    }
    
    func socket(sock: GCDAsyncSocket!, didWriteDataWithTag tag: Int) {
        print("Data wrote \(tag)")
    }
    
    func getServiceList() -> NSArray{
        return serviceList as NSArray
    }
}

