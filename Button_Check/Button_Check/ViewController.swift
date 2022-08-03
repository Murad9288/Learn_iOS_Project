//
//  ViewController.swift
//  Button_Check
//
//  Created by Md Murad Hossain on 30/7/22.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var labe_1: UILabel!
    var c = 0

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func pressButton(_ sender: UIButton) {
        if sender.tag == 0{
            c += 1
        }else{
            c -= 1
        }
        labe_1.text = "Serial number = \(c)."
    }
    
}

