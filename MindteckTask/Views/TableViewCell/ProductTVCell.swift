//
//  ProductTVCell.swift
//  MindteckTask
//
//  Created by Anil Pahadiya on 04/02/23.
//

import UIKit

class ProductTVCell: UITableViewCell {

    @IBOutlet weak var lbl_Title: UILabel!
    @IBOutlet weak var viewBg: UIView!
    @IBOutlet weak var imgData: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
