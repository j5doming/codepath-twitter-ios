//
//  TweetTableViewCell.swift
//  Twitter
//
//  Created by Juan Dominguez on 2/26/19.
//  Copyright © 2019 Dan. All rights reserved.
//

import UIKit

class TweetTableViewCell: UITableViewCell {
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var tweetContentLabel: UILabel!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var faveButton: UIButton!
    
    var favorited = false
    var retweeted = false
    var tweetId = -1
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func favoriteTweet(_ sender: Any) {
        let toBeFavorited = !favorited
        if (toBeFavorited) {
            TwitterAPICaller.client?.favoriteTweet(id: tweetId, success: {
                self.setFavorited(true)
            }, failure: { (error) in
                print("Could not favorite tweet: \(error)")
            })
        } else {
            TwitterAPICaller.client?.unfavoriteTweet(id: tweetId, success: {
                self.setFavorited(false)
            }, failure: { (error) in
                print("Could not unfavorite tweet: \(error)")
            })
        }
    }
    @IBAction func retweet(_ sender: Any) {
        let toBeRetweeted = !retweeted
        if (toBeRetweeted) {
            TwitterAPICaller.client?.retweet(id: tweetId, success: {
                self.setRetweeted(true)
            }, failure: { (error) in
                print("Could not retweet : \(error)")
            })
        } else {
            TwitterAPICaller.client?.unretweet(id: tweetId, success: {
                self.setRetweeted(false)
            }, failure: { (error) in
                print("Could not unretweet: \(error)")
            })
        }
    }
    
    func setFavorited(_ isFavorited: Bool) {
        favorited = isFavorited
        if favorited {
            faveButton.setImage(UIImage(named: "favor-icon-red"), for: UIControl.State.normal)
        } else {
            faveButton.setImage(UIImage(named: "favor-icon"), for: UIControl.State.normal)
        }
    }
    
    func setRetweeted(_ isRetweeted: Bool) {
        retweeted = isRetweeted
        if retweeted {
            retweetButton.setImage(UIImage(named: "retweet-icon-green"), for: UIControl.State.normal)
        } else {
            retweetButton.setImage(UIImage(named: "retweet-icon"), for: UIControl.State.normal)
        }
    }
    
}
