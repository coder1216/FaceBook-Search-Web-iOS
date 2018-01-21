//
//  ResultTableViewCell.swift
//  hw9
//
//  Created by Alex Hong on 4/24/17.
//  Copyright © 2017 Alex Hong. All rights reserved.
//

import UIKit

class ResultTableViewCell: UITableViewCell {

    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var userImag: UIImageView!
    

    @IBAction func star(_ sender: UIButton) {
        if sender.currentImage == #imageLiteral(resourceName: "empty"){
            sender.setImage(#imageLiteral(resourceName: "filled"), for: .normal)
        }else
        {
            sender.setImage(#imageLiteral(resourceName: "empty"), for: .normal)
        }
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
