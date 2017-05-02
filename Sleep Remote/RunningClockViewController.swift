//
//  RunningClockViewController.swift
//  Sleep Remote
//
//  Created by Andrew on 5/1/17.
//  Copyright © 2017 BergCode. All rights reserved.
//

import UIKit
import Alamofire
import CoreMotion

class RunningClockViewController: UIViewController {
    
    let connectUrl = "http://10.0.0.201:5000/signal"

    @IBOutlet weak var countdownLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var stop: UIButton!
    @IBOutlet weak var shutoffLabel: UILabel!
    
    var updateTimeTimer = Timer()
    var timerX = Timer()
    var resetAverageTimer = Timer()
    var countdownTimer = Timer()
    
    var countdownMax = 600
    var countdown = 600
    var countUp = 0
    
    var averageX = 0.0
    var totalX = 0.0
    var samplesCountX = 0.0
    
    var xValue = 0.0
    
    var threshold = 0.0 as Float
    
    var motionManager = CMMotionManager()
    
    var runStorage: [String] = [String]()
    
    var curMovie = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // start the timer for updating the clock
        updateCurrentTime()
        updateTimeTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(updateCurrentTime), userInfo: nil, repeats: true)
        
        // setup the stop button look
        
        stop.backgroundColor = UIColor.blue
        stop.layer.cornerRadius = 5
        stop.layer.borderWidth = 1
        stop.layer.borderColor = UIColor.black.cgColor
        
        // Do any additional setup after loading the view.
        getCountdownTimes()
        setupCountDownTime()
        loadInThreshold()
        
        //loadOld()
        
        print(threshold)
        
        // start the tracking
        startTracking()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // function for storing the amount of time that the user fell asleep ago
    func storeLastTime() {
        let defaults = UserDefaults.standard
        
        defaults.set(countUp, forKey: "lastsleeptime")
    }
    
    // updates the current time every five seconds
    func updateCurrentTime() {
        let date = Date()
        let calendar = Calendar.current
        
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        
        let by12Hour = hour % 12

        if (hour >= 12) {
            dateLabel.text = "\(by12Hour):\(String(format: "%02d", minutes)) PM"
        } else {
            dateLabel.text = "\(by12Hour):\(String(format: "%02d", minutes)) AM"
        }
    }
    
    @IBAction func stopButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func updateCountdown() {
        countdown -= 1
        countUp += 1
        
        if (countdown < 1) {
            countdown = 0
        }
        
        countdownLabel.text = secsToMinutes(secs: countdown)
        
        // updateChart()
    }
    
    func getCountdownTimes() {
        let defaults = UserDefaults.standard
        
        let mins = defaults.integer(forKey: "minutes")
        
        countdownMax = mins * 60
        countdown = mins * 60
    }
    
    func setupCountDownTime() {
        countdownLabel.text = secsToMinutes(secs: countdownMax)
    }
    
    func secsToMinutes(secs: Int) -> String {
        return String(format: "%02d:%02d", secs/60, secs%60)
    }
    
    func loadInThreshold() {
        let defaults = UserDefaults.standard
        
        var curCalib = defaults.float(forKey: "calib")
        
        if (curCalib == 0) {
            curCalib = 0.05
        }
        
        threshold = curCalib
    }
    
    func startTracking() {
        timerX = Timer.scheduledTimer(timeInterval: 1,
                                      target: self,
                                      selector: #selector(self.getAverage),
                                      userInfo: nil,
                                      repeats: true)
        
        resetAverageTimer = Timer.scheduledTimer(timeInterval: 15,
                                                 target: self,
                                                 selector: #selector(self.resetAverage),
                                                 userInfo: nil,
                                                 repeats: true)
        
        countdownTimer = Timer.scheduledTimer(timeInterval: 1,
                                              target: self,
                                              selector: #selector(self.updateCountdown),
                                              userInfo: nil,
                                              repeats: true)
        
        
        motionManager.deviceMotionUpdateInterval = 0.01
        motionManager.startAccelerometerUpdates(to: OperationQueue.current!) { (accelerometerData: CMAccelerometerData?, NSError) -> Void in
            
            //self.updateLabels(acc: accelerometerData!)
            self.isSignicantEvent(acc: accelerometerData!)
            
            if (self.countdown <= 0) {
                self.makeRequest()
                self.cleanup()
            }
            
            self.xValue = fabs((accelerometerData?.acceleration.x)!)
            
            if(NSError != nil) {
                print("\(String(describing: NSError))")
            }
        }

    }
    
    func isSignicantEvent(acc: CMAccelerometerData) {
        // if is sig event must reset the timer for the clock
        let a = acc.acceleration
        
        if ((fabs(averageX - a.x) > Double(threshold)) && averageX != 0.0) {
            // AudioServicesPlaySystemSound (systemSoundID)
            resetCountdown()
        }
    }
    
    func getAverage() {
        totalX += xValue
        samplesCountX += 1
        
        averageX = totalX/samplesCountX
    }

    func resetAverage() {
        averageX = 0.0
        totalX = 0.0
        samplesCountX = 0.0
        
        // print("Reset average")
    }
    
    func makeRequest() {
        Alamofire.request(connectUrl).responseJSON { response in
            self.signalSent()
        }
        
        print(countUp)
    }
    
    func signalSent() {
        shutoffLabel.text = "Shutoff signal sent... \(secsToMinutes(secs: countUp)) minutes to fall asleep"
    }
    
    func cleanup() {
        motionManager.stopAccelerometerUpdates()
        
        timerX.invalidate()
        resetAverageTimer.invalidate()
        countdownTimer.invalidate()
        
        resetAverage()
        updateCountdown()
        
        // save the run with cur movie name and count up time
        runStorage.append(curMovie)
        runStorage.append(secsToMinutes(secs: countUp))
        
        print(runStorage)
        
        //saveNew()
        //storeLastTime()
        //setLastShow()
    }
    
    func resetCountdown() {
        if (countdownMax - countdown > 120) {
            countdown += countdownMax/10
        }
        
        countdown = countdownMax
        countdownLabel.text = secsToMinutes(secs: countdown)
       // print("Reset the timer!")
    }
    
    func saveNew() {
        let defaults = UserDefaults.standard
        
        defaults.set(runStorage, forKey: "storage")
    }
    
    func loadOld() {
        let defaults = UserDefaults.standard
        
        runStorage = defaults.array(forKey: "storage") as! [String]
        //print(runStorage)
    }
    
    func loadCurMovie() {
        let defaults = UserDefaults.standard
        
        curMovie = defaults.string(forKey: "curmovie")!
    }
    
    func setLastShow() {
        let defaults = UserDefaults.standard
        
        defaults.set(curMovie, forKey: "lastshow")
    }
}
