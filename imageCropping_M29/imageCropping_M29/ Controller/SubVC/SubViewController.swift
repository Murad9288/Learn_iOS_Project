//
//  SubViewController.swift
//  imageCropping_M29
//
//  Created by Md Murad Hossain on 19/11/22.
//

import UIKit

class SubViewController: UIViewController {
    
    
    @IBOutlet weak var imageView: UIImageView!
    
    var imageArray = UIImage()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageArrayEdit()
        

    }
    
    func imageArrayEdit(){
        imageView.layer.borderWidth = 1
       // photo.layer.masksToBounds = false
       // photo.layer.borderColor = UIColor.black.cgColor
       // photo.layer.cornerRadius = photo.frame.height/2
       // photo.clipsToBounds = true
        imageView.image = imageArray
    }
    
//    MARK: Home Button
    
    @IBAction func homeButton(_ sender: UIButton) {
        
        dismiss(animated: true,completion: nil)
    }
    

}
