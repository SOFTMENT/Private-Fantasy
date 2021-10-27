//
//  ResultsCell.swift
//  private fantasy
//
//  Created by Apple on 05/08/21.
//

import UIKit

class ResultCell: UITableViewCell {
    
    @IBOutlet weak var mView: UIView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var score: UILabel!
    @IBOutlet weak var memberSince: UILabel!
    @IBOutlet weak var contactBtn: UIButton!
    
    
    override class func awakeFromNib() {
        
    }
}
