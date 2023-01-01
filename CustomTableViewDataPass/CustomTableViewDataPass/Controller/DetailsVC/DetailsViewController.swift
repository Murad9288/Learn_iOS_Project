//
//  DetailsViewController.swift
//  CustomTableViewDataPass
//
//  Created by Md Murad Hossain on 20/10/22.
//

import UIKit

class DetailsViewController: UIViewController {

    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var lbl: UILabel!
    
    var im = UIImage()
    var lb = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        img.image = im
        lbl.text = lb

    }
    
    
    
}
