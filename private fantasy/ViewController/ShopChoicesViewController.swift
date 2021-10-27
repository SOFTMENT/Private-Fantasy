//
//  ShopChoicesViewController.swift
//  private fantasy
//
//  Created by Apple on 10/10/21.
//

import UIKit

class ShopChoicesViewController : UIViewController {
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var mView: UIView!
    @IBOutlet weak var sexToys: UIView!
    @IBOutlet weak var menAndWomanLingerie: UIView!
    @IBOutlet weak var sexualServices: UIView!
    
    override func viewDidLoad() {
        
        mView.layer.cornerRadius = 12
        backView.layer.cornerRadius = 12
        
        sexToys.layer.cornerRadius = 8
        menAndWomanLingerie.layer.cornerRadius = 8
        sexualServices.layer.cornerRadius = 8
        
        sexToys.isUserInteractionEnabled = true
        sexToys.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(sexToysBtnClicked)))
        
        menAndWomanLingerie.isUserInteractionEnabled = true
        menAndWomanLingerie.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(menAndWomanBtnClicked)))
        
        
        sexualServices.isUserInteractionEnabled = true
        sexualServices.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(sexualServicesBtnClicked)))
        
        backView.isUserInteractionEnabled = true
        backView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(backBtnClicked)))
  
    }
    
    @objc func backBtnClicked(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func sexToysBtnClicked(){
        performSegue(withIdentifier: "sexToysSeg", sender: nil)
    }
    
    @objc func menAndWomanBtnClicked(){
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Men Lingerie", style: .default, handler: { action in
            self.performSegue(withIdentifier: "lingerieshopseg", sender: "Men Lingerie")
        }))
        
        alert.addAction(UIAlertAction(title: "Women Lingerie", style: .default,handler: { action in
            self.performSegue(withIdentifier: "lingerieshopseg", sender: "Women Lingerie")
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
       
        present(alert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "lingerieshopseg" {
            if let vc = segue.destination as? MenAndWomenLingerieViewController {
                if let title = sender as? String {
                    vc.mTitle = title
                }
            }
        }
    }
    @objc func sexualServicesBtnClicked() {
        performSegue(withIdentifier: "sexualservicesseg", sender: nil)
    }
}


