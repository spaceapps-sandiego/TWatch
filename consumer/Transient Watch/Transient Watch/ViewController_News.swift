//
//  ViewController_News.swift
//  Transient Watch
//
//  Created by Cristoffer Fairweather on 4/11/15.
//  Copyright (c) 2015 C Fairweather. All rights reserved.
//

import UIKit
import TwitterKit
import Fabric

class ViewController_News: TWTRTimelineViewController, UIBarPositioningDelegate {

    convenience init() {
        

        let client = Twitter.sharedInstance().APIClient
        let dataSource = TWTRUserTimelineDataSource(screenName: "fabric", APIClient: client)
        
        self.init(dataSource: dataSource)
    }
    override required init(dataSource: TWTRTimelineDataSource) {
        super.init(dataSource: dataSource)
    }
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
//        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        Twitter.sharedInstance().startWithConsumerKey("tLYPquifU0Vq5GRRHnZbiSYr4", consumerSecret: "lS5zIjVxuTU0eLYcDqRUC5PrB3B0kC58H2ry6hrYbj4LPBIhhk")
//        Fabric.with([Twitter.sharedInstance()])
        
        Twitter.sharedInstance().logInGuestWithCompletion { guestSession, error in
            if (guestSession != nil) {
                // make API calls that do not require user auth
            } else {
                println("error: \(error.localizedDescription)");
            }
        }

        
        let client = Twitter.sharedInstance().APIClient
        let dataSource = TWTRUserTimelineDataSource(screenName: "fabric", APIClient: client)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func positionForBar(bar: UIBarPositioning) -> UIBarPosition{
        return UIBarPosition.TopAttached;
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
