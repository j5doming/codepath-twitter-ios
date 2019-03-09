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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.loadTweets()
    }
    
    @IBAction func onLogout(_ sender: Any) {
        TwitterAPICaller.client?.logout()
        UserDefaults.standard.set(false, forKey: Constants.Keys.userLoggedInKey)
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func loadTweets() {
        numberOfTweets = Constants.numberOfTweetsToRetrieve
        let params = ["count": numberOfTweets]
        TwitterAPICaller.client?.getDictionariesRequest(url: Constants.URLs.homeTimelineUrl, parameters: params, success: { (retrievedTweets: [NSDictionary]) in
          
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
    
    // allow more tweets to be shown when reaching the bottom
    func loadMoreTweets() {
        numberOfTweets += 20
        let params = ["count": numberOfTweets]
        
        TwitterAPICaller.client?.getDictionariesRequest(url: Constants.URLs.homeTimelineUrl, parameters: params, success: { (retrievedTweets: [NSDictionary]) in
            
            self.tweets.removeAll()
            for tweet in retrievedTweets {
                self.tweets.append(tweet)
            }
            
            self.tableView.reloadData()
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
    
    // populate each table
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Identifiers.tweetCellIdentifier, for: indexPath) as! TweetTableViewCell
        
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
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == tweets.count {
            loadMoreTweets()
        }
    }
}
