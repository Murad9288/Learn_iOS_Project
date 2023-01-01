//
//  ProductDetailsViewController.swift
//  EcommerceProduct_API
//
//  Created by Md Murad Hossain on 3/12/22.
//

import UIKit

class ProductDetailsViewController: UIViewController {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var productLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var catagoryLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var buyButton: UIView!
    
    var pImage = ""
    var pTitle = ""
    var pDescription = ""
    var pCategory = ""
    var pPrice = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        buyButton.pulsate()
        
    }
    
    private func setupView(){
        
        imgView.layer.cornerRadius = 10
        buyButton.layer.cornerRadius = buyButton.frame.height / 2
        buyButton.clipsToBounds = false
        buyButton.layer.shadowColor = UIColor.black.cgColor
        buyButton.layer.shadowOpacity = 0.5
        buyButton.layer.shadowOffset = CGSize(width: 0.5, height: 2.0)
        
        imgView.sd_setImage(with: URL(string: pImage))
        //imgView.image = UIImage(named: pImage)
        productLabel.text = pTitle
        descriptionLabel.text = pDescription
        catagoryLabel.text = pCategory
        priceLabel.text = pPrice

        
        
    }
    
    @IBAction func buyButtonPress(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: Buy Button Animatation.

extension UIView {
  func pulsate() {
        let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.duration = 0.80
        pulse.fromValue = 0.90
        pulse.toValue = 1
        pulse.autoreverses = true
        pulse.repeatCount = 10000000000
        pulse.initialVelocity = 0.98
        pulse.damping = 10
        layer.add(pulse, forKey: "pulse")
    }
}


