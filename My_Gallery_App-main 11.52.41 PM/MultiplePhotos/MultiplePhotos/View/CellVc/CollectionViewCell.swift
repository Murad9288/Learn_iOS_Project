//
//  CollectionViewCell.swift
//  MultiplePhotos
//
//  Created by Md Murad Hossain on 18/10/22.
//

import UIKit


class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var deleteButtuon: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}

