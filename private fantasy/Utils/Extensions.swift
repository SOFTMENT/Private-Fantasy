//
//  Extensions.swift
//  private fantasy
//
//  Created by Vijay Rathore on 27/07/21.
//


import UIKit
import Firebase
import MBProgressHUD
import FirebaseFirestoreSwift
import TTGSnackbar
import FirebaseAuth
import FirebaseFirestoreSwift
import FirebaseFirestore





extension UITextView {

    func centerVerticalText() {
    
        let fitSize = CGSize(width: bounds.width, height: CGFloat.greatestFiniteMagnitude)
        let size = sizeThatFits(fitSize)
        let calculate = (bounds.size.height - size.height * zoomScale) / 2
        let offset = max(1, calculate)
        contentOffset.y = -offset
    }
}

extension UITextField {
    
    /// set icon of 20x20 with left padding of 8px
    func setLeftIcons(icon: UIImage) {
        
        let padding = 8
        let size = 20
        
        let outerView = UIView(frame: CGRect(x: 0, y: 0, width: size+padding, height: size) )
        let iconView  = UIImageView(frame: CGRect(x: padding, y: 0, width: size, height: size))
        iconView.image = icon
        outerView.addSubview(iconView)
        
        leftView = outerView
        leftViewMode = .always
    }
    
    
    
    
    /// set icon of 20x20 with left padding of 8px
    func setRightIcons(icon: UIImage) {
        
        let padding = 8
        let size = 12
        
        let outerView = UIView(frame: CGRect(x: 0, y: 0, width: size+padding, height: size) )
        let iconView  = UIImageView(frame: CGRect(x: -padding, y: 0, width: size, height: size))
        iconView.image = icon
        outerView.addSubview(iconView)
        
        rightView = outerView
        rightViewMode = .always
    }
    
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}

extension AuthErrorCode {
    
    var errorMessage: String {
        switch self {
        case .emailAlreadyInUse:
            return "The email is already in use with another account"
        case .userNotFound:
            return "Account not found for the specified user. Please check and try again"
        case .userDisabled:
            return "Your account has been disabled. Please contact support."
        case .invalidEmail, .invalidSender, .invalidRecipientEmail:
            return "Please enter a valid email"
        case .networkError:
            return "Network error. Please try again."
        case .weakPassword:
            return "Your password is too weak. The password must be 6 characters long or more."
        case .wrongPassword:
            return "Your password is incorrect. Please try again or use 'Forgot password' to reset your password"
        case .accountExistsWithDifferentCredential:
            return "An account already exists with the same email address but different sign-in method."
        
        default:
            return "Unknown error occurred"
        }
    }
}



extension Date {

    func timeAgoSinceDate() -> String {

        // From Time
        let fromDate = self

        // To Time
        let toDate = Date()

        // Estimation
        // Year
        if let interval = Calendar.current.dateComponents([.year], from: fromDate, to: toDate).year, interval > 0  {

            return interval == 1 ? "\(interval)" + " " + "year ago" : "\(interval)" + " " + "years ago"
        }

        // Month
        if let interval = Calendar.current.dateComponents([.month], from: fromDate, to: toDate).month, interval > 0  {

            return interval == 1 ? "\(interval)" + " " + "month ago" : "\(interval)" + " " + "months ago"
        }

        // Day
        if let interval = Calendar.current.dateComponents([.day], from: fromDate, to: toDate).day, interval > 0  {

            return interval == 1 ? "\(interval)" + " " + "day ago" : "\(interval)" + " " + "days ago"
        }

        // Hours
        if let interval = Calendar.current.dateComponents([.hour], from: fromDate, to: toDate).hour, interval > 0 {

            return interval == 1 ? "\(interval)" + " " + "hour ago" : "\(interval)" + " " + "hours ago"
        }

        // Minute
        if let interval = Calendar.current.dateComponents([.minute], from: fromDate, to: toDate).minute, interval > 0 {

            return interval == 1 ? "\(interval)" + " " + "minute ago" : "\(interval)" + " " + "minutes ago"
        }

        return "a moment ago"
    }
}




extension UIViewController {
    
    func sendPushNotification() {
        
        //1. Create the alert controller.
        let alert = UIAlertController(title: "Notification", message: "Send Notification to All Users", preferredStyle: .alert)
        
        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (textField) in
            textField.placeholder = "Enter Title"
        }
        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (textField) in
            textField.placeholder = "Enter Message"
        }
        
        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "Send", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0].text?.trimmingCharacters(in: .whitespacesAndNewlines) // Force unwrapping because we know it exists.
            let textField1 = alert?.textFields![1].text?.trimmingCharacters(in: .whitespacesAndNewlines)
            if (!textField!.isEmpty && !textField1!.isEmpty) {
                PushNotificationSender().sendPushNotificationToTopic(title: textField!, body: textField1!)
                self.showToast(message: "Notification has been sent")
            }
            else {
                self.showToast(message: "Please Enter Title & Message")
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            
            alert.dismiss(animated: true, completion: nil)
        }))
        
        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    public func logout(){
        do {
            try Auth.auth().signOut()
            self.beRootScreen(mIdentifier: Constants.StroyBoard.signInViewController)
        }
        catch {
            
        }
    }
