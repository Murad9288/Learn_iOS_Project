//
//  StudentTableViewCell.swift
//  Student_CoreData
//
//  Created by Md Murad Hossain on 13/12/22.
//

import UIKit

class StudentTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var mobileLabel: UILabel!

    var student: Student! {
        didSet {
            nameLabel.text = student.name
            addressLabel.text = student.address
            cityLabel.text = student.city
            mobileLabel.text = student.mobile
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
