//
//  EquipImageInfo.swift
//  EquipManager
//
//  Created by 李呱呱 on 16/7/24.
//  Copyright © 2016年 liguagua. All rights reserved.
//

import UIKit


class EquipImageInfo {
    var equipkey        : String
    var historyImage    : NSMutableArray{
        get{
            return EquipFileControl.sharedInstance().getFileSystemFromFile()!.getEquipImageSet(self.equipkey);
        }
    }
    var imageIndex      : Int               = -1;//选中的图片的index
    
   
    init(key: String){
        self.equipkey = key;
        // to do
    }
    
  
    func getDisplayedImageInfo() -> NSMutableDictionary?{//get the image that displays in the main screen
        if(imageIndex < 0){
            return nil;
        }
        return historyImage.object(at: self.imageIndex) as? NSMutableDictionary
    }
    
   
    func setDisplayedImageInfo() -> Bool {
        let index   : Int   = getMainIndexofImage();
        if (index == -1) {
            return false;
        }
        imageIndex  = index;
        return true;
    }
    

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
 
    class func isMainImage(_ Name:String,parentId:Int)->Bool{
        return Name.hasPrefix("\(parentId)_");
    }
    
    
}
