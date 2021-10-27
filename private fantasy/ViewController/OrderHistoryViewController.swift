//
//  OrderHistoryViewController.swift
//  private fantasy
//
//  Created by Apple on 13/10/21.
//

import UIKit
import FirebaseFirestoreSwift
import Firebase

class OrderHisotryViewController : UIViewController {
    
    @IBOutlet weak var no_orders_available: UILabel!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var tableView: UITableView!
    var orderHistory = Array<OrderHistory>()
    override func viewDidLoad() {
        
        tableView.delegate = self
        tableView.dataSource = self
        
        backView.layer.cornerRadius = 12
        
        backView.isUserInteractionEnabled = true
        backView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(backBtnClicked)))
        
        getOrder(by: Auth.auth().currentUser!.uid)
    }
    
    func getOrder(by uid : String) {
        self.ProgressHUDShow(text: "")
        Firestore.firestore().collection("OrderHistory").order(by: "date", descending: true).whereField("uid", isEqualTo: uid).getDocuments { snapshot, error in
            self.ProgressHUDHide()
            
            if let error = error {
                self.showError(error.localizedDescription)
            }
            else {
                self.orderHistory.removeAll()
                if let snapshot = snapshot, !snapshot.isEmpty {
                    for qdr in snapshot.documents {
                        if let order = try? qdr.data(as: OrderHistory.self, decoder: nil) {
                            self.orderHistory.append(order)
                        }
                    }
                }
                self.tableView.reloadData()
            }
        }
    }
    
    @objc func backBtnClicked(){
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension OrderHisotryViewController : UITableViewDelegate, UITableViewDataSource {
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "orderhistorycell", for: indexPath) as? OrderHistoryTableViewCell {
            
            let order = orderHistory[indexPath.row]
            cell.mView.layer.cornerRadius = 8
            cell.mProfile.layer.cornerRadius = 6
            
            cell.orderStatus.text = order.status ?? "In transit"
            cell.mPrice.text = String(format: "%.2f", order.price ?? 0.0)
            cell.mTitle.text = order.title ?? "Order Name"
            cell.orderId.text = "#\(order.orderId ?? "orderid")"
            cell.time.text = order.date!.timeAgoSinceDate()
            
            cell.mProfile.sd_setImage(with: URL(string: order.image!), placeholderImage: UIImage(named: "placeholder"), options: .continueInBackground, completed: nil)
            
            return cell
            
        }
        return OrderHistoryTableViewCell()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if orderHistory.count > 0 {
            no_orders_available.isHidden = true
        }
        else {
            no_orders_available.isHidden = false
        }
        
        return orderHistory.count
    }
}
