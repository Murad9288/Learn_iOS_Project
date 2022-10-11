//
//  DataTableViewCell.swift
//  TableView
//
//  Created by Md Murad Hossain on 11/10/22.
//

import UIKit

class DataTableViewCell: UITableViewCell {
    
    @IBOutlet var imageview: UIImageView!
    
    @IBOutlet var imagelabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
