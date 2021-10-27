//
//  ChatScreenViewController.swift
//  private fantasy
//
//  Created by Apple on 05/08/21.
//


import UIKit
import Firebase
import FirebaseFirestoreSwift
import IQKeyboardManagerSwift
import FirebaseAuth
import FirebaseFirestore

class ChatScreenViewController : UIViewController, UITableViewDelegate,  UITableViewDataSource, UITextViewDelegate{
    
    
    @IBOutlet weak var backBtn: UIImageView!
    @IBOutlet weak var sendMessageBtn: UIImageView!
    @IBOutlet weak var mytextField: UITextView!
    @IBOutlet weak var toolBarImage: UIImageView!
    @IBOutlet weak var toolbarName: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var messages  = [Messages]()
    
    
    var choiceProfile : ChoicesProfile?
  
    @IBOutlet weak var bottomConst: NSLayoutConstraint!
    var userData : User!


    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        toolBarImage.makeRounded()
        
       
        if let userData = User.data {
            self.userData = userData
        }
        else{
            self.dismiss(animated: true, completion: nil)
        }
        
        guard let _ = choiceProfile else {
            self.dismiss(animated: true, completion: nil)
            return
            
        }
        
        self.toolBarImage.sd_setImage(with: URL(string: choiceProfile!.profileImage ?? ""), placeholderImage: UIImage(named: "profile-placeholder"), options: .continueInBackground , completed: nil)
     
        self.toolbarName.text = choiceProfile!.name ?? "PFM"
        
        
        //isRead
        
