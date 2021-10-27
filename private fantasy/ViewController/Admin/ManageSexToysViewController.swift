//
//  ManageSexToysViewController.swift
//  private fantasy
//
//  Created by Apple on 11/10/21.
//

import UIKit
import Firebase

class ManageSexToysViewController : UIViewController {
    
    @IBOutlet weak var addproductView: UIView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var tableView: UITableView!
    var sexToys = Array<SexToy>()
    @IBOutlet weak var no_products_avilable: UILabel!
    
    override func viewDidLoad() {
        
        
        
        tableView.delegate = self
        tableView.dataSource = self
        
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)))
        
        backView.isUserInteractionEnabled = true
        backView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(backBtnClicked)))
        
        backView.layer.cornerRadius = 12
        addproductView.layer.cornerRadius = 12
        
        addproductView.isUserInteractionEnabled = true
        addproductView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addProductBtnClicked)))
        
        getSexToysProducts()
    }
    
    
    @objc func addProductBtnClicked(){
        performSegue(withIdentifier: "addsextoyseg", sender: nil)
    }
    
    
    @objc func getSexToysProducts() {
        
        ProgressHUDShow(text: "Loading...")
        Firestore.firestore().collection("SexToys").order(by: "pDate", descending: true).addSnapshotListener { snapshot, error in
            
            self.ProgressHUDHide()
            if let error = error {
                self.showError(error.localizedDescription)
            }
            else {
                self.sexToys.removeAll()
                if let snapshot = snapshot, !snapshot.isEmpty {
                    for qdr in snapshot.documents {
                       
                        if let sexToy = try? qdr.data(as: SexToy.self) {
                            
                            self.sexToys.append(sexToy)
                        }
                    }
                    self.tableView.reloadData()
                    
                }
               
            }
        }
        
    }
    
    

    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    @objc func backBtnClicked() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func isActiveBtnClicked(gest : MyGesture){
        gest.isActiveBtn.isSelected.toggle()
        if gest.isActiveBtn.isSelected {
            self.showToast(message: "Product has Activated")
        }
        else {
            self.showToast(message: "Product has De-Activated")
        }
        
        Firestore.firestore().collection("SexToys").document(gest.id).setData(["isActive" : gest.isActiveBtn.isSelected],merge: true)
    }
    
    @objc func deleteBtnClicked(gest : MyGesture) {
        
        let deleteAlert = UIAlertController(title: "DELETE", message: "Are you sure you want to delete this product?", preferredStyle: .alert)
        deleteAlert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { action in
            self.ProgressHUDShow(text: "Deleting...")
            Firestore.firestore().collection("SexToys").document(gest.id).delete { error in
                
                self.ProgressHUDHide()
                if let error = error {
                    self.showError(error.localizedDescription)
                }
                else {
                    self.showSnack(messages: "Deleted")
                }
                
            }
        }))
        
        deleteAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(deleteAlert, animated: true, completion: nil)
     
    }
    
 
    
}

extension ManageSexToysViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if sexToys.count > 0 {
            no_products_avilable.isHidden = true
        }
        else {
            no_products_avilable.isHidden = false
        }
        return sexToys.count
    }
    
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "adminSexToysCell", for: indexPath) as? SexToysAdminPanelCell {
            
            
            let sexToy = sexToys[indexPath.row]
            
            cell.pView.layer.cornerRadius = 8
            cell.pImage.layer.cornerRadius = 6
            
            cell.pPrice.text = String(format: "%.2f", sexToy.pPrice ?? 0.0)
            cell.pTitle.text = sexToy.pTitle ?? "Product Title"
            
            if let images = sexToy.pImages, images.count > 0 {
                cell.pImage.sd_setImage(with: URL(string: images["one"]!), placeholderImage: UIImage(named: "placeholder"), options: .continueInBackground, completed: nil)
            }
            
            
            cell.isActiveBtn.isSelected = false
            if let isActive = sexToy.isActive, isActive {
                cell.isActiveBtn.isSelected = true
            }
            cell.isActiveBtn.isUserInteractionEnabled = true

            let isActiveGest = MyGesture(target: self, action: #selector(isActiveBtnClicked(gest:)))
            isActiveGest.id = sexToy.pId ?? "0"
            isActiveGest.isActiveBtn = cell.isActiveBtn
            cell.isActiveBtn.addGestureRecognizer(isActiveGest)
            
            
            cell.pDeleteBtn.isUserInteractionEnabled = true
            let deleteGest = MyGesture(target: self, action: #selector(deleteBtnClicked(gest:)))
            deleteGest.id = sexToy.pId ?? "0"
            cell.pDeleteBtn.addGestureRecognizer(deleteGest)
            return cell
        }
        return SexToysAdminPanelCell()
    }

    
}
