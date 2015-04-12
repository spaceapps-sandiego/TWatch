//
//  ViewController_Events.swift
//  Transient Watch
//
//  Created by Cristoffer Fairweather on 4/11/15.
//  Copyright (c) 2015 C Fairweather. All rights reserved.
//

import UIKit


class ViewController_Events: UITableViewController, UIBarPositioningDelegate {
    
    var phenomenaEventData:Array<NSDictionary> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = NSURL(string: (serverPrefix as String)+"/api/v1/transients")
        let request = NSURLRequest(URL: url!)
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {(response, data, error) in
            
            if let resultError = error as NSError? {
                //Handle error!
            }else{
                self.loadEventData(data)
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated:animated)
    }
    
    func loadEventData(eventData:NSData){
        let json = NSJSONSerialization.JSONObjectWithData(eventData, options: NSJSONReadingOptions(1), error: nil) as! NSDictionary
        let results = json["result"] as! NSArray;
        
        for detection in results {
            phenomenaEventData.append(detection as! NSDictionary)
        }
//        println(self.phenomenaEventData)
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
