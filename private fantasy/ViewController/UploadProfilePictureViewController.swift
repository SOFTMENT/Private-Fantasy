//
//  UploadProfilePictureViewController.swift
//  private fantasy
//
//  Created by Vijay Rathore on 29/07/21.
//

import UIKit
import Firebase
import CropViewController

class UploadProfilePictureViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate, CropViewControllerDelegate  {
    
   
    @IBOutlet weak var mView: UIView!
    @IBOutlet weak var mProfilePic: UIImageView!
    @IBOutlet weak var uplaodBtn: UIButton!
    @IBOutlet weak var continueBtn: UIView!
    
    
    override func viewDidLoad() {
        mView.layer.cornerRadius = 12
        mView.dropShadow()
        
        mProfilePic.makeRounded()
        
        continueBtn.layer.cornerRadius = 20
        
        uplaodBtn.layer.borderWidth = 1
        uplaodBtn.layer.cornerRadius = 8
        
        
    }
    @IBAction func uploadProfilePictureBtnClicked(_ sender: Any) {
        changeProfilePic()
    }
    
    @objc func changeProfilePic() {
        
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
}
