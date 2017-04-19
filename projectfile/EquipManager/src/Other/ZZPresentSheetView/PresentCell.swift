//
//  SecondCell.swift
//  TransitionDemo
//
//  Created by duzhe on 16/3/15.
//  Copyright © 2016年 dz. All rights reserved.
//

import UIKit

private let sw:CGFloat = UIScreen.main.bounds.width
private let sh:CGFloat = UIScreen.main.bounds.height
class PresentCell: UITableViewCell {
    
    fileprivate var nameLabel:UILabel!
    
    var name:String = ""{
        didSet{
            self.nameLabel.text = name
        }
    }
    
    var isCancel:Bool = false{
        didSet{
            if isCancel{
                nameLabel.textColor = UIColor(red: 0xDD/255, green: 47/255, blue: 47/255, alpha: 1)
            }else{
                nameLabel.textColor = UIColor.darkGray
            }
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        // Initialization code
        self.contentView.backgroundColor = UIColor.clear
        self.backgroundColor = UIColor.clear
        nameLabel = UILabel()
        nameLabel.textAlignment = .center
        self.contentView.addSubview(nameLabel)
        nameLabel.textColor = UIColor.black
        nameLabel.font = UIFont.systemFont(ofSize: 16)
        self.separatorInset = UIEdgeInsets(top: 0, left: 2 , bottom: 0, right: 1)
        self.preservesSuperviewLayoutMargins = false
        self.layoutMargins = UIEdgeInsets.zero
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addConstraint(NSLayoutConstraint(item: nameLabel, attribute: .centerX, relatedBy: .equal, toItem: self.contentView, attribute: .centerX, multiplier: 1, constant: 0))
        self.contentView.addConstraint(NSLayoutConstraint(item: nameLabel, attribute: .centerY, relatedBy: .equal, toItem: self.contentView, attribute: .centerY, multiplier: 1, constant: 0))
        
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}

