//
//  EquipImageInfo.swift
//  EquipManager
//
//  Created by LY on 16/7/24.
//  Copyright © 2016年 LY. All rights reserved.
//

import UIKit

//设备图片信息
class EquipImageInfo {
    var historyImage    : NSMutableArray    = NSMutableArray();//history images of one equip
    var imageIndex      : Int               = -1;//选中的图片的index
    
    
    init(historyImage:NSMutableArray){
        self.historyImage = historyImage.mutableCopy() as! NSMutableArray
        // to do
    }
    
    //获取要显示的图片的文件信息
    func getDisplayedImageInfo() -> FileInfo?{//get the image that displays in the main screen
        if(imageIndex < 0){
            return nil;
        }
        return historyImage.objectAtIndex(self.imageIndex) as? FileInfo
    }
    
    //设置要显示的图片的index
    func setDisplayedImageInfo(name:NSString) -> Bool {
        let index   : Int   = getIndexofImageFromName(name);
        if (index == -1) {
            return false;
        }
        imageIndex  = index;
        return true;
    }
    
    //根据名字获取图片的index
    func getIndexofImageFromName(name:NSString) -> Int {
        var index = 0;
        for imageFileInfo in historyImage{
            if(!imageFileInfo.isKindOfClass(FileInfo)){
                return -1
            }
            if((imageFileInfo as! FileInfo).name.isEqualToString(name as String)){
                return index;
            }
            index += 1;
        }
        return -1;
    }
    
    //根据index获取图片的文件内容
    func getImage(index:Int) -> UIImage {
        let imageFileInfo   : FileInfo = historyImage.objectAtIndex(index) as! FileInfo;
        let data = imageFileInfo.getFileData();
        if(data.isEqualToData(NSData())){
            return UIImage(named: "equipImage.png")!
        }
        return UIImage(data: imageFileInfo.getFileData())!;
    }
    
    class func isMainImage(Name:NSString,parentId:Int)->Bool{
        return Name.hasPrefix("\(parentId)_");
    }
    
    
}
