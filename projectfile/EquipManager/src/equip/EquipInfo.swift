//
//  EquipInfo.swift
//  EquipManager
//
//  Created by LY on 16/7/24.
//  Copyright © 2016年 LY. All rights reserved.
//

import UIKit
/**
 parentId当且仅当equip文件夹被删除才会变化
 xmlid当且仅当xml被删除(被修改)变化
 imageid当且仅当图片被删除变化
 一个Equip的xml文件必须在浏览之前下载(第一次的初始化)
 一个Equip的图片文件只要下载当前要显示的图片的(缩略图)
 当用户需要浏览历史图片时，当前设备的所有图片为已下载状态
 当设备图片处于已下载状态，之后每次浏览设备图片执行同步操作
**/

//设备信息
class EquipInfo {
    var equipkey:String;
    //xml就绪
    var xmlReady:Bool{
        get{
            return FileManager.default.fileExists(atPath: EquipFileControl.sharedInstance().getEquipFilePathFromFile(self.equipkey)!.path);
        }
    };
    var imageInfo:EquipImageInfo
    var xmlInfo:EquipXmlInfo
    //根据index从equipFileControl里初始化
    init(key:String){
        self.equipkey = key;
        self.xmlInfo = EquipXmlInfo(key: self.equipkey);
        
        self.imageInfo = EquipImageInfo(key: self.equipkey);
        _ = self.imageInfo.setDisplayedImageInfo();
    }
    //根据index从equipFileControl里更新
    func updateEquip(_ key:String){
        self.equipkey = key;
        self.xmlInfo = EquipXmlInfo(key: self.equipkey);
        
        self.imageInfo = EquipImageInfo(key: self.equipkey);
        _ = self.imageInfo.setDisplayedImageInfo();
    }
    
    //修改设备xml的信息
    func modifyEquipXmlInfo(_ equipmentKey:EquipmentKey, equipmentAttrKey:EquipmentAttrKey, value:String){
        self.xmlInfo.modifyXml(equipmentKey, equipmentAttrKey: equipmentAttrKey, value: value)
    }
    
    //设置当前要显示的图片
    func setDisplayedImage() -> Bool {
        return self.imageInfo.setDisplayedImageInfo();
    }
    

}
