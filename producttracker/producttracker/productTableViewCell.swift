//
//  productTableViewCell.swift
//  producttracker
//
//  Created by njuios on 2020/11/9.
//

import UIKit

class productTableViewCell: UITableViewCell {
    @IBOutlet weak var namelabel: UILabel!
    @IBOutlet weak var photoimageview: UIImageView!
    @IBOutlet weak var ratingcontrol: RatingControl!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
