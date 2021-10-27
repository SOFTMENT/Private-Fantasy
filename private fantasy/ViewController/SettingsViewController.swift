//
//  SettingsViewControlle.swift
//  private fantasy
//
//  Created by Apple on 10/10/21.
//

import UIKit
import CropViewController
import Firebase
import FirebaseFirestoreSwift

class SettingsViewController : UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate, CropViewControllerDelegate{
    
    @IBOutlet weak var orderHistoryView: UIView!
    
    @IBOutlet weak var sexualServicesView: UIView!
    @IBOutlet weak var mProfilePic: UIImageView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var mEmail: UILabel!
    @IBOutlet weak var mName: UILabel!
    @IBOutlet weak var conversationView: UIView!
    @IBOutlet weak var findNewView: UIView!
    @IBOutlet weak var shopView: UIView!
    @IBOutlet weak var logoutView: UIView!
    @IBOutlet weak var version: UILabel!
    var viewControllerName : String = "name"
    @IBOutlet weak var adminBtn: UIButton!
    var isImageUpdated = false
    
    
    override func viewDidLoad() {
        
        guard let user = User.data else {
            DispatchQueue.main.async {
                self.logout()
            }
            return
        }

        
        backView.layer.cornerRadius = 12
        mProfilePic.makeRounded()
        
        backView.isUserInteractionEnabled = true
        backView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(backBtnClicked)))
        
        conversationView.isUserInteractionEnabled = true
        
        conversationView.isUserInteractionEnabled = true
        conversationView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(conversationBtnClicked)))
        
        findNewView.isUserInteractionEnabled = true
        findNewView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(findNewViewBtnClicked)))
        
        shopView.isUserInteractionEnabled = true
        shopView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(shopViewBtnClicked)))
        
        logoutView.isUserInteractionEnabled = true
        logoutView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(logoutBtnClicked)))
        
        if let profilePic = user.profilePicture {
            mProfilePic.sd_setImage(with: URL(string: profilePic), placeholderImage: UIImage(named: "placeholder"), options: .continueInBackground, completed: nil)
        }
        
        mName.text = user.name ?? "User Name"
        mEmail.text = user.email ?? "UserEmailAddress@gmail.com"
            
        adminBtn.layer.cornerRadius = 8
        
        if user.email == "yaldaame@gmail.com" {
            adminBtn.isHidden = false
        }
        
        mProfilePic.isUserInteractionEnabled = true
        mProfilePic.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(profilePicBtnClicked)))
        
        orderHistoryView.isUserInteractionEnabled = true
        orderHistoryView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(orderHistoryBtnClicked)))
        
        
        sexualServicesView.isUserInteractionEnabled = true
        sexualServicesView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(sexualServicesBtnClicked)))
        
    }
    
    @objc func sexualServicesBtnClicked(){
        performSegue(withIdentifier: "managesexualseg", sender: nil)
    }
    
    @objc func orderHistoryBtnClicked(){
        performSegue(withIdentifier: "orderhistoryseg", sender: nil)
    }
    
    @objc func profilePicBtnClicked(){
        changeProfilePic()
    }
    
    func changeProfilePic() {
        
        let alert = UIAlertController(title: "Upload Profile Picture", message: "", preferredStyle: .alert)
        let action1 = UIAlertAction(title: "Using Camera", style: .default) { (action) in
            
            let image = UIImagePickerController()
            image.title = "Profile Picture"
            image.delegate = self
            image.sourceType = .camera
            
            self.present(image,animated: true)
            
            
        }
        
        let action2 = UIAlertAction(title: "From Photo Library", style: .default) { (action) in
            
            let image = UIImagePickerController()
            image.delegate = self
            image.title = "Profile Picture"
            image.sourceType = .photoLibrary
            
            self.present(image,animated: true)
            
            
        }
        
        let action3 = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            
            alert.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(action1)
        alert.addAction(action2)
        alert.addAction(action3)
        
        self.present(alert,animated: true,completion: nil)
        
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[.originalImage] as? UIImage {
            
            
            
            self.dismiss(animated: true) {
                
                let cropViewController = CropViewController(image: editedImage)
                cropViewController.title = picker.title
                cropViewController.delegate = self
                
                cropViewController.customAspectRatio = CGSize(width: 1, height: 1)
                
                
                
                cropViewController.aspectRatioLockEnabled = true
                cropViewController.aspectRatioPickerButtonHidden = true
                self.present(cropViewController, animated: true, completion: nil)
            }
            
            
            
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        
        self.ProgressHUDShow(text: "Updating...")
        
        
        mProfilePic.image = image
        
        uploadImageOnFirebase{downloadURL in
            
            print(downloadURL)
            User.data?.profilePicture  = downloadURL
            Firestore.firestore().collection("Users").document(Auth.auth().currentUser!.uid).setData(["profilePicture" : downloadURL], merge: true) { err in
                self.ProgressHUDHide()
                self.isImageUpdated = true
                if err == nil{
                    
                    self.showSnack(messages: "Updated")
                }
                else {
                    self.showError(err!.localizedDescription)
                }
            }
            
        }
        
        
        
        
        
        
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func uploadImageOnFirebase(completion : @escaping (String) -> Void ) {
        
        let storage = Storage.storage().reference().child("ProfilePicture").child("\(Auth.auth().currentUser?.uid ?? "").png")
        var downloadUrl = ""
        
        var uploadData : Data!
        
        uploadData = (self.mProfilePic.image?.jpegData(compressionQuality: 0.4))!
        
        storage.putData(uploadData, metadata: nil) { (metadata, error) in
            
            if error == nil {
                storage.downloadURL { (url, error) in
                    if error == nil {
                        downloadUrl = url!.absoluteString
                    }
                    completion(downloadUrl)
                    
                }
            }
            else {
                completion(downloadUrl)
            }
            
        }
    }
    
    @IBAction func adminBtnClicked(_ sender: Any) {
        
        performSegue(withIdentifier: "admindashboardseg", sender: nil)
    }
    
    @objc func conversationBtnClicked(){
        if viewControllerName == "conversation" {
            self.dismiss(animated: true, completion: nil)
        }
        else {
            performSegue(withIdentifier: "settingsConversationSeg", sender: nil)
        }
    }
    
    
    @objc func findNewViewBtnClicked() {
        if viewControllerName == "home" {
            self.dismiss(animated: true, completion: nil)
        }
        else {
            performSegue(withIdentifier: "settingsHomeSeg", sender: nil)
        }
    }
    
    @objc func shopViewBtnClicked(){
        
        performSegue(withIdentifier: "settingsShopSeg", sender: nil)
        
    }
    
    @objc func logoutBtnClicked() {
        self.logout()
    }
    
    @objc func backBtnClicked(){
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
}


