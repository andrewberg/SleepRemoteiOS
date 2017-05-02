//
//  TimePickerViewController.swift
//  Sleep Remote
//
//  Created by Andrew on 5/1/17.
//  Copyright © 2017 BergCode. All rights reserved.
//

import UIKit

class TimePickerViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet weak var picker: UIPickerView!
    
    var pickerData: [String] = [String]()
    var pickerCurRow = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.picker.delegate = self
        self.picker.dataSource = self
        
        for i in 1...60 {
            if (i == 1) {
                pickerData.append("\(i) minute")
            } else {
                pickerData.append("\(i) minutes")
            }
        }
    }
    
    func setTime() {
        let defaults = UserDefaults.standard
        
        defaults.set(pickerCurRow, forKey: "minutes")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func doneButtonAction(_ sender: Any) {
        //set the time for the current row of the picker wheel
        
        setTime()
        
        self.dismiss(animated: true, completion: nil)
    }
    
    // DataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    // Delegate
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerCurRow = row + 1
    }
}
