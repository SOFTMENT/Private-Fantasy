//
//  AddSexToysViewController.swift
//  private fantasy
//
//  Created by Apple on 12/10/21.
//

import UIKit
import IQKeyboardManagerSwift

class AddSexToysViewController : UIViewController {
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var mView: UIView!
    @IBOutlet weak var productPrice: UITextField!
    @IBOutlet weak var productTitle: UITextField!
    @IBOutlet weak var nextBtn: UIView!
    override func viewDidLoad() {
        
        backView.layer.cornerRadius = 12
        nextBtn.layer.cornerRadius = 8
        
        mView.layer.cornerRadius = 12
        
        productPrice.layer.cornerRadius = 8
        productTitle.layer.cornerRadius = 8
        
        productTitle.setLeftPaddingPoints(10)
        productTitle.setRightPaddingPoints(10)
        
        productPrice.setLeftPaddingPoints(10)
        productPrice.setLeftPaddingPoints(10)
        
        backView.isUserInteractionEnabled = true
        backView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(backBtnClicked)))
        
        
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)))
        
        nextBtn.isUserInteractionEnabled = true
        nextBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(nextBtnClicked)))
    }
    
    @objc func nextBtnClicked(){
        let sProductTitle = productTitle.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let sProductPrice = productPrice.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if let sProductTitle = sProductTitle, sProductTitle != "" {
            if let sProductPrice = sProductPrice, sProductPrice != "" {
                
                productTitle.text = ""
                productPrice.text = ""
                let value = ["title"  :sProductTitle, "price"  : sProductPrice]
                performSegue(withIdentifier: "sextoyimageseg", sender: value)
                
            }
            else {
                self.showSnack(messages: "Enter product price")
            }
        }
        else {
            self.showSnack(messages: "Enter product title")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        IQKeyboardManager.shared.enable = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "sextoyimageseg" {
            if let vc = segue.destination as? AddSexToysImageViewController {
                if let value = sender as? [String :  String] {
                    vc.productPrice = value["price"]
                    vc.productTitle = value["title"]
                }
            }
        }
    }
    
    @objc func hideKeyboard(){
        self.view.endEditing(true)
    }
    
    @objc func backBtnClicked(){
        self.dismiss(animated: true, completion: nil)
    }
}
