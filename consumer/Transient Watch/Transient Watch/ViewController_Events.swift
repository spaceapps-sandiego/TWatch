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
        
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithURL(url!) { (data, response, error) -> Void in
            if error != nil {
                
                println("There was an error requesting event data from the server: "+error.description)
            } else {
                self.loadEventData(data)
            }
        }
        
        
        task.resume()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated:animated)
    }
    
    func loadEventData(eventData:NSData){
        let json = NSJSONSerialization.JSONObjectWithData(eventData, options: NSJSONReadingOptions(1), error: nil) as! NSDictionary
        let results = json["result"] as! NSArray;
        
        for detection in results {
            phenomenaEventData.append(detection as! NSDictionary)
//            println(self.phenomenaEventData)
        }
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.tableView.reloadData()
            self.tableView.reloadRowsAtIndexPaths(self.tableView.indexPathsForVisibleRows()!, withRowAnimation: UITableViewRowAnimation.Automatic)
        })
    }
    
// MARK: table programmatics
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.phenomenaEventData.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cellPhenomena") as! UITableViewCell
        var labelObjectName:UILabel = cell.viewWithTag(1) as! UILabel
        var labelObjectType:UILabel = cell.viewWithTag(2) as! UILabel
        var labelNumEvents:UILabel = cell.viewWithTag(3) as! UILabel
        var labelRightAscension:UILabel = cell.viewWithTag(5) as! UILabel
        var labelDeclination:UILabel = cell.viewWithTag(4) as! UILabel
        
        
        labelObjectName.text = (phenomenaEventData[indexPath.row]["name"] as! String)
        labelObjectType.text = (phenomenaEventData[indexPath.row]["type"] as! String)
        let events = phenomenaEventData[indexPath.row]["events"] as? Array<NSDictionary>
        labelNumEvents.text =  "Events \(events!.count)"
        labelRightAscension.text = "RA: "+String(stringInterpolationSegment: phenomenaEventData[indexPath.row]["ra"]!)
        labelDeclination.text = "Dec: "+String(stringInterpolationSegment: phenomenaEventData[indexPath.row]["dec"]!)
        
        return cell
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
