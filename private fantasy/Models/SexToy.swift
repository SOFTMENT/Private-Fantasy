//
//  SexToys.swift
//  private fantasy
//
//  Created by Apple on 10/10/21.
//

import UIKit

class SexToy : NSObject, Codable {
    
    var pTitle : String?
    var pDesc : String?
    var pPrice : Double?
    var pImages : [String : String]?
    var pId : String?
    var pDate : Date?
    var isActive : Bool?
    
    override init() {
        
    }
}
