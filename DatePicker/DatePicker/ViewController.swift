//
//  ViewController.swift
//  DatePicker
//
//  Created by Md Murad Hossain on 1/8/22.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var text_field: UITextField!
    
    @IBOutlet weak var datapicker: UIDatePicker!
    let data = DateFormatter()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    
        data.dateFormat = "dd/MM/yyyy"
        text_field.inputView = datapicker
        datapicker.datePickerMode = .date
        text_field.text = data.string(from: datapicker.date)
    
    
    }
    

    @IBAction func datachanged(_ sender: UIDatePicker) {
        text_field.text = data.string(from: sender.date)
        view.endEditing(true)
    }
    
}

