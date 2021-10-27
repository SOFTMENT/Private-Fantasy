//
//  Messages.swift
//  private fantasy
//
//  Created by Apple on 05/08/21.
//

import UIKit


class Messages : NSObject, Codable {


    var message : String?
    var sender : String?
    var type : String?
    var image : String?
    var name : String?
    var messageId : String?
    var dateandtime : Date = Date()
    
    private static var message  : Messages?
    
    static var data : Messages? {
        set(message) {
            self.message = message
        }
        get {
            return message
        }
    }


    override init() {
        
    }
    
   
    
}
