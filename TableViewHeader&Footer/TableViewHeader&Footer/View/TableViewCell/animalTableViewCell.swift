//
//  animalTableViewCell.swift
//  TableViewHeader&Footer
//
//  Created by Md Murad Hossain on 19/10/22.
//

import UIKit

final class animalTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var imageLabel: UILabel!
    @IBOutlet private weak var nameLabel: UILabel!
    
    
    var animal: animal!{
        didSet{
            self.imageLabel.text = self.animal.image
            self.nameLabel.text = self.animal.name
        }
    }
    
}
