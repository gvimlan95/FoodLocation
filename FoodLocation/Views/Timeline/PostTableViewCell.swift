//
//  PostTableViewCell.swift
//  FoodLocation
//
//  Created by VIMLAN.G on 8/11/15.
//  Copyright © 2015 VIMLAN.G. All rights reserved.
//

import UIKit
import Bond
import Parse

class PostTableViewCell: UITableViewCell {
    
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var likesIconImageView: UIImageView!
    @IBOutlet weak var likesLabel: UILabel!
    
    var likeBond : Bond<[PFUser]?>!
    
    @IBAction func likeButton(sender: AnyObject) {
        
        post?.toggleLikePost(PFUser.currentUser()!)
        
    }
    
    @IBAction func moreButton(sender: AnyObject) {
        
    }
    
    required init(coder aDecoder : NSCoder) {
        
        super.init(coder:aDecoder)
        
        likeBond = Bond<[PFUser]?>() { [unowned self] likeList in
            
            if let likeList = likeList {
                
                self.likesLabel.text = self.stringFromUserList(likeList)
                
                self.likesButton.selected = contains(likeList,PFUser.currentUser()!)
                
                self.likesIconImageView.hidden = (likeList.count == 0)
            }else {
                
                self.likesLabel.text = ""
                self.likeButton.selected = false
                self.likesIconImageView.hidden = true
            }
            
        }
        
        
        
        var post:Post? {
            didSet {
                
                if let post = post {
                    
                    post.image ->> self.postImageView
                    
                    post.likes ->> self.likeBond
                }
            }
        }
        
        
        func stringFromUserList(userList:[PFUser]) -> String {
            
            let usernameList = userList.map {user in user.username!}
            let commaSeparatedUserList = ", ".join(usernameList)
            return commaSeparatedUserList
            
        }
        
        
        override func awakeFromNib() {
            super.awakeFromNib()
            // Initialization code
        }
        
        override func setSelected(selected: Bool, animated: Bool) {
            super.setSelected(selected, animated: animated)
            
            // Configure the view for the selected state
        }
        
    }
}
