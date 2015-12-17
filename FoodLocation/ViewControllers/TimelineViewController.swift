//
//  TimelineViewController.swift
//  FoodLocation
//
//  Created by VIMLAN.G on 8/11/15.
//  Copyright © 2015 VIMLAN.G. All rights reserved.
//

import UIKit
import Parse
import ConvenienceKit

class TimelineViewController: UIViewController, TimelineComponentTarget {
    
    @IBOutlet weak var tableView: UITableView!
    let defaultRange = 0..4
    let additionalRangeSize = 5
    
    var posts : [Post] = []
    var photoTakingHelper:PhotoTakingHelper?
    var timelineComponent : TimelineComponent<Post,TimelineViewController>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timelineComponent = TimelineComponent(target:self)
        self.tabBarController?.delegate = self
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        timelineComponent.loadInitialIfRequired()
        
        func loadInRange(range:Range<Int>, completionBlock:([Post]) -> Void) {
            
            ParseHelper.timelineRequestForCurrentUser(range) { (result:[AnyObject]?, error:NSError?) -> Void in
                
                let posts = result as? [Post] ?? []
                completionBlock(posts)
            }
        }
        
        
    }
    
}

extension TimelineViewController : UITabBarControllerDelegate {
    
    func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {
        
        if viewController is PhotoViewController {
            
            takePhoto()
            return false
            
        } else {
            
            return true
        }
    }
    
    func takePhoto() {
        
        photoTakingHelper = PhotoTakingHelper(viewController: self.tabBarController!) { (image:UIImage?) -> Void in
            
            let post = Post()
            post.image.value = image
            post.uploadPost()
        }
    }
}

extension TimelineViewController : UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return timelineComponent.content.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCellWithIdentifier("PostCell") as! PostTableViewCell!
        let post = timelineComponent.content[indexPath.row]
        post.downloadImage()
        post.fetchLikes()
        cell.post = post
        return cell
        
    }
    
}

extension TimelineViewController:UITableViewDelegate {
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        timelineComponent.targetWillDisplayEntry(indexPath.row)
    }
    
    
}

