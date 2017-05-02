//
//  ShowPickerViewController.swift
//  Sleep Remote
//
//  Created by Andrew on 5/1/17.
//  Copyright © 2017 BergCode. All rights reserved.
//

import UIKit

class ShowPickerViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet weak var text: UITextField!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var done: UIButton!
    
    var curMovie = "The Office"
    var pickerData: [String] = [String]()
    var pickerCurRow = "Trailer Park Boys"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.pickerView.delegate = self
        self.pickerView.dataSource = self

        // setup buttons
        addButton.backgroundColor = UIColor.blue
        addButton.layer.cornerRadius = 5
        addButton.layer.borderWidth = 1
        addButton.layer.borderColor = UIColor.black.cgColor
        
        done.backgroundColor = UIColor.blue
        done.layer.cornerRadius = 5
        done.layer.borderWidth = 1
        done.layer.borderColor = UIColor.black.cgColor
        
        //loadOldMovies()
        //loadCurMovie()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func saveCurMovie() {
        let defaults = UserDefaults.standard
        
        defaults.set(pickerCurRow, forKey: "curmovie")
    }
    
    func loadCurMovie() {
        let defaults = UserDefaults.standard
        
        curMovie = defaults.string(forKey: "curmovie")!
    }
    
    func saveNewMovie() {
        let defaults = UserDefaults.standard
        
        defaults.set(pickerData, forKey: "shows")
    }
    
    func loadOldMovies() {
        let defaults = UserDefaults.standard
        
        pickerData = defaults.array(forKey: "shows") as! [String]
    }

    @IBAction func add(_ sender: Any) {
        if (text.text != "") {
            pickerData.append(text.text!)
            saveNewMovie()
            text.text = ""
            //print(pickerData)
        }
        
        // reload pickertable
        self.pickerView.reloadAllComponents()
    }
    
    @IBAction func pick(_ sender: Any) {
        saveCurMovie()
        
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
        pickerCurRow = pickerData[row]
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
