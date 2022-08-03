//
//  ViewController.swift
//  Slider_part
//
//  Created by Md Murad Hossain on 3/8/22.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var slider_control: UISlider!
    
    @IBOutlet weak var Label_1: UILabel!
    
    @IBOutlet weak var switch_control: UISwitch!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //slider_control.minimumValue = 0
        //slider_control.maximumValue = 100
    
    }


    @IBAction func slider_value(_ sender: UISlider) {
        
        // Float number to Integer number convert 1st system:
        //Label_1.text = "Music Sound = "+Int(sender.value).description+"%"
        //  Float number to Integer number convert 2nd system:
        if switch_control.isOn{
            Label_1.text = "Music Sound = \(lroundf(sender.value))%"
        }else{
            Label_1.text = "Switch is off. Please turn on switch to use slider!"
        }
        
    }
}

