//
//  FindingProfileViewControllee.swift
//  private fantasy
//
//  Created by Apple on 04/08/21.
//

import UIKit
import Lottie
import FirebaseAuth
import FirebaseFirestore
import Firebase
import FirebaseFirestoreSwift

class FindingProfileViewController: UIViewController {
    @IBOutlet weak var mView: UIView!
    var intrest : String?
    var choiceProfiles : [ChoicesProfile] = []
    var results : Array = Array<ChoicesProfile>()
    @IBOutlet weak var mAnimation: AnimationView!
    
    override func viewDidLoad() {
        
        mAnimation.loopMode = .loop
        mAnimation.play()
        
        mView.dropShadow()
        mView.layer.cornerRadius = 12
        
        guard let intrest = intrest else {
            self.dismiss(animated: true, completion: nil)
            return
        }
        
        getChoiceProfile(intrest: intrest)
          
//        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
//            self.beRootScreen(mIdentifier: Constants.StroyBoard.pfmResultViewController)
//        }
//
    }
    
    public func getChoiceProfile(intrest : String) {
        var collectionRef : CollectionReference!
    
        if intrest == "male" {
             collectionRef = Firestore.firestore().collection("MaleProfile")
        }
        else if intrest == "female" {
            collectionRef = Firestore.firestore().collection("FemaleProfile")
        }
        else {
            collectionRef = Firestore.firestore().collection("CouplesProfile")
        }
        
        collectionRef.whereField("uid", isNotEqualTo: User.data!.uid!).getDocuments { snapshot, error in
            if error == nil {
                self.choiceProfiles.removeAll()
                self.results.removeAll()
                if let snapshot = snapshot, !snapshot.isEmpty {
                    for qds in snapshot.documents {
                        if let choiceProfile = try? qds.data(as: ChoicesProfile.self) {
                            var point : Float = 0.0
                            var mTotalChoice : Float = 0.0
                            if let choices = choiceProfile.choices {
                                for question in Question.data {
                                    for answer in question.answers! {
                                        if answer.isChecked ?? false {
                                            mTotalChoice = mTotalChoice + 1
                                            if let _ = choices[answer.aid!] {
                                                point = point + 1
                                            }
                                        }
                                       
                                    }
                                }
                            }
                
                            choiceProfile.score = (point / mTotalChoice) * 100
                            self.results.append(choiceProfile)
                            
                           
                            
                        }
                    }
                    
               
                    if self.results.count > 0{
                        self.performSegue(withIdentifier: "resultseg", sender: nil)
                    }
                   
                    
                }
                else {
                    let alert = UIAlertController(title: "No Profile Found", message: "Sorry! Based on your prefrences there is no profile available.", preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: { action in
                        self.beRootScreen(mIdentifier: Constants.StroyBoard.choosePFMViewController)
                    }))
                    
                    self.present(alert, animated: true, completion: nil)
                }
            }
            else {
                self.showSnack(messages: error!.localizedDescription)
            }
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "resultseg" {
            if let destination = segue.destination as? PFMResultViewController {
                destination.choicesProfile = results
            }
        }
    }
}
