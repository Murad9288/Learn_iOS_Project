//
//  ViewController.swift
//  First_app
//
//  Created by Md Murad Hossain on 5/7/22.
//

import UIKit

class ViewController: UIViewController {
    var n = 0
    var c = 1
    @IBOutlet weak var lbl : UILabel!
    @IBOutlet weak var lbl2: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
   @IBAction func buttonaction(_ sender: Any){
       n += 1
       lbl.text = "Button Clicked \(n) Times!"
       
    }
    @IBAction func press(_ sender: Any) {
        c += 2
        lbl2.text = "Pataints number \(c)."
    }
    
}

