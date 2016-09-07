//
//  EquipImageTableViewCell.swift
//  Crabfans_2016
//
//  Created by 李呱呱 on 16/8/9.
//  Copyright © 2016年 liguagua. All rights reserved.
//

import UIKit

class EquipImageTableViewCell: UITableViewCell {
    
    var isChoosen:Bool = false

    @IBOutlet weak var imageInCell: UIImageView!
    @IBOutlet weak var imageNameInCell: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    

}
