//
//  DetailEquipTableViewCell.swift
//  Crabfans_2016
//
//  Created by 李呱呱 on 16/8/8.
//  Copyright © 2016年 liguagua. All rights reserved.
//

import UIKit

class DetailEquipTableViewCell: UITableViewCell {

    @IBOutlet weak var attrKey: UILabel!
    @IBOutlet weak var attrValue: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func updateDetailAttrCell(){
        attrKey.text = nil
        attrValue.text = nil
        getAttrKey()
        getAttrValue()
    }
    func setAttrKey(){
        //to do
    }
    func getAttrKey()->String?{
        //to do 
        return "test"
    }
    func setAttrValue(){
        //to do
    }
    func getAttrValue()->String?{
        //to do 
        return "test"
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
