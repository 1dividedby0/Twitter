//
//  Tweet.swift
//  Twitter
//
//  Created by Dhruv Mangtani on 2/28/15.
//  Copyright (c) 2015 dhruv.mangtani. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    var user:User?
    var text:String?
    var createdAtString:String?
    var createdAt:NSDate?
    
    init(dictionary:NSDictionary){
        user = User(dictionary: dictionary["user"] as NSDictionary)
        text = dictionary["text"] as? String
        createdAtString = dictionary["created_at"] as? String
        var formatter = NSDateFormatter()
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        createdAt = formatter.dateFromString(createdAtString!)
    }
    
    class func tweetsWithArray(array: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        for dictionary in array{
            tweets.append(Tweet(dictionary: dictionary))
        }
        return tweets
    }
}
