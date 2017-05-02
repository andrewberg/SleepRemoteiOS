//
//  ConnectionTestViewController.swift
//  Sleep Remote
//
//  Created by Andrew on 5/1/17.
//  Copyright © 2017 BergCode. All rights reserved.
//

import UIKit
import Alamofire

class ConnectionTestViewController: UIViewController {
    
    let connectUrl = "http://10.0.0.201:5000/connect"
    
    @IBOutlet weak var connectLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        reconnectButton(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func reconnectButton(_ sender: Any) {
        var succ = false
        
        Alamofire.request(connectUrl).responseJSON { response in
            succ = true
            
            if (succ) {
                self.setConnectLabel()
            }
        }
        
        self.setNoConnectLabel()
    }

    @IBAction func doneButton(_ sender: Any) {
        // go back to previous display
        self.dismiss(animated: true, completion: nil)
    }
    
    func setNoConnectLabel() {
        // call if the connection was not made
        
        connectLabel.text = "Connection failed, make sure you on your WiFi network and the Sleep Remote Module is on and try to reconnect."
        connectLabel.numberOfLines = 5
        connectLabel.textColor = UIColor.red
    }
    
    func setConnectLabel() {
        // call if the connection was made
        
        connectLabel.text = "CONNECTION SUCCESSFUL"
        connectLabel.numberOfLines = 5
        connectLabel.font = connectLabel.font.withSize(20)
        connectLabel.textColor = UIColor.green
    }
    
}
