//
//  ViewController.swift
//  Inshot
//
//  Created by Md Murad Hossain on 28/10/22.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var image1: UIImageView!
    @IBOutlet weak var image2: UIImageView!
    
    @IBOutlet weak var image3: UIImageView!
    @IBOutlet weak var image4: UIImageView!
    
    @IBOutlet weak var king: UIImageView!
    
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var settings: UIImageView!
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        image1.layer.cornerRadius = 35
        image2.layer.cornerRadius = 35
        image3.layer.cornerRadius = 45
        image4.layer.cornerRadius = 35
        king.layer.cornerRadius = 35
        settings.layer.cornerRadius = 50
        view1.layer.cornerRadius = 20
        view2.layer.cornerRadius = 20
    }


}

