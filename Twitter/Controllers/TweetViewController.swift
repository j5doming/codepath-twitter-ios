//
//  TweetViewController.swift
//  Twitter
//
//  Created by Juan Dominguez on 3/8/19.
//  Copyright © 2019 Dan. All rights reserved.
//

import UIKit

class TweetViewController: UIViewController {
    @IBOutlet weak var tweetTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tweetTextView.becomeFirstResponder()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tweet(_ sender: Any) {
        if let tweetContent = tweetTextView.text {
            if ( !tweetContent.isEmpty ) {
                TwitterAPICaller.client?.postTweet(tweetString: tweetContent, success: {
                    self.dismiss(animated: true, completion: nil)
                }, failure: { (error) in
                    print("Error posting tweet: \(error)")
//                    self.dismiss(animated: true, completion: nil)
                    // TODO - in production actually show dialogue
                })
            } else {
                // TODO - change to something other than dismissing
                self.dismiss(animated: true, completion: nil)
            }
        }
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
