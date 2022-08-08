//
//  SecondViewController.swift
//  Table View
//
//  Created by Md Murad Hossain on 6/8/22.
//

import UIKit

class SecondViewController: UIViewController {

    @IBOutlet weak var TitelTaxt: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TitelTaxt.text = list_data[indicator]

    }
    
}
