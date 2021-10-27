//
//  ChoosePFMViewController.swift
//  private fantasy
//
//  Created by Apple on 04/08/21.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseMessaging

class ChoosePFMViewController: UIViewController {
   
    

    @IBOutlet weak var settingsView: UIImageView!
    @IBOutlet weak var shop: UIView!
    @IBOutlet weak var version: UILabel!
    @IBOutlet weak var couples: UIView!
    @IBOutlet weak var female: UIView!
    @IBOutlet weak var male: UIView!
    @IBOutlet weak var mView: UIView!
    override func viewDidLoad() {
        mView.dropShadow()
        mView.layer.cornerRadius = 12
        male.layer.cornerRadius = 8
        female.layer.cornerRadius = 8
        couples.layer.cornerRadius = 8
        shop.layer.cornerRadius = 8
        
    
        
        male.isUserInteractionEnabled = true
        female.isUserInteractionEnabled = true
        couples.isUserInteractionEnabled = true
        shop.isUserInteractionEnabled = true
        
        male.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(maleClicked)))
        
        female.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(femaleClicked)))
        
        couples.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(couplesClicked)))
        
        shop.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(shopClicked)))
        
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        
        version.text = "Version \(appVersion ?? "v1.0")"
        
        if User.data != nil {
            updateFCMToken()
        }
        
      
        settingsView.isUserInteractionEnabled = true
        settingsView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(settingsViewClicked)))
    }
    
    @objc func settingsViewClicked(){
        performSegue(withIdentifier: "homeSettingsSeg", sender: nil)
    }
    

    
    
    
    func updateFCMToken(){
        User.data?.token = Messaging.messaging().fcmToken
        Firestore.firestore().collection("Users").document(User.data!.uid!).setData(["token" : Messaging.messaging().fcmToken ?? ""], merge: true)
    }
    
    @objc func shopClicked(){
        performSegue(withIdentifier: "servicesSeg", sender: nil)
    }
    
    
    @objc func maleClicked() {
        performSegue(withIdentifier: "prepareQuestionSeg", sender: "male")
    }
    
    @objc func femaleClicked() {
        performSegue(withIdentifier: "prepareQuestionSeg", sender: "female")
    }
    
    @objc func couplesClicked() {
        performSegue(withIdentifier: "prepareQuestionSeg", sender: "couples")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "prepareQuestionSeg" {
            if let destination = segue.destination as? PreparingQuestionViewController{
                if let intrest = sender as? String {
                    destination.intrest = intrest
                }
            }
        }
        else if segue.identifier == "homeSettingsSeg" {
            if let vc = segue.destination as?  SettingsViewController {
                vc.viewControllerName = "home"
            }
        }
        
        
    }
    
}