//        func sendPushNotification() {
//        
//        //1. Create the alert controller.
//        let alert = UIAlertController(title: "Notification", message: "Send Notification to All Users", preferredStyle: .alert)
//
//        //2. Add the text field. You can configure it however you need.
//        alert.addTextField { (textField) in
//            textField.placeholder = "Enter Title"
//        }
//        //2. Add the text field. You can configure it however you need.
//        alert.addTextField { (textField) in
//            textField.placeholder = "Enter Message"
//        }
//
//        // 3. Grab the value from the text field, and print it when the user clicks OK.
//        alert.addAction(UIAlertAction(title: "Send", style: .default, handler: { [weak alert] (_) in
//            let textField = alert?.textFields![0].text?.trimmingCharacters(in: .whitespacesAndNewlines) // Force unwrapping because we know it exists.
//            let textField1 = alert?.textFields![1].text?.trimmingCharacters(in: .whitespacesAndNewlines)
//            if (!textField!.isEmpty && !textField1!.isEmpty) {
//                PushNotificationSender().sendPushNotification(title: textField!, body: textField1!)
//                self.showToast(message: "Notification has been sent")
//            }
//            else {
//                self.showToast(message: "Please Enter Title & Message")
//            }
//        }))
//        
//        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
//         
//            alert.dismiss(animated: true, completion: nil)
//        }))
//
//        // 4. Present the alert.
//        self.present(alert, animated: true, completion: nil)
//        
//    }
//    
    func ProgressHUDShow(text : String) {
        let loading = MBProgressHUD.showAdded(to: self.view, animated: true)
        loading.mode = .indeterminate
        loading.label.font = UIFont(name: "RobotoCondensed-Regular", size: 14)
        loading.label.text =  text
      
    }
    
    func ProgressHUDHide() {
        MBProgressHUD.hide(for: self.view, animated: true)
    }
    
    func showSnack(messages : String) {
           
           let snackbar = TTGSnackbar(message: messages, duration: .long)
           snackbar.messageLabel.textAlignment = .center
           snackbar.show()
       }
    
    func showToast(message : String) {

        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 150, y: self.view.frame.size.height/2, width: 300, height: 36))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.font = UIFont(name: "RobotoCondensed-Regular", size: 12)
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 5.0, delay: 0.1, options: .curveEaseIn, animations: {
             toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }

    
    func sendEmailVerificationLink(goBack : Bool) {
        
        
        Auth.auth().currentUser!.sendEmailVerification { (error) in
                
        }
        
        let alert = UIAlertController(title: "Verify Your Email", message: "We have sent email verification link on your mail address.Please Verify email and continue to Sign In.", preferredStyle: .alert)

        let okAction = UIAlertAction(title: "Ok", style: .default) { (action) in
            self.dismiss(animated: true) {
                if goBack {
                    self.dismiss(animated: true, completion: nil)
                }
              
            }
         
        }

        alert.addAction(okAction)

        self.present(alert, animated: true, completion: nil)
    }
    

    
    func getUserData(uid : String, showProgress : Bool)  {
        if showProgress {
            ProgressHUDShow(text: "Loading...")
        }
      
        Firestore.firestore().collection("Users").document(uid).getDocument { (snapshot, error) in
            if showProgress {
                MBProgressHUD.hide(for: self.view, animated: true)
            }
           
            if error != nil {
                self.showError(error!.localizedDescription)
            }
            else {
                if let user = try? snapshot?.data(as: User.self) {
                    User.data = user
                    if let profilePicture = user.profilePicture {
                        if profilePicture != "" {
                            if let hasPlayed = user.hasPlayed  {
                                if hasPlayed  {
                                    self.beRootScreen(mIdentifier: Constants.StroyBoard.chatHomeViewController)
                                }
                                else {
                                    self.beRootScreen(mIdentifier: Constants.StroyBoard.choosePFMViewController)
                                }
                            }
                            else {
                                self.beRootScreen(mIdentifier: Constants.StroyBoard.choosePFMViewController)
                            }
                            
                           
                        }
                        else {
                            self.beRootScreen(mIdentifier: Constants.StroyBoard.uploadProfileViewController)
                        }
                    }
                    else {
                        self.beRootScreen(mIdentifier: Constants.StroyBoard.uploadProfileViewController)
                    }
                   
                }
                else {
                    Auth.auth().currentUser?.delete(completion: { error in
                        
                    })
                    
                    do {
                    try Auth.auth().signOut()
                    }
                    catch {
                        
                    }
                    
                    self.showError("Your record has been deleted")
                }
            }
        }

    }
    

    
    func membershipDaysLeft(currentDate : Date,identifier : String) -> Int {
        let expireDate = IAPManager.shared.expirationDateFor(identifier)
        if expireDate != nil {
          
            return Calendar.current.dateComponents([.day], from: currentDate, to: expireDate!).day!
        }
        
        return 0
    }
    func checkMembershipStatus(currentDate : Date,identifier : String) -> Bool{
        let expireDate = IAPManager.shared.expirationDateFor(identifier)
        if expireDate != nil {
           
            print(convertDateFormater(expireDate!))
            if currentDate < expireDate! {
                
                return true
            }
        }
        return false
    }

    
    

    func getViewControllerUsingIdentifier(mIdentifier : String) -> UIViewController{

        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        switch mIdentifier {
        case Constants.StroyBoard.signInViewController:
            return (mainStoryboard.instantiateViewController(identifier: mIdentifier) as? SignInViewController)!
            
        case Constants.StroyBoard.homeViewController:
            return (mainStoryboard.instantiateViewController(identifier: mIdentifier) as? UINavigationController)!
            
        case Constants.StroyBoard.uploadProfileViewController:
            return (mainStoryboard.instantiateViewController(identifier: mIdentifier) as? UploadProfilePictureViewController)!
            
        case Constants.StroyBoard.preparingQuestionViewController:
            return (mainStoryboard.instantiateViewController(identifier: mIdentifier) as? PreparingQuestionViewController)!
            
        case Constants.StroyBoard.qnaViewController:
            return (mainStoryboard.instantiateViewController(identifier: mIdentifier) as? QuestionsAnswersViewController)!
            
        case Constants.StroyBoard.choosePFMViewController:
            return (mainStoryboard.instantiateViewController(identifier: mIdentifier) as? ChoosePFMViewController)!
            
        case Constants.StroyBoard.pfmResultViewController:
            return (mainStoryboard.instantiateViewController(identifier: mIdentifier) as? PFMResultViewController)!
            
        case Constants.StroyBoard.chatHomeViewController:
            return (mainStoryboard.instantiateViewController(identifier: mIdentifier) as? ChatHomeViewController)!

        default:
            return (mainStoryboard.instantiateViewController(identifier: Constants.StroyBoard.signInViewController) as? SignInViewController)!
        }
    }
    
    func beRootScreen(mIdentifier : String) {


        guard let window = self.view.window else {
            self.view.window?.rootViewController = getViewControllerUsingIdentifier(mIdentifier: mIdentifier)
            self.view.window?.makeKeyAndVisible()
                return
            }

            window.rootViewController = getViewControllerUsingIdentifier(mIdentifier: mIdentifier)
            window.makeKeyAndVisible()
            UIView.transition(with: window,
                              duration: 0.3,
                              options: .transitionCrossDissolve,
                              animations: nil,
                              completion: nil)

    }


    
    func convertDateFormater(_ date: Date) -> String
        {
        let df = DateFormatter()
        df.dateFormat = "dd-MMM-yyyy hh:mm a"
        df.timeZone = TimeZone(abbreviation: "GMT")
        df.timeZone = TimeZone.current
        return df.string(from: date)

        }
    
    func handleError(error: Error) {
        if let errorCode = AuthErrorCode(rawValue: error._code) {
        
            showError(errorCode.errorMessage)
        }
    }
    
    func showError(_ message : String) {
        let alert = UIAlertController(title: "ERROR", message: message, preferredStyle: .alert)

        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)

        alert.addAction(okAction)

        self.present(alert, animated: true, completion: nil)

    }
    
    func showMessage(title : String,message : String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)

        alert.addAction(okAction)

        self.present(alert, animated: true, completion: nil)

    }
    
    

            
 
}



        


    





