//
//  ViewController_Info.swift
//  Transient Watch
//
//  Created by Cristoffer Fairweather on 4/11/15.
//  Copyright (c) 2015 C Fairweather. All rights reserved.
//

import UIKit

class ViewController_Info: UIViewController, UIBarPositioningDelegate {
    
    @IBOutlet weak var uiImageBackground: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        var blurView:UIVisualEffectView=UIVisualEffectView.alloc();

        // Do any additional setup after loading the view.
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
