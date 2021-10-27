//
//  PFMResultViewController.swift
//  private fantasy
//
//  Created by Apple on 04/08/21.
//

import UIKit
import SDWebImage

class PFMResultViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var choicesProfile : Array<ChoicesProfile>?
 
    
    
    override func viewDidLoad() {
      
        guard let _ = choicesProfile else {
            self.dismiss(animated: true, completion: nil)
            return
        }
        
        choicesProfile!.sort(by: { $0.score! > $1.score! })
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableView.automaticDimension
        
        
        
      
    }
    @IBAction func settingsBtnClicked(_ sender: Any) {
        
        performSegue(withIdentifier: "resultsettingsseg", sender: nil)
    }
    
    
    

    
    
    @objc func contactBtnClicked(myGest : MyGesture){
        
        performSegue(withIdentifier: "chatscreenseg", sender: myGest.choiceProfile)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "chatscreenseg" {
            if let dest = segue.destination as? ChatScreenViewController {
                if let choiceProfile = sender as? ChoicesProfile {
                    dest.choiceProfile = choiceProfile
                }
            }
        }
    }
}

extension PFMResultViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if choicesProfile!.count > 5  {
            return 5
        }
        else {
            return choicesProfile!.count
        }
    }
    
    
    
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "resultcell", for: indexPath) as? ResultCell {
            cell.contactBtn.layer.cornerRadius = 4
            cell.mView.layer.cornerRadius = 8
            cell.profileImage.layer.cornerRadius = 6
            cell.mView.dropShadow()
            
            let choice = choicesProfile![indexPath.row]
            cell.name.text = choice.name
            cell.score.text = "Score \((choice.score! * 1000).rounded() / 1000)"
            cell.profileImage.sd_setImage(with: URL(string: choice.profileImage ?? ""), placeholderImage: UIImage(named: "profile-placeholder"), options: .continueInBackground, completed: nil)
            
            let myGesture = MyGesture(target: self, action: #selector(contactBtnClicked(myGest:)))
            myGesture.choiceProfile = choice
            cell.contactBtn.isUserInteractionEnabled = true
            cell.contactBtn.addGestureRecognizer(myGesture)
            return cell
        }
        
        return ResultCell()
    }
    
    
    
    
}



