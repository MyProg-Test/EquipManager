//
//  EquipListTableViewCell.swift
//  Crabfans_2016
//
//  Created by 李呱呱 on 16/8/5.
//  Copyright © 2016年 liguagua. All rights reserved.
//

import UIKit

class EquipListTableViewCell: UITableViewCell {

    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var equipName: UILabel!
    @IBOutlet weak var equipNumber: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateEquipList(){
        thumbnail.image  = nil
        equipName.text   = nil
        equipNumber.text = nil
        
    }
    
    func setEquipName(){
        //to do
    }

    func getEquipName()->String?{
        //to do
        return "test"
    }
    
    func setEquipNumber(){
        //to do
    }
    
    func getEquipNumber()->String?{
        //to do
        return "test"
    }
    
    func setThumbnail(){
        //to do
    }
    
    func getThumbnail()->UIImage?{
        //to do 
        return nil
    }
    
    
}

