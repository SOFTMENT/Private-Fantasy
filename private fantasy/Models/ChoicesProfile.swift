//
//  ChoicesProfile.swift
//  private fantasy
//
//  Created by Apple on 04/08/21.
//

import UIKit

class ChoicesProfile: NSObject, Codable {
    
    var choices : [String : Bool]?
    var uid : String?
    var profileImage : String?
    var name : String?
    var time : Date?
    var score : Float?
    var token : String?
    
    
    override init() {
       
    }
    
}
