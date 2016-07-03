//
//  RemoteAction.swift
//  ArduinoRemote
//
//  Created by Tristan Pollard on 2016-06-20.
//  Copyright © 2016 Tristan Pollard. All rights reserved.
//

import Foundation

class RemoteAction{
    var rawCode: [UInt16]!
    var description: String!
    
    init(code: [UInt16], descrip: String){
        rawCode = code
        description = descrip
    }
}