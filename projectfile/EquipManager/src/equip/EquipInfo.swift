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
    var equipIndex:Int;
    var xmlReady:Bool{
        get{
            return NSFileManager.defaultManager().fileExistsAtPath(xmlInfo.xmlFile.path.path!);
        }
    };
    var imageInfo:EquipImageInfo
    var xmlInfo:EquipXmlInfo
    
    //根据图片信息和xml信息初始化设备
    
    init(index:Int){
        equipIndex = index;
        let xmlFileInfo:FileInfo = FileInfo();
        xmlFileInfo.id = EquipFileControl.sharedInstance().getFileSystemFromFile()!.getEquipXMLID(equipIndex);
        xmlFileInfo.name = EquipFileControl.sharedInstance().getFileSystemFromFile()!.getEquipName(equipIndex);
        xmlFileInfo.parentId = EquipFileControl.sharedInstance().getFileSystemFromFile()!.getEquipParentID(equipIndex);
        xmlFileInfo.path = EquipFileControl.sharedInstance().getEquipFilePathFromFile(equipIndex)!;
        self.xmlInfo = EquipXmlInfo(xmlFile: xmlFileInfo);
        let imageFileArray:NSMutableArray = NSMutableArray();
        var fileName:NSString = "";
        for i in 0..<EquipFileControl.sharedInstance().getFileSystemFromFile()!.getImageCount(equipIndex){
            let imageFileInfo:FileInfo = FileInfo();
            imageFileInfo.id = EquipFileControl.sharedInstance().getFileSystemFromFile()!.getImageID(equipIndex, imageIndex: i);
            imageFileInfo.name = EquipFileControl.sharedInstance().getFileSystemFromFile()!.getImageName(equipIndex, imageIndex: i);
            imageFileInfo.parentId = xmlFileInfo.parentId;
            imageFileInfo.path = EquipFileControl.sharedInstance().getImageFilePathFromFile(equipIndex, imageIndex: i)!;
            imageFileArray.addObject(imageFileInfo);
            if(EquipFileControl.sharedInstance().getFileSystemFromFile()!.isMainImage(equipIndex, imageIndex: i)){
                fileName = imageFileInfo.name;
            }
        }
        self.imageInfo = EquipImageInfo(historyImage: imageFileArray);
        self.imageInfo.setDisplayedImageInfo(fileName);
    }
    
    func updateEquip(index:Int){
        equipIndex = index;
        let xmlFileInfo:FileInfo = FileInfo();
        xmlFileInfo.id = EquipFileControl.sharedInstance().getFileSystemFromFile()!.getEquipXMLID(equipIndex);
        xmlFileInfo.name = EquipFileControl.sharedInstance().getFileSystemFromFile()!.getEquipName(equipIndex);
        xmlFileInfo.parentId = EquipFileControl.sharedInstance().getFileSystemFromFile()!.getEquipParentID(equipIndex);
        xmlFileInfo.path = EquipFileControl.sharedInstance().getEquipFilePathFromFile(equipIndex)!;
        self.xmlInfo = EquipXmlInfo(xmlFile: xmlFileInfo);
        let imageFileArray:NSMutableArray = NSMutableArray();
        var fileName:NSString = "";
        for i in 0..<EquipFileControl.sharedInstance().getFileSystemFromFile()!.getImageCount(equipIndex){
            let imageFileInfo:FileInfo = FileInfo();
            imageFileInfo.id = EquipFileControl.sharedInstance().getFileSystemFromFile()!.getImageID(equipIndex, imageIndex: i);
            imageFileInfo.name = EquipFileControl.sharedInstance().getFileSystemFromFile()!.getImageName(equipIndex, imageIndex: i);
            imageFileInfo.parentId = xmlFileInfo.parentId;
            imageFileInfo.path = EquipFileControl.sharedInstance().getImageFilePathFromFile(equipIndex, imageIndex: i)!;
            imageFileArray.addObject(imageFileInfo);
            if(EquipFileControl.sharedInstance().getFileSystemFromFile()!.isMainImage(equipIndex, imageIndex: i)){
                fileName = imageFileInfo.name;
            }
        }
        self.imageInfo = EquipImageInfo(historyImage: imageFileArray);
        self.imageInfo.setDisplayedImageInfo(fileName);
    }
    
    //修改设备xml的信息
    func modifyEquipXmlInfo(equipmentKey:EquipmentKey, equipmentAttrKey:EquipmentAttrKey, value:NSString){
        self.xmlInfo.modifyXml(equipmentKey, equipmentAttrKey: equipmentAttrKey, value: value)
    }
    
    //设置当前要显示的图片
    func setDisplayedImage(name:NSString) -> Bool {
        return self.imageInfo.setDisplayedImageInfo(name);
    }
    

}