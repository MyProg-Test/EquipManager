//
//  FileInfo.swift
//  EquipManager
//
//  Created by LY on 16/9/12.
//  Copyright © 2016年 LY. All rights reserved.
//

import UIKit



//描述一个文件的基本信息
class ItemInfo{
    var name:       String;
    var id:         Int;
    var parentId:   Int;
    var parentPath: String;
    var path:       String{
        get{
            let ext = (name as NSString).pathExtension;
            return "\(parentPath)/\(id).\(ext)";
        }
    };
    var data:       NSData{
        get{
            if let tmpData = NSData(contentsOfFile: self.path) {
                return tmpData;
            }
            return NSData()
        }
    }
    
    init(name: String, id: Int, parentId: Int, parentPath: String){
        self.name = name;
        self.id = id;
        self.parentId = parentId;
        self.parentPath = parentPath;
    }
}
