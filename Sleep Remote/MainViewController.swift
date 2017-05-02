//
//  MainViewController.swift
//  Sleep Remote
//
//  Created by Andrew on 3/6/17.
//  Copyright © 2017 BergCode. All rights reserved.
//

import UIKit
import CoreMotion
import AVFoundation
import Charts

class MainViewController: UIViewController, ChartViewDelegate {
    var site = "http://10.0.0.201:5000"
    var motionManager = CMMotionManager()

    @IBOutlet weak var chartView: LineChartView!
    
    @IBOutlet weak var xLabel: UILabel!
    @IBOutlet weak var maxXLabel: UILabel!

    @IBOutlet weak var thresholdLabel: UILabel!
    @IBOutlet weak var requestLabel: UILabel!
    @IBOutlet weak var averageXLabel: UILabel!
    @IBOutlet weak var countdownLabel: UILabel!

    @IBOutlet weak var thresholdSlider: UISlider!
    
    let systemSoundID: SystemSoundID = 1016

    var countdownMax = 600
    var countdown = 600
    var countUp = 0
    
    var timerX = Timer()
    var resetAverageTimer = Timer()
    var countdownTimer = Timer()
    
    var maxX = 0.0
    var maxY = 0.0
    var maxZ = 0.0
    
    var xValue = 0.0
    
    var averageX = 0.0
    var totalX = 0.0
    var samplesCountX = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        thresholdLabel.text = "Current Threshold: \(thresholdSlider.value)"
        countdownLabel.text = "Countdown till signal: " + convertToMinutes(val: countdownMax)
        
        setupChart()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sendRequest(_ sender: UIButton) {
        makeRequest()
    }
    
    func makeRequest() {
        requestLabel.text = "Making request..."
        
        getRequest()
            {() -> (Void) in
        }

    }
    
    func getRequest(completionHandler:@escaping () -> ()) {
        //let config = URLSessionConfiguration.default // Session Configuration
        //let session = URLSession(configuration: config) // Load configuration into Session
        
        let url = URL(string: site)
        let task = URLSession.shared.dataTask(with: url!) { data, response, error in
            guard error == nil else {
                print(error!)
                return
            }
            guard let data = data else {
                print("Data is empty")
                return
            }
            
            //let json = try! JSONSerialization.jsonObject(with: data, options: [])
            self.requestLabel.text = String(data: data, encoding: .utf8)!
        }
        task.resume()
    }

    @IBAction func startTracking(_ sender: Any) {
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
            
            self.updateLabels(acc: accelerometerData!)
            self.isSignicantEvent(acc: accelerometerData!)
            
            if (self.countdown <= 0) {
                self.makeRequest()
                self.stopTracking(self)
            }
            
            if(NSError != nil) {
                print("\(NSError)")
            }
        }
    }
    
    func isSignicantEvent(acc: CMAccelerometerData) {
        // if is sig event must reset the timer for the clock
        let a = acc.acceleration
        
        if ((fabs(averageX - a.x) > Double(thresholdSlider.value)) && averageX != 0.0) {
            // AudioServicesPlaySystemSound (systemSoundID)
            resetCountdown()
        }
    }
    
    func resetLabels() {
        xLabel.text = "X: 0.0"
        
        
        averageXLabel.text = "AverageX: 0.0"
        
        countdownLabel.text = "Countdown till signal: " + convertToMinutes(val: countdown)
    }
    
    @IBAction func stopTracking(_ sender: Any) {
        cleanup()
    }
    
    func cleanup() {
        motionManager.stopAccelerometerUpdates()
        resetLabels()
        
        timerX.invalidate()
        resetAverageTimer.invalidate()
        countdownTimer.invalidate()
        
        resetAverage()
        updateCountdown()
        
        countUp = 0
    }
    
    func updateLabels(acc: CMAccelerometerData) {
        xValue = fabs(acc.acceleration.x)
        
        xLabel.text = "X: \(fabs(acc.acceleration.x))"
        

        
        averageXLabel.text = "AverageX: \(fabs(averageX))"
        
    }
    
    @IBAction func sliderUpdate(_ sender: Any) {
        thresholdLabel.text = "Current Threshold: \(thresholdSlider.value)"
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
    }
    
    func updateCountdown() {
        countdown -= 1
        countUp += 1
        
        if (countdown < 1) {
            countdown = 0
        }
        
        countdownLabel.text = "Countdown till signal: " + convertToMinutes(val: countdown)
        
        updateChart()
    }
    
    func resetCountdown() {
        countdown = countdownMax
        countdownLabel.text = "Countdown till signal: " + convertToMinutes(val: countdown)
    }
    
    func setupChart() {
        chartView.backgroundColor = UIColor.gray
        
        var yVals1 : [ChartDataEntry] = [ChartDataEntry]()
        yVals1.append(ChartDataEntry(x: Double(0), y: Double(0)))
        
        
        // 2 - create a data set with our array
        let set1: LineChartDataSet = LineChartDataSet(values: yVals1, label: "X Values")
        set1.circleRadius = 1.0
        
        var dataSets : [LineChartDataSet] = [LineChartDataSet]()
        dataSets.append(set1)
        
        //4 - pass our months in for our x-axis label value along with our dataSets
        let data: LineChartData = LineChartData(dataSets: dataSets)
        
        //5 - finally set our data
        self.chartView.data = data
    }
    
    func updateChart() {
        chartView.data?.addEntry(ChartDataEntry(x: Double(countUp), y: xValue), dataSetIndex: 0)
        chartView.setVisibleXRange(minXRange: 1, maxXRange: 50)
        chartView.notifyDataSetChanged()
        chartView.moveViewToX(Double(countUp))
    }
    
    func convertToMinutes(val: Int) -> String {
        return String(format: "%02d:%02d", val/60, val%60)
    }

}
