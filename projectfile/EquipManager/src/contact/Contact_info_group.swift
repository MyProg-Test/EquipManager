//
//  Contact_info_group.swift
//  AddressBook
//
//  Created by 李呱呱 on 2016/10/21.
//  Copyright (c) 2015年 liguagua. All rights reserved.
//

import UIKit

class Contact_info_group {
    let group_dict:NSMutableDictionary = NSMutableDictionary()
    let key:NSMutableArray = NSMutableArray()
    
    init(contact:NSMutableArray){
        //分类 对数据源
        for c in contact{
            //有则匹配 fl为首字母
            let fl = (c as! Contact_info).getFirstLetter()
            if(!self.group_dict.allKeys.contains(where: {return ($0 as! String) == fl})){
                key.add(fl)
                self.group_dict.setValue(NSMutableArray(), forKey: fl)
            }
            (self.group_dict.value(forKey: fl) as! NSMutableArray).add(c)
        }
        //给key排序
        key.sort(comparator: { (k1, k2) -> ComparisonResult in
            if((k1 as! NSString).character(at: 0) > (k2 as! NSString).character(at: 0)){
                return ComparisonResult.orderedDescending
            }
            if((k1 as! NSString).character(at: 0) < (k2 as! NSString).character(at: 0)){
                return ComparisonResult.orderedAscending
            }
            return ComparisonResult.orderedSame
        })
    }
    
    func getGroupNumber()->Int{
        return self.key.count
    }
    //getNumInSection
    func getNumInGroup(index:Int)->Int{
        let key:String = self.key.object(at: index) as! String
        return (self.group_dict.value(forKey: key) as! NSMutableArray).count
    }
    //getSection
    func getGroupSection(index:Int)->NSArray{
        let key:String = self.key.object(at: index) as! String
        return self.group_dict.value(forKey: key) as! NSArray
    }
    
    func getGroupName(index: Int) -> String {
        return self.key.object(at: index) as! String
    }
   
}
