//
//  CustomTableViewCell.swift
//  Assignment
//
//  Created by Shamaila Afridi on 22/03/2018.
//  Copyright © 2018 Shamaila Afridi. All rights reserved.
//

import UIKit

//custom tableview class to display images inside table view and customise
class CustomTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet weak var imgRating: UIImageView!
    @IBOutlet weak var restNameLbl: UILabel!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
