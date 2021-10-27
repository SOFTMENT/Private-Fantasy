//
//  SexToysViewController.swift
//  private fantasy
//
//  Created by Apple on 10/10/21.
//

import UIKit
import FirebaseFirestore
import Firebase

class SexToysViewController : UIViewController {
    
    @IBOutlet weak var no_products_available: UILabel!
    @IBOutlet weak var searchET: UITextField!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    var sexToys = Array<SexToy>()
    var sexToysAfterFilter = Array<SexToy>()

    override func viewDidLoad() {
        
        
        backView.layer.cornerRadius = 12
        searchET.delegate = self

        
        collectionView.delegate = self
        collectionView.dataSource = self
    
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: (self.collectionView.bounds.width / 2.08 ) , height: self.collectionView.bounds.width / 2.08 + 50 )
        flowLayout.scrollDirection = UICollectionView.ScrollDirection.vertical
        flowLayout.minimumInteritemSpacing = 0
        self.collectionView.collectionViewLayout = flowLayout
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)))
        
        searchET.setLeftIcons(icon: UIImage(named: "serach")!)
        searchET.attributedPlaceholder = NSAttributedString(string: "Search",
                                                            attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(red: 231/255, green: 231/255, blue: 231/255, alpha: 1)])
        
        searchET.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        backView.isUserInteractionEnabled = true
        backView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(backBtnClicked)))
        
        //getProducts
        getSexToysProducts()
    }
    
    @objc func cellClicked(value : MyGesture){
        
        performSegue(withIdentifier: "checkoutseg", sender: value.sexToy)
    }
    
    @objc func backBtnClicked(){
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @objc func getSexToysProducts() {
        
        ProgressHUDShow(text: "Loading...")
        Firestore.firestore().collection("SexToys").order(by: "pDate", descending: true).whereField("isActive", isEqualTo: true).getDocuments { snapshot, error in
            self.ProgressHUDHide()
            if let error = error {
                self.showError(error.localizedDescription)
            }
            else {
                self.sexToys.removeAll()
                if let snapshot = snapshot, !snapshot.isEmpty {
                    for qdr in snapshot.documents {
                        if let sexToy = try? qdr.data(as: SexToy.self, decoder: nil) {
                            self.sexToys.append(sexToy)
                        }
                    }
                }
                
                self.filter(value: "")
            }
        }
        
    }
    
    @objc func hideKeyboard(){
        self.view.endEditing(true)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        filter(value: textField.text!)
    }
    
    public func filter(value : String){
        sexToysAfterFilter.removeAll()
        sexToysAfterFilter =  sexToys.filter { sexToy in
            if value == "" || sexToy.pTitle!.lowercased().contains(value.lowercased())  {
                return true
            }
            else {
                return false
            }
        }
        
        collectionView.reloadData()
        collectionView.layoutIfNeeded()
      
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "checkoutseg" {
            if let vc = segue.destination as? CheckoutViewController {
                if let sexToy = sender as? SexToy {
                    vc.sexToy = sexToy
                }
            }
        }
    }
}


extension SexToysViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    
   
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if sexToysAfterFilter.count > 0 {
            no_products_available.isHidden = true
        }
        else {
            no_products_available.isHidden = false
        }
        return sexToysAfterFilter.count
    }
    

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
       
            
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "sexToysCell", for: indexPath) as? SexToysCollectionViewCell {
                
                let sexToy = sexToys[indexPath.row]
                
                if let images = sexToy.pImages, images.count > 0 {
                    cell.productImage.sd_setImage(with: URL(string: images["one"]!), placeholderImage: UIImage(named: "placeholder"), options: .continueInBackground, completed: nil)
                }
                
                cell.productTitle.text = sexToy.pTitle ?? "Product Title"
                cell.productPrice.text = String(format: "%.2f", sexToy.pPrice ?? 0.0)
                
                let myTap = MyGesture(target: self, action: #selector(cellClicked(value:)))
                myTap.sexToy = sexToy
                cell.addGestureRecognizer(myTap)
                return cell
                
            }
            
            return SexToysCollectionViewCell()
        }
    
}

extension SexToysViewController :  UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
}


