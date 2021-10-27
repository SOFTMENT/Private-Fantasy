//
//  OrderHistoryTableViewCel.swift
//  private fantasy
//
//  Created by Apple on 13/10/21.
//

import UIKit

class OrderHistoryTableViewCell : UITableViewCell {
    
    @IBOutlet weak var mView: UIView!
    
    @IBOutlet weak var mProfile: UIImageView!
    @IBOutlet weak var mTitle: UILabel!
    
    @IBOutlet weak var mPrice: UILabel!
    @IBOutlet weak var orderStatus: UILabel!
    
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var orderId: UILabel!
    
    override class func awakeFromNib() {
        
    }
}
