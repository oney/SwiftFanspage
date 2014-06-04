//
//  FanspageCell.swift
//  SwiftFanspage
//
//  Created by Oney on 2014/6/4.
//  Copyright (c) 2014 oney. All rights reserved.
//

import UIKit

class FanspageCell: UITableViewCell {

    @IBOutlet var name :UILabel
    @IBOutlet var category :UILabel
    @IBOutlet var photo :UIImageView
    
    init(style: UITableViewCellStyle, reuseIdentifier: String) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        // Initialization code
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
