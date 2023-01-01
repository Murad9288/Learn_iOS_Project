//
//  FriendTableViewCell.swift
//  CustomTableViewDataPass
//
//  Created by Md Murad Hossain on 20/10/22.
//

import UIKit

class FriendTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblName: UILabel!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func configure(img: UIImage?,name1: String){
        imgView.image = img
        lblName.text = name1
    }
    
}
