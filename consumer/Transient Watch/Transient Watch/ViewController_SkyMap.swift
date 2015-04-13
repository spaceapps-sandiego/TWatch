//
//  ViewController_SkyMap.swift
//  Transient Watch
//
//  Created by Cristoffer Fairweather on 4/11/15.
//  Copyright (c) 2015 C Fairweather. All rights reserved.
//

import UIKit
import AVFoundation
import CoreLocation
import CoreMotion


class ViewController_SkyMap: UIViewController, CLLocationManagerDelegate {
    @IBOutlet weak var uiImageViewCamera: UIImageView!
    var previewLayer : CALayer?
    var labelLayer : CALayer?
    
    // SJP
    let captureSession = AVCaptureSession()
    let locationManager = CLLocationManager()
    let motionManager = CMMotionManager()
    
    let myLocationLatLabel = UILabel()
    let myLocationLatVal = UILabel()
    let myLocationLongLabel = UILabel()
    let myLocationLongVal = UILabel()
    
    let myPitchLabel = UILabel()
    let myPitchVal = UILabel()
    let myRollLabel = UILabel()
    let myRollVal = UILabel()
    let myYawLabel = UILabel()
    let myYawVal = UILabel()

    
    var captureDevice : AVCaptureDevice?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // SJP: get location of the user
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        
        // SJP: accelometer, tilt, etc..
        if motionManager.gyroAvailable {
            motionManager.deviceMotionUpdateInterval = 0.2;
            motionManager.startDeviceMotionUpdates()
            
            motionManager.gyroUpdateInterval = 0.2
            motionManager.startGyroUpdatesToQueue(NSOperationQueue.currentQueue()) {
                [weak self] (gyroData: CMGyroData!, error: NSError!) in
                
                self?.outputRotationData(gyroData.rotationRate)
                if error != nil {
                    println("\(error)")
                }
            }
        }
        else
        {
            var alert = UIAlertController(title: "No gyro", message: "Get a Gyro", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }

        
        // setup some label specs
        myLocationLatLabel.textColor = UIColor.redColor()
        myLocationLatLabel.text = "Lat :";
        myLocationLatLabel.frame = CGRectMake(15, 54, 50, 20)

        myLocationLatVal.textColor = UIColor.redColor()
        myLocationLatVal.text = "";
        myLocationLatVal.frame = CGRectMake(70, 54, 200, 20)
        
        myLocationLongLabel.textColor = UIColor.redColor()
        myLocationLongLabel.text = "Long:";
        myLocationLongLabel.frame = CGRectMake(15, 74, 50, 20)
        
        myLocationLongVal.textColor = UIColor.redColor()
        myLocationLongVal.text = "";
        myLocationLongVal.frame = CGRectMake(70, 74, 200, 20)
 
        myPitchLabel.textColor = UIColor.redColor()
        myPitchLabel.text = "Pitch:";
        myPitchLabel.frame = CGRectMake(15, 104, 50, 20)
        
        myPitchVal.textColor = UIColor.redColor()
        myPitchVal.text = "";
        myPitchVal.frame = CGRectMake(70, 104, 200, 20)
        
        myRollLabel.textColor = UIColor.redColor()
        myRollLabel.text = "Roll:";
        myRollLabel.frame = CGRectMake(15, 124, 50, 20)
        
        myRollVal.textColor = UIColor.redColor()
        myRollVal.text = "";
        myRollVal.frame = CGRectMake(70, 124, 200, 20)
        
        myYawLabel.textColor = UIColor.redColor()
        myYawLabel.text = "Roll:";
        myYawLabel.frame = CGRectMake(15, 144, 50, 20)
        
        myYawVal.textColor = UIColor.redColor()
        myYawVal.text = "";
        myYawVal.frame = CGRectMake(70, 144, 200, 20)
        
        
        // SJP: get the back camera device
        captureSession.sessionPreset = AVCaptureSessionPresetHigh //AVCaptureSessionPresetLow
        let devices = AVCaptureDevice.devices()
        for device in devices {
            if (device.hasMediaType(AVMediaTypeVideo)) {
                if (device.position == AVCaptureDevicePosition.Back) {
                    captureDevice = device as? AVCaptureDevice
                }
            }
        }
        
        // if device is present, begin our session
        if captureDevice != nil {
            beginSession()
        }
        
        self.view.addSubview(myLocationLatLabel)
        self.view.addSubview(myLocationLatVal)
        self.view.addSubview(myLocationLongLabel)
        self.view.addSubview(myLocationLongVal)

        self.view.addSubview(myPitchLabel)
        self.view.addSubview(myPitchVal)
        self.view.addSubview(myRollLabel)
        self.view.addSubview(myRollVal)
        self.view.addSubview(myYawLabel)
        self.view.addSubview(myYawVal)
        
        motionManager.startDeviceMotionUpdates()
        
        // end SJP
        
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
    
    // SJP: location
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        
        CLGeocoder().reverseGeocodeLocation(manager.location, completionHandler: { (placemarks, error) -> Void in
 
            if (error != nil) {
                
                println("Error:" + error.localizedDescription)
                return
            }
            
            if placemarks.count > 0 {
            
                let pm = placemarks[0] as! CLPlacemark
            
                self.displayLocationInfo(pm)
            }
            else
            {
                println("Error with data")
            }
        })
    }
    

    // SJP: location
    func displayLocationInfo(placemark: CLPlacemark) {
        
        self.locationManager.startUpdatingLocation()

        //println(placemark.location)
        
        myLocationLatVal.text = placemark.location.coordinate.latitude.description
        myLocationLongVal.text = placemark.location.coordinate.longitude.description
        
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        
        println("Error: " + error.localizedDescription)
    }
    
    
    func outputRotationData(rotation:CMRotationRate)
    {
        var attitude = CMAttitude()
        var motion = CMDeviceMotion()
        motion = motionManager.deviceMotion
        attitude = motion.attitude
        
        
        myYawVal.text = NSString (format: "Yaw: %.2f", attitude.yaw) as String //radians to degress NOT WORKING
        myPitchVal.text = NSString (format: "Pitch: %.2f", attitude.pitch) as String //radians to degress NOT WORKING
        myRollVal.text = NSString (format: "Roll: %.2f", attitude.roll) as String //radians to degress NOT WORKING
    }
    
    
    
    // SJP:
    func beginSession() {
        var err : NSError? = nil
        captureSession.addInput(AVCaptureDeviceInput(device: captureDevice, error: &err))
        
        if err != nil {
            println("error: \(err?.localizedDescription)")
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        self.view.layer.addSublayer(previewLayer)
        previewLayer?.frame = self.view.layer.frame
        
//        // SJP: adding second layer
//        labelLayer = CALayer()
//
//        self.view.layer.addSublayer(labelLayer)
//        labelLayer?.frame = self.view.layer.frame
        
        captureSession.startRunning()
    }
    
    override func willRotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {

        // we will need to detect rotation somehow to rotate the labels, but the main app shouldn't rotate.
    
    }



}
