//
//  DemoTableViewCell.swift
//  CustomTableView
//
//  Created by Md Murad Hossain on 11/10/22.
//

import UIKit

class DemoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var myimageview: UIImageView!
    @IBOutlet weak var mylabel: UILabel!
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
