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
    var equipkey        : String
    var historyImage    : NSMutableArray{
        get{
            return EquipFileControl.sharedInstance().getFileSystemFromFile()!.getEquipImageSet(self.equipkey);
        }
    }
    var imageIndex      : Int               = -1;//选中的图片的index
    
    //根据历史图片数组初始化
    init(key: String){
        self.equipkey = key;
        // to do
    }
    
    //获取要显示的图片的文件信息
    func getDisplayedImageInfo() -> NSMutableDictionary?{//get the image that displays in the main screen
        if(imageIndex < 0){
            return nil;
        }
        return historyImage.object(at: self.imageIndex) as? NSMutableDictionary
    }
    
    //设置要显示的图片的index
    func setDisplayedImageInfo() -> Bool {
        let index   : Int   = getMainIndexofImage();
        if (index == -1) {
            return false;
        }
        imageIndex  = index;
        return true;
    }
    
    //根据名字获取图片的index
    func getMainIndexofImage() -> Int {
        var index = 0;
        for imageFileInfo in historyImage{
            if(!(imageFileInfo is NSMutableDictionary)){
                return -1
            }
            let imageName = (imageFileInfo as! NSMutableDictionary).object(forKey: FileSystem.imageSetKey.imageName) as! String;
            let parentID = EquipFileControl.sharedInstance().getEquipParentIdFromFile(equipkey);
            if(EquipImageInfo.isMainImage(imageName, parentId: parentID)){
                return index;
            }
            index += 1;
        }
        return -1;
    }
    
    //根据index获取图片的文件内容
    func getImage(_ index:Int) -> UIImage {
        let data = EquipFileControl.sharedInstance().getImageData(self.equipkey, imageIndex: index);
        if(data as Data == Data()){
            return UIImage(named: "equipImage.png")!
        }
        return UIImage(data: data)!;
    }
    
    func getMainImage() -> UIImage {
        let data = EquipFileControl.sharedInstance().getImageData(self.equipkey, imageIndex: self.imageIndex);
        if(data as Data == Data()){
            return UIImage(named: "equipImage.png")!
        }
        return UIImage(data: data)!;
    }
    //判断当前名称是否符合主图片
    class func isMainImage(_ Name:String,parentId:Int)->Bool{
        return Name.hasPrefix("\(parentId)_");
    }
    
    
}
