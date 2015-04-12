//
//  ViewController_SkyMap.swift
//  Transient Watch
//
//  Created by Cristoffer Fairweather on 4/11/15.
//  Copyright (c) 2015 C Fairweather. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController_SkyMap: UIViewController {
    @IBOutlet weak var uiImageViewCamera: UIImageView!
    var previewLayer : CALayer?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    override func viewWillAppear(animated: Bool) {
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.Default, animated: false);
    }
    override func viewWillDisappear(animated: Bool) {
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: false);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
