//
//  ViewController.swift
//  button_2
//
//  Created by Md Murad Hossain on 31/7/22.
//

import UIKit

class ViewController: UIViewController {
    var count = 0

    @IBOutlet weak var label_1: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func pressbutton(_ sender: UIButton) {
        if sender.tag == 0{
            count += 1
        }else{
            count -= 1
        }
        label_1.text = "Serial number = \(count)"
    }
    
    
}

