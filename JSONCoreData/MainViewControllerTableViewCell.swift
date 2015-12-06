//
//  MainViewControllerTableViewCell.swift
//  JSONCoreData
//
//  Created by UHS on 06/12/2015.
//  Copyright © 2015 Apkia. All rights reserved.
//

import UIKit

class MainViewControllerTableViewCell: UITableViewCell {

    @IBOutlet weak var lblFirstName: UILabel!
    @IBOutlet weak var lblSurName: UILabel!
    @IBOutlet weak var lblObjectID: UILabel!
    @IBOutlet weak var imgUserProfile: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
