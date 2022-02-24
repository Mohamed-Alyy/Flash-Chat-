//
//  MessageCell.swift
//  Flash Chat iOS13
//
//  Created by Mohamed Ali on 16/02/2022.
//  Copyright © 2022 Angela Yu. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var messageBubbleView: UIView!{
        didSet{
            messageBubbleView.layer.cornerRadius = messageBubbleView.frame.height / 3
        }
    }
    
    @IBOutlet weak var messageLBL: UILabel!
    
    @IBOutlet weak var messageAvatar: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
