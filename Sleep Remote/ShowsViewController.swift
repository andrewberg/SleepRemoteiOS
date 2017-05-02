//
//  ShowsViewController.swift
//  Sleep Remote
//
//  Created by Andrew on 5/1/17.
//  Copyright © 2017 BergCode. All rights reserved.
//

import UIKit

class ShowsViewController: UIViewController {
    @IBOutlet weak var changeShows: UIButton!
    @IBOutlet weak var curShowLabel: UILabel!
    @IBOutlet weak var lastUseLabel: UILabel!
    @IBOutlet weak var stats: UIButton!
    
    var curshow = "The Office"
    var lastShow = "Trailer Park Boys"
    var lastSleepTime = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        // change buttons
        stats.backgroundColor = UIColor.blue
        stats.layer.cornerRadius = 5
        stats.layer.borderWidth = 1
        stats.layer.borderColor = UIColor.black.cgColor

        changeShows.backgroundColor = UIColor.blue
        changeShows.layer.cornerRadius = 5
        changeShows.layer.borderWidth = 1
        changeShows.layer.borderColor = UIColor.black.cgColor

        // getLastShow()
        //updateLastShowLabel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //getLastShow()
        //getCurShow()
        //updateCurShowLabel()
        //updateLastShowLabel()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func statsButton(_ sender: Any) {
        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        UserDefaults.standard.synchronize()
    }
    
    @IBAction func changeShowsButton(_ sender: Any) {
        let vc = (
            storyboard?.instantiateViewController(
                withIdentifier: "showpicker")
            )!
        vc.modalTransitionStyle = .crossDissolve
        present(vc, animated: true, completion: nil)
        
    }
    
    func getCurShow() {
        let defaults = UserDefaults.standard
        
        curshow = defaults.string(forKey: "curmovie")!
    }
    
    func updateCurShowLabel() {
        curShowLabel.text = "Current show: \(curshow)"
    }
    
    func updateLastShowLabel() {
        
        lastUseLabel.text = "Amount of time you missed on \(lastShow) was: \(secsToMinutes(secs: getLastSleepTime()))"
    }
    
    func getLastShow() {
        let defaults = UserDefaults.standard
        
        lastShow = defaults.string(forKey: "lastmovie")!
    }
    
    func setLastShow() {
        let defaults = UserDefaults.standard
        
        defaults.string(forKey: "lastmovie")
    }
    
    func getLastSleepTime() -> Int {
        let defaults = UserDefaults.standard
        
        return defaults.integer(forKey: "lastsleeptime")
    }
    
    func secsToMinutes(secs: Int) -> String {
        return String(format: "%02d:%02d", secs/60, secs%60)
    }


}
