//
//  ManageSexualServices.swift
//  private fantasy
//
//  Created by Apple on 13/10/21.
//

import UIKit

class ManageSexualServicesViewController : UIViewController {
    
    @IBOutlet weak var backView: UIView!
    
    @IBOutlet weak var addView: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableView.automaticDimension
        
        backView.layer.cornerRadius = 12
        addView.layer.cornerRadius = 12
        
        backView.isUserInteractionEnabled = true
        backView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(backBtnClicked)))
        
        
    }
    
    @objc func backBtnClicked(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func addBtnClicked(){
        
    }
    
    
    
}

extension ManageSexualServicesViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "managesexualservicescell", for: indexPath) as? ManageSexualServicesTableCell {
            
            cell.mView.layer.cornerRadius = 8
            cell.mImage.layer.cornerRadius = 6
            return cell
        }
        return ManageSexualServicesTableCell()
    }
    
    
    
    
}
