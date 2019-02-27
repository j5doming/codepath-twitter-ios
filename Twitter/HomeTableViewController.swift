//
//  HomeTableViewController.swift
//  Twitter
//
//  Created by Juan Dominguez on 2/26/19.
//  Copyright © 2019 Dan. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController {
    
    let homeRefreshControl = UIRefreshControl()
    
    var tweets = [NSDictionary]()
    var numberOfTweets: Int!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadTweets()
        
        homeRefreshControl.addTarget(self, action: #selector(loadTweets), for: .valueChanged)
        
        tableView.refreshControl = homeRefreshControl
        
    }
    
    @IBAction func onLogout(_ sender: Any) {
        TwitterAPICaller.client?.logout()
        
        UserDefaults.standard.set(false, forKey: "userLoggedIn")
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func loadTweets() {
        let timelineUrl = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        let params = ["count": 20]
        TwitterAPICaller.client?.getDictionariesRequest(url: timelineUrl, parameters: params, success: { (retrievedTweets: [NSDictionary]) in
          
            self.tweets.removeAll()
            for tweet in retrievedTweets {
                self.tweets.append(tweet)
            }
            
            self.tableView.reloadData()
            self.homeRefreshControl.endRefreshing()
            
        }, failure: { (Error) in
            print("Error: Could not retreive tweets! \(Error)")
        })
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tweets.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as! TweetTableViewCell
        
        let user = tweets[indexPath.row]["user"] as! NSDictionary
        cell.userNameLabel.text = user["name"] as? String
        
        cell.tweetContentLabel.text = tweets[indexPath.row]["text"] as? String
        
        let imageUrlString = user["profile_image_url_https"] as? String
        let imageUrl = URL(string: imageUrlString!)
        let data = try? Data(contentsOf: imageUrl!)
        
        if let imageData = data {
            cell.profileImageView.image = UIImage(data: imageData)
        }
        
        return cell
    }
}
