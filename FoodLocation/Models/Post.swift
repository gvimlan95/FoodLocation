//
//  Post.swift
//  FoodLocation
//
//  Created by VIMLAN.G on 8/11/15.
//  Copyright © 2015 VIMLAN.G. All rights reserved.
//

import UIKit
import Foundation
import Parse
import Bond

class Post : PFObject, PFSubclassing {
    
    
    @NSManaged var imageFile: PFFile?
    @NSManaged var user : PFUser?
    var image : Dynamic<UIImage?> = Dynamic(nil)
    var likes = Dynamic<[PFUser]?>(nil)
    
    static func parseClassName() -> String {
        return "Post"
    }
    
    override init() {
        
        super.init()
    }
    
    override class func initialize() {
        
        var onceTaken : dispatch_once_t = 0
        dispatch_once(&onceTaken) {
            
            self.registerSubclass()
        }
    }
    
    func uploadPost() {
        
        var photoUploadTask : UIBackgroundTaskIdentifier?
        
        let imageData = UIImageJPEGRepresentation(self.image.value, 0.2)
        let imageFile = PFFile(data: imageData!)
        
        photoUploadTask = UIApplication.sharedApplication().beginBackgroundTaskWithExpirationHandler { () -> Void in
            
            UIApplication.sharedApplication().endBackgroundTask(photoUploadTask!)
        }
        
        imageFile.saveInBackgroundWithBlock { (success:Bool, error:NSError?) -> Void in
            
            UIApplication.sharedApplication().endBackgroundTask(photoUploadTask!)
        }
        
        user = PFUser.currentUser()
        self.imageFile = imageFile
        saveInBackgroundWithBlock(nil)
    }
    
    func downloadImage() {
        
        if image.value == nil {
            
            imageFile?.getDataInBackgroundWithBlock { (data:NSData?, error:NSError?) -> Void in
                
                if let data = data {
                    
                    let image = UIImage(data: data, scale: 1.0)
                    self.image.value = image
                }
            }
        }
    }
    
    func fetchLikes() {
        
        if(likes.value != nil){
            return
        }
        
        ParseHelper.likesForPost(self,completionBlock : {(var likes:[AnyObject], error:NSError?) -> Void in
            
            likes = likes?.filter { like in like[ParserHelper.ParseLikeFromUser] != nil } //to check if the account still available and not deleted
            
            self.likes.value = likes?.map { like in
                let like = like as! PFObject
                let fromUser = like[ParseHelper.ParseLikeFromUser] as! PFUser
                
                return fromuser
            }
        })
    }
    
    func doesUserLikePost(user:PFUser) -> Bool {
     
        if let likes = likes.value {
            
            return contains(likes,user)
        }
        return false
    }
    
    func toggleLikePost(user:PFUser) {
        
        if(doesUserLikePost(user)) {
            
            likes.value = likes.value?.filter { $0 != user}
            ParseHelper.unlikePost(user,post:self)
        }else{
            
            likes.value?.append(user)
            ParseHelper.likePost(user, post: self)
        }
    }
}
