//
//  TestSignalViewController.swift
//  Sleep Remote
//
//  Created by Andrew on 5/1/17.
//  Copyright © 2017 BergCode. All rights reserved.
//

import UIKit
import Alamofire

class TestSignalViewController: UIViewController {
    @IBOutlet weak var resultLabel: UILabel!
    
    let connectUrl = "http://10.0.0.201:5000/signal"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        resultLabel.text = "Click Send Signal to test whether or not the signal to the TV is in working order"
        resultLabel.numberOfLines = 5

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sendSignal(_ sender: Any) {
        resultLabel.text = "Signal sent... if this is taking more than a few seconds you may have to join the WiFi network and make sure your Sleep Remote Module is running"
        resultLabel.numberOfLines = 5
        
        Alamofire.request(connectUrl).responseJSON { response in
            self.signalReceived()
        }
        
    }

    @IBAction func doneButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func signalReceived() {
        // run if the signal was received by the module
        
        resultLabel.text = "Signal received to the Sleep Remote, your TV should turn on if it is off and off if it is on."
        resultLabel.textColor = UIColor.green
        resultLabel.numberOfLines = 3
    }
}
