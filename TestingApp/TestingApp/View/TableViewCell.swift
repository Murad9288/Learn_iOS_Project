//
//  TableViewCell.swift
//  TestingApp
//
//  Created by Md Hosne Mobarok on 5/7/22.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var nameLable: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
