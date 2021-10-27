//
//  HomeChatCell.swift
//  private fantasy
//
//  Created by Apple on 05/08/21.
//

import UIKit

class HomeChatCell: UITableViewCell {
    
    @IBOutlet weak var mImage: UIImageView!
    @IBOutlet weak var mTitle: UILabel!
    @IBOutlet weak var mLastMessage: UILabel!
    @IBOutlet weak var mTime: UILabel!
    @IBOutlet weak var mView: UIView!
    
    override func prepareForReuse() {
        mImage.image = nil
    }
    override func awakeFromNib() {
        super.awakeFromNib()
       
     
        
    }
}
