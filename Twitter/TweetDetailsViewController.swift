//
//  TweetDetailsViewController.swift
//  Twitter
//
//  Created by Dhruv Mangtani on 3/7/15.
//  Copyright (c) 2015 dhruv.mangtani. All rights reserved.
//

import UIKit

class TweetDetailsViewController: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var otherNameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    
    var user:User?
    var tweet:Tweet?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Tweet"
        user = tweet?.user
        self.textLabel.text = tweet?.text
        self.screenNameLabel.text = user?.name
        self.otherNameLabel.text = user?.screenname
        var data = NSData(contentsOfURL: NSURL(string: user!.profileImageURL!)!)!
        self.profileImageView.image = UIImage(data: data)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
