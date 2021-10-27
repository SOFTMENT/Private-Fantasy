//
//  User.swift
//  private fantasy
//
//  Created by Vijay Rathore on 28/07/21.
//


import Foundation

final class User : NSObject, Codable{
    var name : String?
    var email : String?
    var profilePicture : String?
    var age : Int?
    var gender : String?
    var uid : String?
    var registrationDate : Date?
    var hasMembership : Bool?
    var token : String?
    var hasPlayed : Bool?
    
    private static var userData : User?
    
    static var data : User? {
        set(userData) {
            self.userData = userData
        }
        get {
            return userData
        }
    }

    

    override init() {
       
    }
    
}
