//
//  NewTweetViewController.swift
//  Twitter
//
//  Created by Dhruv Mangtani on 3/5/15.
//  Copyright (c) 2015 dhruv.mangtani. All rights reserved.
//

import UIKit

class NewTweetViewController: UIViewController {
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var otherNameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tweetTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        var user = User.currentUser
        nameLabel.text = user?.name
        otherNameLabel.text = user?.screenname
        var url: String = user!.profileImageURL!
        var data = NSData(contentsOfURL: NSURL(string: url)!)
        profileImageView.image = UIImage(data: data!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func newTweet(sender: AnyObject) {
        TwitterClient.sharedInstance.postTweetWithCompletion(tweetTextField.text, replyId: nil) { (tweet, error) -> Void in
            if tweet != nil{
                self.navigationController?.popViewControllerAnimated(true)
            }else{
                println(error)
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
