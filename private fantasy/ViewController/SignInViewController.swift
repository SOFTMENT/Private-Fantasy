//
//  ViewController.swift
//  private fantasy
//
//  Created by Vijay Rathore on 27/07/21.
//

import UIKit
import Firebase

class SignInViewController: UIViewController {

    @IBOutlet weak var mView: UIView!
    @IBOutlet weak var signInView: UIView!
    @IBOutlet weak var etEmail: UITextField!
    @IBOutlet weak var etPassword: UITextField!
    @IBOutlet weak var signUp: UILabel!
    let userDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
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
                
               self.getUserData(uid: Auth.auth().currentUser!.uid)
            }
        }
        
        
        signInView.layer.cornerRadius = 20
        mView.layer.cornerRadius = 12
        mView.dropShadow()
        
        etEmail.layer.cornerRadius = 6
        etPassword.layer.cornerRadius = 6
        
        etEmail.setLeftPaddingPoints(10)
        etEmail.setRightPaddingPoints(10)
        
        etPassword.setLeftPaddingPoints(10)
        etPassword.setRightPaddingPoints(10)
        
        signInView.isUserInteractionEnabled = true
        signInView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(signInBtnClicked)))
        
        signUp.isUserInteractionEnabled = true
        signUp.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(gotoSignUpScreen)))
        
        
        
        

    }
    
    @objc func signInBtnClicked(){
        
        guard let sEmail = etEmail.text?.trimmingCharacters(in: .whitespacesAndNewlines) else {
            return
        }
        
        guard let sPassword = etPassword.text?.trimmingCharacters(in: .whitespacesAndNewlines) else {
            return
        }
        
        if sEmail == "" {
            showSnack(messages: "Enter Email")
        }
        else if sPassword == "" {
            showSnack(messages: "Enter Password")
        }
        else {
            ProgressHUDShow(text: "")
            Auth.auth().signIn(withEmail: sEmail, password: sPassword) { result, error in
                self.ProgressHUDHide()
                if error == nil {
                   
                    guard let user = Auth.auth().currentUser else {
                        return
                    }
                    
                    if user.isEmailVerified {
                        self.getUserData(uid: user.uid)
                    }
                    else {
                        self.sendEmailVerificationLink(goBack: false)
                    }
                }
                else {
                    self.handleError(error: error!)
                }
            }
        }
    }
    
    @objc func gotoSignUpScreen(){
       performSegue(withIdentifier: "signupseg", sender: nil)
    }


}

