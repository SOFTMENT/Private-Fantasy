//
//  QuestionsAnswersViewController.swift
//  private fantasy
//
//  Created by Apple on 04/08/21.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift
import FirebaseAuth
import FirebaseFirestoreSwift
import FirebaseFirestore
import FirebaseAuth


class QuestionsAnswersViewController: UIViewController {
 
    
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var questionView: UIView!
    @IBOutlet weak var mView: UIView!
    @IBOutlet weak var questionsCount: UILabel!
    @IBOutlet weak var question: UILabel!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    var choicesAid : [String : Bool] = [:]
    
    var  intrest : String?
    var pageCount = 0
    var totalCount = 0
    override func viewDidLoad() {
        
        backBtn.isHidden = true
        nextBtn.layer.cornerRadius = 8
        
        mView.dropShadow()
        mView.layer.cornerRadius = 12
        questionView.layer.cornerRadius = 12
        
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableView.automaticDimension
        
        tableView.delegate = self
        tableView.dataSource = self
        
        totalCount = Question.data.count - 1
       
        
        guard let intrest = intrest else {
            self.dismiss(animated: true, completion: nil)
            return
        }
        
        getAnswers(intrest: intrest)
    }
    

    
    func getAnswers(intrest : String){
     
        let collectionRef : CollectionReference!
        if intrest == "couples" {
            collectionRef = Firestore.firestore().collection("CoupleQuestions")
        }
        else {
        
            collectionRef = Firestore.firestore().collection("Questions")
        }
        for qus in Question.data {
          
            Question.data[qus.position! - 1].answers?.removeAll()
            
            collectionRef.document(qus.qid!).collection("Answers").getDocuments { snapshot, error in
                if error == nil {
  

                    qus.answers!.removeAll()
                    if let snapshot = snapshot {
                        if !snapshot.isEmpty {
                            for qds in snapshot.documents {
                                if let answer = try? qds.data(as: Answer.self) {
                                    qus.answers!.append(answer)
                                }
                            }
                            
                            qus.answers = Question.sortAnswer(answers: qus.answers!)
                          
                            print("HELLO BHAI \(qus.position! - 1)")
                            Question.data[qus.position! - 1].answers = qus.answers
                            
                           
                            self.tableView.reloadData()
                    
                        }
                    }
                }
                else {
                    self.showSnack(messages: error!.localizedDescription)
                }
            }
            
           
           
    }
   }
    
    
    
    func updateUI() {
        if totalCount >= 0 && pageCount <= totalCount && pageCount >= 0 {
           
        questionsCount.text = "Questions (\((pageCount+1))/\(totalCount+1))"
       
        if intrest == "couples" {
            question.text = Question.data[self.pageCount].question ?? ""
        }
        else {
            if intrest == "male" {
                question.text = "Male to Female PFM, \(Question.data[self.pageCount].question ?? "")"
            }
            else {
               
                question.text = "Female to Male PFM, \(Question.data[self.pageCount].question ?? "")"
                
            }
          
        }
            self.tableView.reloadData()
        }
    }
    
    @IBAction func nextBtnClicked(_ sender: Any) {
        if pageCount == totalCount {
            if let user = User.data {
                let collectionRef : CollectionReference!
                
                ProgressHUDShow(text: "")
                if intrest == "male" || intrest == "female" {
                
                if user.gender == "M" {
                    
                    collectionRef =  Firestore.firestore().collection("MaleProfile")
                }
                else if user.gender == "F" {
                    collectionRef = Firestore.firestore().collection("FemaleProfile")
                }
                else {
                    collectionRef = Firestore.firestore().collection("OtherProfile")
                }
                    collectionRef.document(user.uid!).setData(["choices" : self.choicesAid, "name" : user.name!, "uid" : user.uid!, "profileImage":user.profilePicture ?? "", "time" : FieldValue.serverTimestamp()]) { error in
                    self.ProgressHUDHide()
                    if error == nil {
                        self.performSegue(withIdentifier: "findingProfileSeg", sender: nil)
                    }
                    else {
                        self.showSnack(messages: error!.localizedDescription)
                    }
                }
            }
                else {
                    collectionRef =  Firestore.firestore().collection("CouplesProfile")
                    collectionRef.document(user.uid!).setData(["choices" : self.choicesAid,"uid" : user.uid!, "profileImage":user.profilePicture ?? "","token" : user.token ?? "12345", "time" : FieldValue.serverTimestamp()]) { error in
                        self.ProgressHUDHide()
                        if error == nil {
                            self.performSegue(withIdentifier: "findingProfileSeg", sender: nil)
                        }
                        else {
                            self.showSnack(messages: error!.localizedDescription)
                        }
                    }
                    
                }
            }
        }
        else {
            self.pageCount = self.pageCount + 1;
            if self.pageCount == self.totalCount {
                self.nextBtn.setTitle("Submit", for: .normal)
            }
            if self.pageCount > 0 {
                self.backBtn.isHidden = false
            }
            updateUI()
        }
     
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "findingProfileSeg" {
            if let destination = segue.destination as? FindingProfileViewController {
                destination.intrest = intrest
            }
        }
        
    }
    
    
    @IBAction func backBtnPressed(_ sender: Any) {
        if pageCount > 0 {
            self.pageCount = self.pageCount - 1;
            if self.pageCount == 0 {
                self.backBtn.isHidden = true
            }
            if self.pageCount != self.totalCount {
                self.nextBtn.setTitle("Next", for: .normal)
            }
           updateUI()
        }
       
    }
    
    func addAid(aid : String) {
        self.choicesAid[aid] = true
        
      
        
    }
    
    func removeAid(aid : String){
        self.choicesAid.removeValue(forKey: aid)
       
    }
    
}

extension QuestionsAnswersViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return Question.data[self.pageCount].answers!.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let cell = tableView.cellForRow(at: indexPath) as? QuestionsAnswersCell {
            cell.mCheckbox.isSelected.toggle()
            Question.data[self.pageCount].answers![indexPath.row].isChecked  = cell.mCheckbox.isSelected
            if cell.mCheckbox.isSelected {
                self.addAid(aid: Question.data[self.pageCount].answers![indexPath.row].aid!)
            }
            else {
                self.removeAid(aid: Question.data[self.pageCount].answers![indexPath.row].aid!)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "qnacell", for: indexPath) as? QuestionsAnswersCell {
            let answer = Question.data[self.pageCount].answers![indexPath.row]
            cell.mCheckbox.isSelected = Question.data[self.pageCount].answers![indexPath.row].isChecked ?? false
            cell.mCheckbox.isUserInteractionEnabled = false
            cell.ansView.layer.cornerRadius = 8
            if intrest == "female" {
                cell.mAnswer.text = answer.fanswer ?? answer.answer
            }
            else {
                cell.mAnswer.text = answer.answer
            }
           
            return cell
        }
        return QuestionsAnswersCell()
    }
    
    
    
}
