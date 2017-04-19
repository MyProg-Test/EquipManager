//
//  NewEquipTableViewCell.swift
//  EquipManager
//
//  Created by 李呱呱 on 2016/10/28.
//  Copyright © 2016年 liguagua. All rights reserved.
//

import UIKit

class NewEquipTableViewCell: UITableViewCell {

    @IBOutlet weak var labelKey:UILabel!
    @IBOutlet weak var textValue:UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
