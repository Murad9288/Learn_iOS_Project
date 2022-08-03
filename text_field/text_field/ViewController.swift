//
//  ViewController.swift
//  text_field
//
//  Created by Md Murad Hossain on 1/8/22.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var label_1: UILabel!
    
    @IBOutlet weak var textUser: UITextField!
    
    @IBOutlet weak var textPass: UITextField!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
    }


    @IBAction func loginbutton(_ sender: UIButton) {
        let un = textUser.text
        let p = textPass.text
        if (un == "Murad" && p == "1234") {
            label_1.text = "Sign successful!"
        }else{
            label_1.text = "Sign failed!"
        }
    }
    
}

