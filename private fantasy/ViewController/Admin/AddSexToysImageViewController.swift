//
//  AddSexToysImageViewController.swift
//  private fantasy
//
//  Created by Apple on 12/10/21.
//


import UIKit
import CropViewController
import Firebase
import FirebaseFirestoreSwift

class AddSexToysImageViewController : UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate, CropViewControllerDelegate {
    
    var productTitle : String?
    var productPrice : String?
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var mView: UIView!
    @IBOutlet weak var img1: UIImageView!
    @IBOutlet weak var img2: UIImageView!
    @IBOutlet weak var img3: UIImageView!
    @IBOutlet weak var img4: UIImageView!
    @IBOutlet weak var doneBtn: UIView!
    var imagesUrl : [String : String] = [ : ]
    var imageNumber : String = "one"
    var id : String = ""
    override func viewDidLoad() {
        
        backView.layer.cornerRadius = 12
        mView.layer.cornerRadius = 12
        doneBtn.layer.cornerRadius = 8
        
        
        img1.isUserInteractionEnabled = true
        let myTap1 = MyGesture(target: self, action: #selector(changeProfilePic(value:)))
        myTap1.id = "one"
        img1.addGestureRecognizer(myTap1)
        
        img2.isUserInteractionEnabled = true
        let myTap2 = MyGesture(target: self, action: #selector(changeProfilePic(value:)))
        myTap2.id = "two"
        img2.addGestureRecognizer(myTap2)
        
        img3.isUserInteractionEnabled = true
        let myTap3 = MyGesture(target: self, action: #selector(changeProfilePic(value:)))
        myTap3.id = "three"
        img3.addGestureRecognizer(myTap3)
        
        img4.isUserInteractionEnabled = true
        let myTap4 = MyGesture(target: self, action: #selector(changeProfilePic(value:)))
        myTap4.id = "four"
        img4.addGestureRecognizer(myTap4)
        
        id = Firestore.firestore().collection("SexToys").document().documentID
        
        doneBtn.isUserInteractionEnabled = true
        doneBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(doneBtnClicked)))
        
        backView.isUserInteractionEnabled = true
        backView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(backBtnClicked)))
    }
    
    @objc func backBtnClicked(){
        self.dismiss(animated: true, completion: nil)
    }
    
   
    
    @objc func doneBtnClicked(){
        
        if imagesUrl["one"] != nil {
            Firestore.firestore().collection("SexToys").document(id).setData(["pTitle" : productTitle!, "pPrice" : Double(productPrice!) ?? 0.0,"pImages" : imagesUrl, "pId" : id , "pDate" : Date(), "isActive" : true]) { error in
                if let error = error {
                    self.showError(error.localizedDescription)
                }
                else {
                    self.showSnack(messages: "Product Added")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
        }
        else {
            self.showToast(message: "Upload image 1")
        }
        
     
    }
    
    @objc func changeProfilePic(value : MyGesture) {
        
        imageNumber = value.id
        
        let alert = UIAlertController(title: "Upload Product Image", message: "", preferredStyle: .alert)
        let action1 = UIAlertAction(title: "Using Camera", style: .default) { (action) in
            
            let image = UIImagePickerController()
            image.title = "Product Image"
            image.delegate = self
            image.sourceType = .camera
            
            self.present(image,animated: true)
            
            
        }
        
        let action2 = UIAlertAction(title: "From Photo Library", style: .default) { (action) in
            
            let image = UIImagePickerController()
            image.delegate = self
            image.title = "Product Image"
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
                cropViewController.setAspectRatioPreset(.presetSquare, animated: true)
                cropViewController.aspectRatioLockEnabled = true
                cropViewController.aspectRatioPickerButtonHidden = true
                self.present(cropViewController, animated: true, completion: nil)
            }
            
            
            
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        
        self.ProgressHUDShow(text: "Updating...")
        
        if imageNumber == "one" {
            img1.image = image
        }
        else if imageNumber == "two" {
            img2.image = image
        }
        else if imageNumber == "three" {
            img3.image = image
        }
        else if imageNumber == "four" {
            img4.image = image
        }
        
        uploadImageOnFirebase{downloadURL in
            self.ProgressHUDHide()
            
            self.imagesUrl[self.imageNumber] = downloadURL
           
            
        }
        

        self.dismiss(animated: true, completion: nil)
    }
    
    
    func uploadImageOnFirebase(completion : @escaping (String) -> Void ) {
        
        let storage = Storage.storage().reference().child("SexToysImages").child(id).child("\(imageNumber).png")
        var downloadUrl = ""
        
        var uploadData : Data!
        
        
        
        if imageNumber == "one" {
         
            uploadData = (self.img1.image?.jpegData(compressionQuality: 0.4))!
        }
        else if imageNumber == "two" {
          
            uploadData = (self.img2.image?.jpegData(compressionQuality: 0.4))!
        }
        else if imageNumber == "three" {
          
            uploadData = (self.img3.image?.jpegData(compressionQuality: 0.4))!
        }
        else if imageNumber == "four" {
          
            uploadData = (self.img4.image?.jpegData(compressionQuality: 0.4))!
        }
      
        
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
