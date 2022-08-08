//
//  ViewController.swift
//  slider_excersise
//
//  Created by Md Murad Hossain on 3/8/22.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var switch_control: UISwitch!
    
    
    @IBOutlet weak var slide_control: UISlider!
    
    
    @IBOutlet weak var Label_1: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func slide_value(_ sender: UISlider) {
        if switch_control.isOn{
            Label_1.text = "Brigthness "+Int(round(sender.value)).description+"%"
        }else{
            Label_1.text = "Switch is off. Please turn on switch and use to slider!"
        }
        
        
        
        
        
    }
    
}

