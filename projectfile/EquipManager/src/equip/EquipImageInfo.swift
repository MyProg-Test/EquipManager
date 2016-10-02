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
    
    //根据历史图片数组初始化
    init(historyImage:NSMutableArray){
        self.historyImage = historyImage.mutableCopy() as! NSMutableArray
        // to do
    }
    
    //获取要显示的图片的文件信息
    func getDisplayedImageInfo() -> FileInfo?{//get the image that displays in the main screen
        if(imageIndex < 0){
            return nil;
        }
        return historyImage.object(at: self.imageIndex) as? FileInfo
    }
    
    //设置要显示的图片的index
    func setDisplayedImageInfo(_ name:String) -> Bool {
        let index   : Int   = getIndexofImageFromName(name);
        if (index == -1) {
            return false;
        }
        imageIndex  = index;
        return true;
    }
    
    //根据名字获取图片的index
    func getIndexofImageFromName(_ name:String) -> Int {
        var index = 0;
        for imageFileInfo in historyImage{
            if(!(imageFileInfo is FileInfo)){
                return -1
            }
            if((imageFileInfo as! FileInfo).name.isEqual(name as String)){
                return index;
            }
            index += 1;
        }
        return -1;
    }
    
    //根据index获取图片的文件内容
    func getImage(_ index:Int) -> UIImage {
        let imageFileInfo   : FileInfo = historyImage.object(at: index) as! FileInfo;
        let data = imageFileInfo.getFileData();
        if(data as Data == Data()){
            return UIImage(named: "equipImage.png")!
        }
        return UIImage(data: imageFileInfo.getFileData() as Data)!;
    }
    //判断当前名称是否符合主图片
    class func isMainImage(_ Name:String,parentId:Int)->Bool{
        return Name.hasPrefix("\(parentId)_");
    }
    
    
}
