//
//  CheckoutViewController.swift
//  private fantasy
//
//  Created by Apple on 12/10/21.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift
import IQKeyboardManagerSwift

class CheckoutViewController : UIViewController {
    
    @IBOutlet weak var myPageView: UIPageControl!
    @IBOutlet weak var myCollectionView: UICollectionView!
    var timer = Timer()
    var counter = 0
    var sexToy : SexToy?
    var imageArr = Array<String>()

    @IBOutlet weak var mView: UIView!
    
   
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var contactNumber: UITextField!
    @IBOutlet weak var deliveryAddress: UITextField!
    @IBOutlet weak var payment: UILabel!
    
    @IBOutlet weak var payBtn: UIView!
    
    override func viewDidLoad() {
        
        guard let sexToy = sexToy else{
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
            return
        }
        
 
        myCollectionView.delegate = self
        myCollectionView.dataSource = self
    
        if let images = sexToy.pImages {
            myPageView.numberOfPages = images.count
            
            if let img1 = images["one"] {
          
                imageArr.append(img1)
            }
            if let img2 = images["two"] {
              
                imageArr.append(img2)
            }
            if let img3 = images["three"] {
                imageArr.append(img3)
                print(img3)
            }
            if let img4 = images["four"] {
                imageArr.append(img4)
            }
        }

        productTitle.text = sexToy.pTitle ?? "Product Title"
        payment.text =  String(format: "%.2f", sexToy.pPrice ?? 0.0)
        
        payBtn.layer.cornerRadius = 8
        
        contactNumber.delegate = self
        deliveryAddress.delegate = self
        
        contactNumber.setLeftPaddingPoints(10)
        contactNumber.setRightPaddingPoints(10)
        
        deliveryAddress.setLeftPaddingPoints(10)
        deliveryAddress.setRightPaddingPoints(10)
        
        deliveryAddress.layer.cornerRadius = 8
        contactNumber.layer.cornerRadius = 8
        
        
        myPageView.currentPage = 0
    
        mView.layer.cornerRadius = 12
        backView.layer.cornerRadius = 12
        backView.isUserInteractionEnabled = true
        backView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(backBtnClicked)))
        
        payBtn.isUserInteractionEnabled = true
        payBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(payBtnClicked)))
        
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)))
    }
    
    @objc func hideKeyboard() {
        self.view.endEditing(true)
    }
    
    @objc func backBtnClicked(){
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        IQKeyboardManager.shared.enable = true
    }
    
    @objc func payBtnClicked(){
        
        let sMobileNumber = contactNumber.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let sDelivertAddress = deliveryAddress.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if sMobileNumber == "" {
            self.showSnack(messages: "Enter contact number")
        }
        else if sDelivertAddress == "" {
            self.showSnack(messages: "Enter delivery address")
        }
        else {
            self.ProgressHUDShow(text: "Processing...")
 
            let id = Firestore.firestore().collection("OrderHistory").document().documentID
            Firestore.firestore().collection("OrderHistory").document(id).setData(["image" : sexToy!.pImages!["one"]!, "name" : User.data!.name!, "email" : User.data!.email!, "mobileNumber" : sMobileNumber!, "deliveryAddress" : sDelivertAddress!, "date" : Date(), "orderId" : id, "uid" : Auth.auth().currentUser!.uid, "status" : "In transit", "title" : sexToy!.pTitle ?? "Product title", "price" : sexToy!.pPrice ?? 0.0]) { error in
                self.ProgressHUDHide()
                
                if let error = error {
                    self.showSnack(messages: error.localizedDescription)
                }
                else {
                    let alert = UIAlertController(title: "Successful", message: "We have recived your order request and we will deliver your order within 15 days.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                        self.dismiss(animated: true, completion: nil)
                    }))
                    
                    self.present(alert, animated: true, completion: nil)
                }
            }
            
            
        }
        
    
    }


}


extension CheckoutViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
     
        return imageArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? CheckoutHeadCollectionCell {
            
   
            cell.imgView.sd_setImage(with: URL(string: imageArr[indexPath.row]), placeholderImage: UIImage(named: "placeholder 2"), options: .continueInBackground, completed: nil)
           return cell
        }
    
        return CheckoutHeadCollectionCell()
    }
    
    
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let visibleIndex = Int(targetContentOffset.pointee.x / myCollectionView.frame.width)
        myPageView.currentPage = visibleIndex
        counter = visibleIndex
        
    }
    
    
    
    
}

extension CheckoutViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let size = myCollectionView.frame.size
        return CGSize(width: size.width, height: size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
}


extension CheckoutViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
    }
}