        Firestore.firestore().collection("Chats").document(userData.uid!).collection("LastMessage").document(choiceProfile!.uid!).updateData(["isRead": true])
     
        
        backBtn.isUserInteractionEnabled = true
        backBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(backBtnPressed)))
        
        
        
        tableView.delegate = self
        tableView.dataSource = self
        

        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 300
        
        
        
       
        mytextField.sizeToFit()
        mytextField.isScrollEnabled = false
        mytextField.delegate = self
        
        self.mytextField.contentInset = UIEdgeInsets(top: 5 , left: 10, bottom: 5, right: 10);
    
      
       
        sendMessageBtn.isUserInteractionEnabled = true
        sendMessageBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(sentMessageBtnPressed)))
        
        loadData()
        
      
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
              
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
              
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
              
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300)) {
                  
            self.moveToBottom()
        }
        
                    
    }
    

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       
        return UITableView.automaticDimension
       
    }
    

    
    func moveToBottom() {
           
           if messages.count > 0  {
               
               let indexPath = IndexPath(row: messages.count - 1, section: 0)
               
               tableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
           }
       }
       

    
    
 @objc func keyboardWillShow(notify: NSNotification) {
      
     if let keyboardSize = (notify.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
        
        bottomConst.constant  = -keyboardSize.height + view.safeAreaFrame
         UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
         }
          
         
      }
  }
  
  @objc func keyboardWillHide(notify: NSNotification) {
      
    
     
      bottomConst.constant  = view.safeAreaFrame
      UIView.animate(withDuration: 0.5) {
                   self.view.layoutIfNeeded()
     }
     
          moveToBottom()
                
  }
  
     
  
    
    @objc func dismissKeyboard() {
       
        view.endEditing(true)
     }
    

    
    
    
    @objc func backBtnPressed(){
        print("BAKCPRESSED")
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    @objc func sentMessageBtnPressed(){
        
        let mMessage = mytextField.text.trimmingCharacters(in: .whitespacesAndNewlines)
        if mMessage != "" {
           
            self.mytextField.text = ""
            let messageId =  Firestore.firestore().collection("Chats").document(userData.uid!).collection(choiceProfile!.uid!).document().documentID

            
            let message : Dictionary<String, AnyObject> = [
                "message": mMessage as AnyObject,
                "sender": (userData.uid!) as AnyObject,
                "type": "text" as AnyObject,
                "image":  (userData.profilePicture ?? "") as AnyObject,
                "name": (userData.name ?? "PFM" )as AnyObject,
                "messageId": messageId as AnyObject,
                "dateandtime" : FieldValue.serverTimestamp() as AnyObject
                ]
            
            //HASPLAYED
            Firestore.firestore().collection("Users").document(userData.uid!).setData(["hasPlayed" : true],merge: true)
        
            Firestore.firestore().collection("Chats").document(userData.uid!).collection(choiceProfile!.uid!).document(messageId).setData(message) { error in
               
                Firestore.firestore().collection("Chats").document(self.choiceProfile!.uid!).collection(self.userData.uid!).document(messageId).setData(message)
                
                if error == nil {
                 
                
                    
                   
                   
                    let lastMessage1 : Dictionary<String, AnyObject> = [
                        "uid": self.choiceProfile!.uid! as AnyObject,
                        "name": (self.choiceProfile!.name ?? "HBCU MADE")as AnyObject,
                        "time": FieldValue.serverTimestamp() as AnyObject,
                        "message":  mMessage as AnyObject,
                        "image": (self.choiceProfile!.profileImage ?? "" )as AnyObject,
                        "isRead": true as AnyObject,
                        "token" : (self.choiceProfile!.token ?? "12345")as AnyObject
                        ]
                    
                    Firestore.firestore().collection("Chats").document(self.userData.uid!).collection("LastMessage").document(self.choiceProfile!.uid!).setData(lastMessage1)
                    
                 
                    let lastMessage2 : Dictionary<String, AnyObject> = [
                        "uid": self.userData.uid! as AnyObject,
                        "name": (self.userData.name ?? "HBCU MADE")as AnyObject,
                        "time": FieldValue.serverTimestamp() as AnyObject,
                        "message":  mMessage as AnyObject,
                        "image": (self.userData.profilePicture ?? "" )as AnyObject,
                        "isRead": false as AnyObject,
                        "token" : (self.userData.token ?? "")as AnyObject
                        ]
                    
                    Firestore.firestore().collection("Chats").document(self.choiceProfile!.uid!).collection("LastMessage").document(self.userData.uid!).setData(lastMessage2) { error in
                        if error == nil {
                            Firestore.firestore().collection("Chats").document(self.choiceProfile!.uid!).collection("LastMessage").whereField("isRead", isEqualTo: false).getDocuments { snapshot, error in
                                
                                if error == nil {
                                    PushNotificationSender().sendPushNotification(title: self.userData.name!, body: mMessage, token: self.choiceProfile!.token ?? "", badge: (snapshot?.count ?? 1))
                                }
                            }
                        }
                    }
                    
                    
                }
                else {
                    self.showError(error!.localizedDescription)
                }
            }
          
        }
        
    }
    
    func loadData() {
        
        
       ProgressHUDShow(text: "Loading...")
        guard let friendUid = choiceProfile!.uid else {
            self.dismiss(animated: true, completion: nil)
            return
        }
        Firestore.firestore().collection("Chats").document(userData.uid!).collection(friendUid).order(by: "dateandtime").addSnapshotListener { snapshot, error in
            self.ProgressHUDHide()
            if error == nil {
               
                self.messages.removeAll()
                if let snapshot = snapshot {
                   
                    for snap in snapshot.documents {
                        
                        if let message = try? snap.data(as: Messages.self) {
                           
                            self.messages.append(message)
                        }
                    }
                }
                self.tableView.reloadData()
                self.moveToBottom()
            }
            else {
                self.showError(error!.localizedDescription)
            }
            
        }
        
    }
    
    
    

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
   
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let message  = messages[indexPath.row]
        
    


        if let cell = tableView.dequeueReusableCell(withIdentifier: "messagecell", for: indexPath) as? MessagesCell {

            cell.config(message: message, uid: userData.uid!,image: self.choiceProfile!.profileImage!)
           
            return cell

        }
        

    
        return MessagesCell()
        
    }
         
    
    override func viewWillAppear(_ animated: Bool) {
        IQKeyboardManager.shared.enable = false
    }

    
   
    
   
            
        
    
   
    

}


