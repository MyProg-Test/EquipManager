//
//  ServerTableViewCell.swift
//  EquipManager
//
//  Created by 李呱呱 on 2016/10/17.
//  Copyright © 2016年 liguagua. All rights reserved.
//

import UIKit

class ServerTableViewCell: UITableViewCell {

    @IBOutlet weak var serverName: UILabel!
    @IBOutlet weak var serverUrl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