extension URL {
    static let timeIP = URL(string: "http://worldtimeapi.org/api/ip")!
    static func asyncTime(completion: @escaping ((Date?, TimeZone?, Error?)-> Void)) {
        URLSession.shared.dataTask(with: .timeIP) { data, response, error in
            guard let data = data else {
                completion(nil, nil, error)
                return
            }
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .secondsSince1970
                let root = try decoder.decode(Root.self, from: data)
                completion(root.unixtime, TimeZone(identifier: root.timezone), nil)
            } catch {
                completion(nil, nil, error)
            }
        }.resume()
    }
}


extension UIImageView {
    func makeRounded() {
        
        //self.layer.borderWidth = 1
        self.layer.masksToBounds = false
       // self.layer.borderColor = UIColor.gray.cgColor
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
        
    }
    
    
    
    
}


extension UIView {
    

    func dropShadow(scale: Bool = true) {
               layer.masksToBounds = false
               layer.shadowColor = UIColor.black.cgColor
               layer.shadowOpacity = 0.3
               layer.shadowOffset = .zero
               layer.shadowRadius = 2
               layer.shouldRasterize = true
               layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
   
    public var safeAreaFrame: CGFloat {
        if #available(iOS 13.0, *) {
            let window = UIApplication.shared.windows[0]
            return window.safeAreaInsets.bottom
        }
        else  {
            let window = UIApplication.shared.keyWindow
            return window!.safeAreaInsets.bottom
        }
    }
}

