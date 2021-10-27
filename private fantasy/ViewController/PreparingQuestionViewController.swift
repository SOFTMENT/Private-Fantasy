//
//  PreparingQuestionViewController.swift
//  private fantasy
//
//  Created by Vijay Rathore on 29/07/21.
//

import UIKit
import Lottie
import Firebase
import FirebaseFirestoreSwift
import FirebaseFirestore
import FirebaseAuth


class PreparingQuestionViewController: UIViewController {
    
    @IBOutlet weak var animationView: AnimationView!
    @IBOutlet weak var mView: UIView!
    var  intrest : String?
    override func viewDidLoad() {
        animationView.loopMode = .loop
        animationView.play()
        
        mView.dropShadow()
        mView.layer.cornerRadius = 12
        
        guard let intrest = intrest else {
            self.dismiss(animated: true, completion: nil)
            return
        }
        
        getQuestionsAndAnswer(inreset: intrest)
    }
    
    func getQuestionsAndAnswer(inreset : String) {
        
        let collectionRef : CollectionReference!
        if intrest == "couples" {
            collectionRef = Firestore.firestore().collection("CoupleQuestions")
        }
        else {
            collectionRef = Firestore.firestore().collection("Questions")
        }
        
        collectionRef.getDocuments { snapshot, error in
           
            if error == nil {
                Question.data.removeAll()
                if let snapshot = snapshot {
                    if !snapshot.isEmpty {
                        
                        for qds in snapshot.documents {
                            if let question =  try? qds.data(as: Question.self)  {
                                question.answers = []
                                Question.data.append(question)
                                
                               
                            }
                            else {
                                print("Failed")
                            }

                        }
                        

                        Question.data = Question.sortQuestion(questions: Question.data)
            
                        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
                            self.performSegue(withIdentifier: "qnaSeg", sender: nil)
                        }
                        
                    }
                }
            }
            else {
                self.showSnack(messages: error!.localizedDescription)
            }
        }
       
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "qnaSeg" {
            if let destination = segue.destination as? QuestionsAnswersViewController {
                destination.intrest = intrest
            }
        }
    }
    
}
