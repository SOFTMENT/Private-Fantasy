//
//  WelcomeViewController.swift
//  private fantasy
//
//  Created by Apple on 04/08/21.
//

import UIKit
import Firebase
import FirebaseAuth

class WelcomeViewController: UIViewController {
    let userDefaults = UserDefaults.standard
    override func viewDidLoad() {
        
        Messaging.messaging().subscribe(toTopic: "pfm"){ error in
            if error == nil{
                print("Subscribed to topic")
            }
            else{
                print("Not Subscribed to topic")
            }
        }
        
        if userDefaults.value(forKey: "appFirstTimeOpend") == nil {
            //if app is first time opened then it will be nil
            userDefaults.setValue(true, forKey: "appFirstTimeOpend")
            // signOut from FIRAuth
            do {
                try Auth.auth().signOut()
            }catch {

            }
            // go to beginning of app
        }
        
        
        if Auth.auth().currentUser != nil {
            
            if Auth.auth().currentUser!.isEmailVerified {
                
               self.getUserData(uid: Auth.auth().currentUser!.uid,showProgress: false)
            }
            else {
                DispatchQueue.main.async {
                    self.beRootScreen(mIdentifier: Constants.StroyBoard.signInViewController)
                }
            }
        }
        else {
            DispatchQueue.main.async {
                self.beRootScreen(mIdentifier: Constants.StroyBoard.signInViewController)
            }
          
        }
        
        
    }
}
