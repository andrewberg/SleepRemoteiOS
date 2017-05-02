//
//  RemoteViewController.swift
//  Sleep Remote
//
//  Created by Andrew on 5/1/17.
//  Copyright © 2017 BergCode. All rights reserved.
//

import UIKit

class RemoteViewController: UIViewController {
    @IBOutlet weak var start: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // setting up the buttons
        start.backgroundColor = UIColor.blue
        start.layer.cornerRadius = 5
        start.layer.borderWidth = 1
        start.layer.borderColor = UIColor.black.cgColor

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func startButton(_ sender: Any) {
        let vc = (
            storyboard?.instantiateViewController(
                withIdentifier: "running")
            )!
        vc.modalTransitionStyle = .crossDissolve
        present(vc, animated: true, completion: nil)
    }


}
