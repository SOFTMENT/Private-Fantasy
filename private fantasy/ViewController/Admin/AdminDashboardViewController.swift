//
//  AdminDashboardViewController.swift
//  private fantasy
//
//  Created by Apple on 12/10/21.
//

import UIKit

class AdminDashboardViewController : UIViewController {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var manageSexToys: UIView!
    @IBOutlet weak var ordersHistory: UIView!
    @IBOutlet weak var sendPushNotification: UIView!
    @IBOutlet weak var mView: UIView!
    
    override func viewDidLoad() {
        
        mView.layer.cornerRadius = 12
        backView.layer.cornerRadius = 12
        manageSexToys.layer.cornerRadius = 8
        ordersHistory.layer.cornerRadius = 8
        sendPushNotification.layer.cornerRadius = 8
        
        
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)))
        
        backView.isUserInteractionEnabled = true
        backView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(backBtnClicked)))
        
        manageSexToys.isUserInteractionEnabled = true
        manageSexToys.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(manageSexToysBtnClicked)))
        
        ordersHistory.isUserInteractionEnabled = true
        ordersHistory.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(orderHistoryBtnClicked)))
        
        sendPushNotification.isUserInteractionEnabled = true
        sendPushNotification.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(sendPushNotificationBtnClicked)))
        
    }
    
    @objc func manageSexToysBtnClicked(){
        performSegue(withIdentifier: "manageSexToysSeg", sender: nil)
    }
    
    @objc func orderHistoryBtnClicked(){
        
    }
    
    
    @objc func sendPushNotificationBtnClicked(){
        self.sendPushNotification()
    }
    
    
    @objc func backBtnClicked(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func hideKeyboard() {
        self.view.endEditing(true)
    }
        
}
