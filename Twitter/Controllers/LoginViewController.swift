//
//  LoginViewController.swift
//  Twitter
//
//  Created by Juan Dominguez on 2/26/19.
//  Copyright © 2019 Dan. All rights reserved.
//

struct Constants {
    struct Identifiers {
        static let homeSegueIdentifier = "loginToHome"
        static let tweetCellIdentifier = "tweetCell"
    }
    struct Keys {
        static let userLoggedInKey = "userLoggedIn"
    }
    struct URLs {
        static let authUrl = "https://api.twitter.com/oauth/request_token"
        static let homeTimelineUrl = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        static let postTweetUrl = "https://api.twitter.com/1.1/statuses/update.json"
        static let postFavoriteUrl = "https://api.twitter.com/1.1/favorites/create.json"
        static let destroyFavoriteUrl = "https://api.twitter.com/1.1/favorites/destroy.json"
        static let postRetweetUrl = "https://api.twitter.com/1.1/statuses/retweet/"
        static let postUnretweetUrl = "https://api.twitter.com/1.1/statuses/unretweet/"
    }
    
    static let numberOfTweetsToRetrieve = 20
}

import UIKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if UserDefaults.standard.bool(forKey: Constants.Keys.userLoggedInKey) == true {
            self.performSegue(withIdentifier: Constants.Identifiers.homeSegueIdentifier, sender: self)
        }
    }
    
    // TODO: if this causes fail, might be cause I moved it
    @IBAction func onLoginButton(_ sender: Any) {
        TwitterAPICaller.client?.login(url: Constants.URLs.authUrl, success: {
            UserDefaults.standard.set(true, forKey: Constants.Keys.userLoggedInKey)
            self.performSegue(withIdentifier: Constants.Identifiers.homeSegueIdentifier, sender: self)
        }, failure: { (Error) in
            print("Error: could not log in")
        })
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
