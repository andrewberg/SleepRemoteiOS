//
//  SettingsTableViewController.swift
//  Sleep Remote
//
//  Created by Andrew on 5/1/17.
//  Copyright © 2017 BergCode. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    @IBOutlet weak var minuteLabel: UILabel!
    @IBOutlet weak var vibrateSwitch: UISwitch!
    @IBOutlet weak var sleepSwitch: UISwitch!
    @IBOutlet weak var listenSwitch: UISwitch!
    
    var numMinutes = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // sets up the offset for the time bar
        let height = UIApplication.shared.statusBarFrame.size.height
        let insets = UIEdgeInsets(top: height, left: 0, bottom: 0, right: 0)
        self.tableView.contentInset = insets
        self.tableView.scrollIndicatorInsets = insets
        
        // grabs the init stored values
        getSettings()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getSettings()
        
        print("view appeared")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 2) {
            return 1
        }
        
        return 3
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        print(indexPath)
        
        if (indexPath.row == 0 && indexPath.section == 0) {
            // time picker
            // make the picker wheel show up
            
            print("sleep time selected")
            
            let vc = (
                storyboard?.instantiateViewController(
                    withIdentifier: "picker")
                )!
            vc.modalTransitionStyle = .crossDissolve
            present(vc, animated: true, completion: getSettings)

        } else if (indexPath.row == 1 && indexPath.section == 1) {
            // make connect screen show
            
            let vc = (
                storyboard?.instantiateViewController(
                    withIdentifier: "connect")
                )!
            vc.modalTransitionStyle = .crossDissolve
            present(vc, animated: true, completion: getSettings)
            
        } else if (indexPath.row == 2 && indexPath.section == 1) {
            // make the test signal to TV screen show
            
            let vc = (
                storyboard?.instantiateViewController(
                    withIdentifier: "testsignal")
                )!
            vc.modalTransitionStyle = .crossDissolve
            present(vc, animated: true, completion: getSettings)
            
        } else if (indexPath.row == 0 && indexPath.section == 2) {
            // open calibration menu
            
            let vc = (
                storyboard?.instantiateViewController(
                    withIdentifier: "calibrate")
                )!
            vc.modalTransitionStyle = .crossDissolve
            present(vc, animated: true, completion: getSettings)
            
        }
    }
    
    @IBAction func checkConnect(_ sender: Any) {
        // checks whether or not the application can access the sleep remote module
        let vc = (
            storyboard?.instantiateViewController(
                withIdentifier: "connect")
            )!
        vc.modalTransitionStyle = .crossDissolve
        present(vc, animated: true, completion: getSettings)
        
    }
    @IBAction func changeSleep(_ sender: Any) {
        // call when the sleep display switch is enabled or displayed
        
        setSettings()
    }
    
    @IBAction func changeVibrate(_ sender: Any) {
        // calls when the sleep display switch is enabled or disabled
        
        setSettings()
    }

    @IBAction func changeListen(_ sender: Any) {
        // calls when the listen switch is enabled or disabled
        
        setSettings()
    }

    @IBAction func sendPowerSignalTest(_ sender: Any) {
        // opens screen to test the power signal to the TV
        
        let vc = (
            storyboard?.instantiateViewController(
                withIdentifier: "testsignal")
            )!
        vc.modalTransitionStyle = .crossDissolve
        present(vc, animated: true, completion: getSettings)

    }

    @IBAction func openCalibration(_ sender: Any) {
        let vc = (
            storyboard?.instantiateViewController(
                withIdentifier: "calibrate")
            )!
        vc.modalTransitionStyle = .crossDissolve
        present(vc, animated: true, completion: getSettings)
    }
    
    func getSettings() {
        let defaults = UserDefaults.standard
        
        let s = defaults.bool(forKey: "sleep")
        let v = defaults.bool(forKey: "vibrate")
        let m = defaults.integer(forKey: "minutes")
        let l = defaults.bool(forKey: "listen")
        
        sleepSwitch.isOn = s
        listenSwitch.isOn = l
        vibrateSwitch.isOn = v
        minuteLabel.text = "\(m) Minutes"
        
        numMinutes = m
    }
    
    func setSettings() {
        let defaults = UserDefaults.standard
        
        let s = sleepSwitch.isOn
        let v = vibrateSwitch.isOn
        let l = listenSwitch.isOn
        let m = numMinutes
        
        defaults.set(s, forKey: "sleep")
        defaults.set(v, forKey: "vibrate")
        defaults.set(m, forKey: "minutes")
        defaults.set(l, forKey: "listen")
        
    }


}
