//
//  CommentTableViewCell.swift
//  VegoResto
//
//  Created by Laurent Nicolas (141 - LILLE TOURCOING) on 05/01/2017.
//  Copyright © 2017 Nicolas Laurent. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {

    @IBOutlet weak var varIB_label_comment: UILabel?

    @IBOutlet var varIB_subtitle_label: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
