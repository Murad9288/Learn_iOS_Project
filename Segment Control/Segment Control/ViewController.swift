//
//  ViewController.swift
//  Segment Control
//
//  Created by Md Murad Hossain on 3/8/22.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var segment_control: UISegmentedControl!
    
    @IBOutlet var second_screen: UIView!
    


    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

    }
    @IBAction func segement_value(_ sender: Any) {
        switch segment_control.selectedSegmentIndex {
            case 0:
                segment_control.backgroundColor = .red
                    
            case 1:
                segment_control.backgroundColor = .blue
            default:
                break
            }
                
    }
    
    
}
