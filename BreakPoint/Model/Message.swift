//
//  Message.swift
//  BreakPoint
//
//  Created by Vivek Rai on 13/10/18.
//  Copyright © 2018 Vivek Rai. All rights reserved.
//

import Foundation

class Message{
    private var _content: String
    private var _senderid: String
    
    var content: String{
        return _content
    }
    
    var senderId: String{
        return _senderid
    }
    
    init(content: String, sendrId: String) {
        self._content = content
        self._senderid = sendrId
    }
}
