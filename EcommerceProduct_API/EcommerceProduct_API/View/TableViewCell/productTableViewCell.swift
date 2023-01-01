//
//  productTableViewCell.swift
//  EcommerceProduct_API
//
//  Created by Md Murad Hossain on 3/12/22.
//

import UIKit
import SDWebImage

class productTableViewCell: UITableViewCell {
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var catagoryLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
    func configure(allProduct: ProductModel) {
        
//        productImageView.layer.cornerRadius = 10
//        guard let string = allProduct.image else { return }
//        let url = URL(string: string)
//        productImageView.
        
     
        if let imagePath = allProduct.image {
            productImageView.sd_setImage(with: URL(string: imagePath), placeholderImage:UIImage(named: "placeholder-image"))
        }
        else {
            productImageView.image =  UIImage(named: "placeholder-image")
        }
        
        titleLabel.text = String(allProduct.id!)
        idLabel.text = allProduct.title
        priceLabel.text = allProduct.category?.rawValue
        catagoryLabel.text = "$" + String(allProduct.price!)
    }
    
    
}
