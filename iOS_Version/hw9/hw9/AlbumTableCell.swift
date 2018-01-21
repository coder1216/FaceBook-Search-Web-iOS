//
//  AlbumTableCell.swift
//  hw9
//
//  Created by Alex Hong on 4/25/17.
//  Copyright © 2017 Alex Hong. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import SwiftSpinner
import FBSDKCoreKit
import FBSDKShareKit
import FBSDKMessengerShareKit

class AlbumTableCell: UITableViewCell {

    
    @IBOutlet weak var albumNameCell: UILabel!
    
    @IBOutlet weak var albumPicCell1: UIImageView!
    
    @IBOutlet weak var albumPicCell2: UIImageView!
    
    var isObserving = false
    
    class var expandedHeight: CGFloat { get { return 400 } }
    class var defaultHeight: CGFloat  { get { return 44  } }
    
    func checkHeight() {
        albumPicCell1.isHidden = (frame.size.height < AlbumTableCell.expandedHeight)
        albumPicCell2.isHidden = (frame.size.height < AlbumTableCell.expandedHeight)
    }
    
    func watchFrameChanges() {
        if (!isObserving) {
            addObserver(self, forKeyPath: "frame", options: .new, context: nil)
            isObserving = true;
        }
    }
    
    func ignoreFrameChanges() {
        if (isObserving) {
            removeObserver(self, forKeyPath: "frame")
            isObserving = false;
        }
    }
    
    deinit {
        print("delete!!!!!!!!")
        do {
            if (isObserving) {
                removeObserver(self, forKeyPath: "frame")
                isObserving = false;
            }
            //removeObserver(self, forKeyPath: "frame", context: nil)
        }
    }
    
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "frame" {
            checkHeight()
            
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
