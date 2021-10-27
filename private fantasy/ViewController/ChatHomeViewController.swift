//
//  ChatHomeViewController.swift
//  private fantasy
//
//  Created by Apple on 05/08/21.
//


import FirebaseFirestoreSwift
import Firebase
import UIKit
import FirebaseFirestore
import FirebaseMessaging
import FirebaseAuth


class ChatHomeViewController: UIViewController, UINavigationControllerDelegate, UITextFieldDelegate {
    
  

    @IBOutlet weak var tableView: UITableView!
    
    var lastMessages = Array<LastMessage>()
    var lastMessagesFilter = Array<LastMessage>()
    
    override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self
        
       
     
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(keyboardHide)))
        
        //getAllLastMessages
        getAllLastMessages()
       
        if User.data != nil {
            updateFCMToken()
        }
        
       
      
    }
 
    @IBAction func settingsViewBtnclicked(_ sender: Any) {
        performSegue(withIdentifier: "conversationSettingsSeg", sender: nil)
    }
    

    
    func updateFCMToken(){
        User.data?.token = Messaging.messaging().fcmToken
        Firestore.firestore().collection("Users").document(User.data!.uid!).setData(["token" : Messaging.messaging().fcmToken ?? ""], merge: true)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        filter(value: textField.text!)
    }
    
    public func filter(value : String){
        lastMessagesFilter.removeAll()
        lastMessagesFilter =  lastMessages.filter { lastMessages in
            if value == "" ||  lastMessages.name!.lowercased().contains(value.lowercased())  {
                return true
            }
            else {
                return false
            }
        }
      
        tableView.reloadData()
        tableView.layoutIfNeeded()
        
    }
    
    @objc func keyboardHide(){
        view.endEditing(true)
    }
    @IBAction func findNewClicked(_ sender: Any) {
        self.beRootScreen(mIdentifier: Constants.StroyBoard.choosePFMViewController)
    }
    
    public func getAllLastMessages() {
        
        guard let userData = User.data else {
            self.logout()
            return
        }
        
        ProgressHUDShow(text: "Loading...")
        
        Firestore.firestore().collection("Chats").document(userData.uid!).collection("LastMessage").order(by: "time",descending: true).addSnapshotListener { snapshot, error in
            self.ProgressHUDHide()
            if error == nil {
                self.lastMessages.removeAll()
                if let snapshot = snapshot {
                    for  qds in snapshot.documents {
                        if let lastMessage = try? qds.data(as: LastMessage.self) {
                            self.lastMessages.append(lastMessage)
                        }
                    
                    }
                }
                
                self.filter(value: "")
            }
            
        }
    }
    
    @objc func lastMessageClicked(value : MyGesture){
        performSegue(withIdentifier: "chatscreenseg", sender: value.choiceProfile)
    }
   
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "chatscreenseg" {
            if let destinationVC = segue.destination as? ChatScreenViewController {
                if let choiceProfile = sender as? ChoicesProfile  {
                    destinationVC.choiceProfile = choiceProfile
                }
               
            }
           
        }
        else if segue.identifier == "conversationSettingsSeg" {
            if let destinationVC = segue.destination as? SettingsViewController {
                destinationVC.viewControllerName = "conversation"
            }
        }
        
       
    }
    
}

extension ChatHomeViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if lastMessagesFilter.count > 0 {
          //  self.noMessageAvailable.isHidden = true
        }
        else {
           // self.noMessageAvailable.isHidden = false
        }
        return lastMessagesFilter.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "homechat", for: indexPath) as? HomeChatCell {
            let lastMessage = lastMessagesFilter[indexPath.row]
            
            cell.mImage.makeRounded()
            cell.mImage.layer.borderWidth = 1
            cell.mImage.layer.borderColor = UIColor.darkGray.cgColor
        
            if (lastMessage.isRead ?? false) {
                cell.mView.layer.borderWidth = 0
                cell.mView.layer.borderColor = UIColor.clear.cgColor
            }
            else {
                cell.mView.layer.borderWidth = 1
                cell.mView.layer.borderColor = UIColor.init(red: 189/255, green: 25/255, blue: 30/255, alpha: 1).cgColor
            }
            
            cell.mView.layer.cornerRadius = 8
          
            
          
            if let image = lastMessage.image{
                if image != "" {
                    cell.mImage.sd_setImage(with: URL(string: image), placeholderImage: UIImage(named: "profile-placeholder"), options: .continueInBackground, completed: nil)
                }
                else {
                    cell.mImage.image = UIImage(named: "profile-placeholder")
                }
            }
            else {
                cell.mImage.image = UIImage(named: "profile-placeholder")
            }
            
            cell.mTitle.text = lastMessage.name
            cell.mLastMessage.text = lastMessage.message
            if let time = lastMessage.time {
                cell.mTime.text = time.timeAgoSinceDate()
            }
            
            
            cell.mView.isUserInteractionEnabled = true
            let tappy = MyGesture(target: self, action: #selector(lastMessageClicked(value:)))
            
            let choiceProfile = ChoicesProfile()
            choiceProfile.name = lastMessage.name
            choiceProfile.profileImage = lastMessage.image
            choiceProfile.token = lastMessage.token
            choiceProfile.uid = lastMessage.uid
            tappy.choiceProfile = choiceProfile
            cell.mView.addGestureRecognizer(tappy)
           
            return cell
        }
        
        return HomeChatCell()
    }
    
    
}
