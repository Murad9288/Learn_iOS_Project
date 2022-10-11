//
//  TableViewCell.swift
//  TodoList
//
//  Created by Md Murad Hossain on 11/10/22.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var imageVeiw: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
