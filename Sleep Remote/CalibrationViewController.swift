//
//  CalibrationViewController.swift
//  Sleep Remote
//
//  Created by Andrew on 5/1/17.
//  Copyright © 2017 BergCode. All rights reserved.
//

import UIKit
import CoreMotion
import AVFoundation

class CalibrationViewController: UIViewController {
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var curCalibLabel: UILabel!
    
    let systemSoundID: SystemSoundID = 1016
    var started = false
    
    var motionManager = CMMotionManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // grab the value that is stored for calibration
        getCalib()
        
        // update the curCalibLabel
        curCalibLabel.text = "Current Calibration: \(slider.value)"

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sliderAction(_ sender: Any) {
        updateCalibLabel()
    }
    
    @IBAction func start(_ sender: Any) {
        
        if (!started) {
            motionManager.deviceMotionUpdateInterval = 0.01
            motionManager.startAccelerometerUpdates(to: OperationQueue.current!) { (accelerometerData: CMAccelerometerData?, NSError) -> Void in
            self.isSignicantEvent(acc: accelerometerData!)
            }
        }
    }
    
    @IBAction func stop(_ sender: Any) {
        cleanup()
    }
    
    @IBAction func done(_ sender: Any) {
        // set calibration before we leave the view
        
        setCalib()
        
        // cleanup before we leave the view
        cleanup()
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func isSignicantEvent(acc: CMAccelerometerData) {
        // if is sig event must reset the timer for the clock
        let a = acc.acceleration
        
        print(a.x)
        
        if (fabs(a.x) > Double(slider.value)) {
            AudioServicesPlaySystemSound (self.systemSoundID)
        }
    }
    
    func cleanup() {
        motionManager.stopAccelerometerUpdates()
    }
    
    func getCalib() {
        let defaults = UserDefaults.standard
        
        var curCalib = defaults.float(forKey: "calib")
        
        if (curCalib == 0) {
            curCalib = 0.5
        }
        
        slider.value = curCalib
    }
    
    func setCalib() {
        let defaults = UserDefaults.standard
        
        defaults.set(slider.value, forKey: "calib")
    }
    
    func updateCalibLabel() {
        curCalibLabel.text = "Current Calibration: \(slider.value)"
    }
}
