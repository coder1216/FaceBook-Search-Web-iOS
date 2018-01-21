//
//  DetailTableViewCell.swift
//  hw9
//
//  Created by Alex Hong on 4/25/17.
//  Copyright © 2017 Alex Hong. All rights reserved.
//

import UIKit

class DetailTableViewCell: UITableViewCell {


    @IBOutlet weak var postImg: UIImageView!
    
    @IBOutlet weak var postMessage: UILabel!
    
    @IBOutlet weak var postTime: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
