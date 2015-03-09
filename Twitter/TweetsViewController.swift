//
//  TweetsViewController.swift
//  Twitter
//
//  Created by Dhruv Mangtani on 2/28/15.
//  Copyright (c) 2015 dhruv.mangtani. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    @IBOutlet weak var newTweetButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    var tweets = [Tweet]()
    var refreshControl: UIRefreshControl!
    var selectedTweet:Tweet!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.registerNib(UINib(nibName: "TweetTableViewCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "TweetCell")
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refreshControl)
        getHomeTimeline()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var tweet = tweets[indexPath.row]
        self.selectedTweet = tweet
        println(tweet.text)
        performSegueWithIdentifier("detailsSegue", sender: self)
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: TweetTableViewCell = tableView.dequeueReusableCellWithIdentifier("TweetCell") as TweetTableViewCell
        var tweet = tweets[indexPath.row]
        var user = tweet.user!
        cell.tweetTextLabel.text = tweet.text
        cell.displayNameLabel.text = tweet.user?.name
        cell.nameLabel.text = "@\(tweet.user!.screenname!)"
        let profileURL = NSURL(string: user.profileImageURL!)
        var data = NSData(contentsOfURL: profileURL!)
        cell.profileImageView.image = UIImage(data: data!)
        return cell
    }
    func refresh(){
        getHomeTimeline()
    }
    func getHomeTimeline(){
        TwitterClient.sharedInstance.homeTimelineWithParams(nil, completion: { (tweets, error) -> () in
            if error == nil{
                self.tweets = tweets!
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
                self.tableView.reloadData()
            }else{
                println("error loading tweets")
            }
        })
    }
    @IBAction func onLogout(sender: AnyObject) {
        User.currentUser?.logout()
    }
    
    @IBAction func newTweet(sender: AnyObject) {
        
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "detailsSegue"{
        let detailsViewController = segue.destinationViewController as? TweetDetailsViewController
            println(segue.destinationViewController is UINavigationController)
            detailsViewController?.tweet = self.selectedTweet
            
        }
    }
    

}
