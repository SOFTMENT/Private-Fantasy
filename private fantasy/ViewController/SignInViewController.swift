//
//  ViewController.swift
//  private fantasy
//
//  Created by Vijay Rathore on 27/07/21.
//

import UIKit
import FirebaseAuth
import Firebase
import IQKeyboardManagerSwift

class SignInViewController: UIViewController {

    @IBOutlet weak var mView: UIView!
    @IBOutlet weak var signInView: UIView!
    @IBOutlet weak var etEmail: UITextField!
    @IBOutlet weak var etPassword: UITextField!
    @IBOutlet weak var signUp: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
  
        
        signInView.layer.cornerRadius = 20
        mView.layer.cornerRadius = 12
        mView.dropShadow()
        
        etEmail.layer.cornerRadius = 6
        etPassword.layer.cornerRadius = 6
        
        etEmail.setLeftPaddingPoints(10)
        etEmail.setRightPaddingPoints(10)
        
        etEmail.delegate = self
        etPassword.delegate = self
        
        etPassword.setLeftPaddingPoints(10)
        etPassword.setRightPaddingPoints(10)
        
        signInView.isUserInteractionEnabled = true
        signInView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(signInBtnClicked)))
        
        signUp.isUserInteractionEnabled = true
        signUp.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(gotoSignUpScreen)))
        
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)))
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        IQKeyboardManager.shared.enable = false
    }
    
    @objc func hideKeyboard(){
        self.view.endEditing(true)
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
                        self.getUserData(uid: user.uid, showProgress: true)
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


extension SignInViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
    }
}
