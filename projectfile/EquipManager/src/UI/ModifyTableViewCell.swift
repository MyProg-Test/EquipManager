//
//  ModifyTableViewCell.swift
//  EquipManager
//
//  Created by 李呱呱 on 2016/10/11.
//  Copyright © 2016年 liguagua. All rights reserved.
//

import UIKit

class ModifyTableViewCell: UITableViewCell {
    @IBOutlet weak var keyLabel:UILabel!
    
    @IBOutlet weak var valueText:UITextField!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        valueText.autocorrectionType = .no;
        valueText.clearsOnBeginEditing = true;
        valueText.clearButtonMode = .whileEditing;
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
