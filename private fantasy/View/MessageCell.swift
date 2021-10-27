//
//  MessageCell.swift
//  private fantasy
//
//  Created by Apple on 05/08/21.
//


import UIKit
import SDWebImage
import AVFoundation
import AVKit



class MessagesCell: UITableViewCell {
    @IBOutlet weak var senderView: UIView!
    @IBOutlet weak var senderLabel: UILabel!
    @IBOutlet weak var senderMessage: UITextView!
    
    @IBOutlet weak var myView: UIView!
    
    @IBOutlet weak var myLabel: UITextView!
    @IBOutlet weak var myimage: UIImageView!
    var message : Messages!
    @IBOutlet weak var maindateandtime: UILabel!
    @IBOutlet weak var dateandtime: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        myimage.makeRounded()
        myView.layer.cornerRadius = 6
        senderView.layer.cornerRadius = 6
        
        senderLabel.text = ""
        senderMessage.text = ""
       
        senderMessage.isEditable = false
        myLabel.isEditable = false
        myLabel.text = ""
        maindateandtime.text = "a moment ago"
        dateandtime.text = "a moment ago"
        
        
        
        
    }
    
  
    

  
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        myLabel.text = ""
        senderLabel.text = ""
        senderMessage.text = ""
        
        
//        messageImage.image = nil
//        leftmessageimage.image = nil
   
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    

    func config(message : Messages, uid : String, image :  String) {
        self.message  = message
       
       
        if message.sender == uid {
            maindateandtime.text = message.dateandtime.timeAgoSinceDate()
            if message.type == "text" {
                myLabel.text = message.message
               
         
            }
            else if message.type == "image"{
                myLabel.text = ""
               
             //  leftmessageimage.sd_setImage(with: URL(string: message.message ?? ""), completed: nil)
            
            }
            myView.isHidden = false
            myimage.isHidden = true
            senderView.isHidden = true

        }
        else {
          
            
            myimage.isHidden = false
            myimage.sd_setImage(with: URL(string: image), completed: nil)
            dateandtime.text = message.dateandtime.timeAgoSinceDate()
            if message.type == "text" {
                senderLabel.text = message.name
             
    
            }
            else if message.type == "image"{
                
             
                 senderLabel.text = ""
//               messageImage.sd_setImage(with: URL(string: message.message ?? ""), completed: nil)
                
               
                
               
            }
            
                
              
           
            
           
            senderMessage.text = message.message
            senderView.isHidden = false
            myView.isHidden = true
            
           
            
           
         
        }
        
    }
    
   

    
}
