//
//  SignUpViewController.swift
//  private fantasy
//
//  Created by Vijay Rathore on 28/07/21.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift


class SignUpViewController: UIViewController {
    
    @IBOutlet weak var age: UITextField!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var fullName: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var maleBtn: UIButton!
    @IBOutlet weak var femaleBtn: UIButton!
    @IBOutlet weak var otherBtn: UIButton!
    @IBOutlet weak var signUpBtn: UIView!
    @IBOutlet weak var mView: UIView!
    @IBOutlet weak var signInBtn: UILabel!
    var gender = ""
    override func viewDidLoad() {
        
        
        signUpBtn.layer.cornerRadius = 20
        mView.layer.cornerRadius = 12
        mView.dropShadow()
        
        fullName.layer.cornerRadius = 6
        email.layer.cornerRadius = 6
        password.layer.cornerRadius = 6
        age.layer.cornerRadius = 6
        
        fullName.setLeftPaddingPoints(10)
        fullName.setRightPaddingPoints(10)
        
        email.setLeftPaddingPoints(10)
        email.setRightPaddingPoints(10)
        
        password.setLeftPaddingPoints(10)
        password.setRightPaddingPoints(10)
        
        age.setLeftPaddingPoints(10)
        age.setRightPaddingPoints(10)
        
        fullName.delegate = self
        email.delegate = self
        password.delegate = self
        age.delegate = self
        
        backView.layer.cornerRadius = 12
        
        maleBtn.layer.cornerRadius = 12
        femaleBtn.layer.cornerRadius = 12
        otherBtn.layer.cornerRadius = 12
        
        signInBtn.isUserInteractionEnabled = true
        signInBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goBack)))
        
        backView.isUserInteractionEnabled = true
        backView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goBack)))
        
        signUpBtn.isUserInteractionEnabled = true
        signUpBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(signUp)))
        
        
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(UIGestureRecognizer(target: self, action: #selector(hideKeyboard)))
        
        maleBtn.isUserInteractionEnabled = true
        maleBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(maleSelected)))
        
        femaleBtn.isUserInteractionEnabled = true
        femaleBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(femaleSelected)))
        
        otherBtn.isUserInteractionEnabled = true
        otherBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(otherSelected)))
        
       
    }
    
    @objc func signUp() {
      
        guard let sFullName = fullName.text?.trimmingCharacters(in: .whitespacesAndNewlines) else {
            return
        }
        guard let sEmail = email.text?.trimmingCharacters(in: .whitespacesAndNewlines) else {
            return
        }
        guard let sPassword = password.text?.trimmingCharacters(in: .whitespacesAndNewlines) else {
            return
        }
        
        guard let sAge = age.text?.trimmingCharacters(in: .whitespacesAndNewlines) else {
            return
        }
        
        if sFullName == "" {
            showSnack(messages: "Enter Full Name")
        }
        else if sEmail == "" {
            showSnack(messages: "Enter Email Address")
        }
        else if sPassword == "" {
            showSnack(messages: "Enter Password")
        }
        else if gender == "" {
            showSnack(messages: "Select Gender")
        }
        else if sAge == "" {
            showSnack(messages: "Enter Age")
        }
        else {
            ProgressHUDShow(text: "Creating Account...")
            Auth.auth().createUser(withEmail: sEmail, password: sPassword) { authResult, error in
                self.ProgressHUDHide()
                if error == nil {
                    guard let user = Auth.auth().currentUser else {
                        self.showSnack(messages: "Please Sign In Again")
                        return
                    }
                    if let iAge : Int = Int(sAge) {
                        self.addUserData(uid: user.uid, name: sFullName, email: sEmail, gender : self.gender,age: iAge)
                    }
                    else {
                        self.showSnack(messages: "Enter Correct Age")
                    }
                   
                }
                else {
                    self.handleError(error: error!)
                }
            }
        }
        
    }
    
    @objc func maleSelected() {
        gender = "M"
        maleBtn.isSelected = true
        femaleBtn.isSelected = false
        otherBtn.isSelected = false
        
      
     
    }
  
    @objc func femaleSelected() {
        gender = "F"
        
        maleBtn.isSelected = false
        femaleBtn.isSelected = true
        otherBtn.isSelected = false
       
    }
    @objc func otherSelected() {
        gender = "O"
        
        maleBtn.isSelected = false
        femaleBtn.isSelected = false
        otherBtn.isSelected = true
        
       
    }
    
    
    
    
    func addUserData(uid : String, name : String, email : String, gender : String, age : Int) {
        Firestore.firestore().collection("Users").document(uid).setData(["uid" : uid,"name" : name, "email" : email,"gender" : gender,"registrationDate" : FieldValue.serverTimestamp()]) { error in
            
            if error == nil {
                self.sendEmailVerificationLink(goBack: true)
            }
            else {
                self.showError(error!.localizedDescription)
            }
        }
        
    }
    
    @objc func goBack() {
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
}

extension SignUpViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
}
