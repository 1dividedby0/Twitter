//
//  TwitterClient.swift
//  Twitter
//
//  Created by Dhruv Mangtani on 2/26/15.
//  Copyright (c) 2015 dhruv.mangtani. All rights reserved.
//

import UIKit

let twitterConsumerKey = "yXbHGvMv0dT4QUOdySwUTkgnW"
let twitterConsumerSecret = "1I1NJuGJI3i1DC0MApdwseXbWPu5xLUI1cAHanZVnrpgWuhwmD"
let twitterURL = NSURL(string: "https://api.twitter.com")

class TwitterClient: BDBOAuth1RequestOperationManager {
    
    var globalTweets:[Tweet]?
    var loginCompletion: ((user:User?, error: NSError?) -> ())?
    
    class var sharedInstance: TwitterClient{
        struct Static{
            static let instance = TwitterClient(baseURL:twitterURL, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
        }
        return Static.instance
    }
    
    func homeTimelineWithParams(params: NSDictionary?, completion: (tweets: [Tweet]?, error: NSError?) -> ()){
        GET("1.1/statuses/home_timeline.json", parameters: params, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                var tweets = Tweet.tweetsWithArray(response as [NSDictionary])
                completion(tweets: tweets, error: nil)
            }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println("Failed to get home timeline")
                completion(tweets: nil, error: error)
                println(error)
        }
        
    }
    
    func postTweetWithCompletion(tweet: String, replyId: Int?, completion: (tweet: Tweet?, error: NSError?) -> Void){
        var parameters = ["status":tweet]
        if replyId != nil{
            parameters.updateValue("\(replyId!)", forKey: "in_reply_to_status_id")
        }
        self.POST("https://api.twitter.com/1.1/statuses/update.json", parameters: parameters, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            var tweet = Tweet(dictionary: response as NSDictionary)
            completion(tweet: tweet, error: nil)
            }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
            println(error)
            completion(tweet: nil, error: error)
        }
    }
    
    func openURL(url: NSURL){
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: BDBOAuth1Credential(queryString: url.query), success: { (accessToken: BDBOAuth1Credential!) -> Void in
            println("Got the access token")
            TwitterClient.sharedInstance.requestSerializer.saveAccessToken(accessToken)
            
            TwitterClient.sharedInstance.GET("1.1/account/verify_credentials.json", parameters: nil, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                //println("user: \(response)")
                var user = User(dictionary: response as NSDictionary)
                User.currentUser = user
                println("user: \(user.tagline!)")
                self.loginCompletion?(user: user, error: nil)
                }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println("failed getting info")
                self.loginCompletion?(user: nil, error: error)
            })
            
            TwitterClient.sharedInstance.GET("1.1/statuses/home_timeline.json", parameters: nil, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                println("home_timeline: \(response)")
                var tweets = Tweet.tweetsWithArray(response as [NSDictionary])
                self.globalTweets = tweets
                for tweet in tweets{
                    println("tweet: \(tweet.text), created: \(tweet.createdAt)")
                }
                }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                    println("error getting home timeline")
            })
            
            }) { (error: NSError!) -> Void in
                println("Failed to recieve access token")
                self.loginCompletion?(user: nil, error: error)
        }

    }
    
    func loginWithCompletion(completion: (user:User?, error: NSError?) -> ()) {
        loginCompletion = completion
        
        //Fetch request token and redirect to authorization page
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        TwitterClient.sharedInstance.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "cptwitterdemo://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) -> Void in
            println("Got the request token")
            var authURL = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")
            UIApplication.sharedApplication().openURL(authURL!)
            }) { (error: NSError!) -> Void in
                println("Failed to get request token")
                self.loginCompletion?(user: nil, error: error)
        }
    }
   }
