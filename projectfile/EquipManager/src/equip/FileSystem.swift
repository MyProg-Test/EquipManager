//
//  FileSystem.swift
//  TestModule
//
//  Created by 李呱呱 on 16/8/28.
//  Copyright © 2016年 liguagua. All rights reserved.
//

import UIKit



class FileSystem {
    enum Status:Int {
        case Mask       = 0b1111;
        case Download   = 0b1000;
        case Delete     = 0b0100;
        case New        = 0b0010;
        case Modifty    = 0b0001;
    }
    
    internal struct equipKey{
        static let parentID     = "1";
        static let XMLID        = "2";
        static let XMLName      = "3";
        static let imageSet     = "4";
        static let path         = "5";
        static let groupID      = "6";
        static let status       = "7";  //abcd
        //a 0,1 download
        //b 0,1 delete
        //c 0,1 new
        //d 0,1 modify
    }
    
    internal struct imageSetKey{
        static let imageID      = "1";
        static let imagePath    = "2";
        static let imageName    = "3";
        static let status       = "4";  //abcd
        //a 0,1 download
        //b 0,1 delete
        //c 0,1 new
        //d 0,1 modify
    }
    
    var equipArray:NSMutableArray;
    var count:Int{
        get{
            return self.equipArray.count;
        }
    }
    
    func getImageCount(index:Int)->Int{
        let imageSet = self.getEquip(index)!.objectForKey(equipKey.imageSet);
        return imageSet!.count;
    }
    
    init(){
        self.equipArray = NSMutableArray();
    }
    
    init(equip:NSMutableArray){
        self.equipArray = equip.mutableCopy() as! NSMutableArray;
    }
    
    func addEquip(equip:NSMutableDictionary){
        objc_sync_enter(self);
        let newEquip = equip.mutableCopy() as! NSMutableDictionary;
        equipArray.addObject(newEquip);
        objc_sync_exit(self);
    }
    
    func addEquip(parentID:Int = -1, XMLID:Int = -1, XMLName:NSString = "", imageSet:NSMutableArray, path:NSString, groupID: Int, status:Int = 0){
        let newEquip:NSMutableDictionary = NSMutableDictionary();
        newEquip.setValue(parentID, forKey: equipKey.parentID);
        newEquip.setValue(XMLID, forKey: equipKey.XMLID);
        newEquip.setValue(XMLName, forKey: equipKey.XMLName);
        newEquip.setValue(imageSet, forKey: equipKey.imageSet);
        newEquip.setValue(path, forKey: equipKey.path);
        newEquip.setValue(groupID, forKey: equipKey.groupID);
        newEquip.setValue(status, forKey: equipKey.status);
        self.addEquip(newEquip);
    }
    
    func addImage(index:Int, image:NSMutableDictionary){
        objc_sync_enter(self);
        let newImage = image.mutableCopy() as! NSMutableDictionary;
        equipArray.objectAtIndex(index).addObject(newImage);
        objc_sync_exit(self);
    }
    
    func addImage(index:Int, imageID:Int, imagePath:NSString, imageName:NSString, status:Int = 0){
        let newImage:NSMutableDictionary = NSMutableDictionary();
        newImage.setValue(imageID, forKey: imageSetKey.imageID);
        newImage.setValue(imagePath, forKey: imageSetKey.imagePath);
        newImage.setValue(imageName, forKey: imageSetKey.imageName);
        newImage.setValue(status, forKey: imageSetKey.status);
        self.addImage(index, image: newImage);
    }
    
    func addImageArray(index:Int, imageArray:NSMutableArray){
        objc_sync_enter(self);
        if(index >= 0){
            let newImageArray = imageArray.mutableCopy() as! NSMutableArray;
            equipArray.objectAtIndex(index).objectForKey(equipKey.imageSet)!.addObjectsFromArray(newImageArray as [AnyObject]);
        }
        objc_sync_exit(self);
    }
    
    func modifyImageName(equipIndex:Int, imageIndex:Int, name:NSString){
        objc_sync_enter(self);
        self.equipArray.objectAtIndex(equipIndex).objectForKey(equipKey.imageSet)?.objectAtIndex(imageIndex).setValue(name, forKey: imageSetKey.imageName);
        objc_sync_exit(self);
    }
    
    func modifyEquipStatus(index:Int,status:Int){
        objc_sync_enter(self);
        self.equipArray.objectAtIndex(index).setValue(status, forKey: equipKey.status);
        objc_sync_exit(self);
    }
    
    func modifyImageStatus(equipIndex:Int, imageIndex:Int, status:Int){
        objc_sync_enter(self);
        self.equipArray.objectAtIndex(equipIndex).objectForKey(equipKey.imageSet)!.setValue(status, forKey: imageSetKey.status);
        objc_sync_exit(self);
    }
    
    func getEquip(index:Int)->NSMutableDictionary?{
        if(index >= self.count || index < 0){
            return nil;
        }
        let equip = equipArray.objectAtIndex(index) as! NSMutableDictionary;
        return equip.mutableCopy() as? NSMutableDictionary;
    }
    
    func getImage(equipIndex:Int, imageIndex:Int)->NSMutableDictionary?{
        if(equipIndex >= self.count || equipIndex < 0){
            return nil;
        }
        let imageSet:NSMutableArray = getEquipImageSet(equipIndex);
        if(imageIndex >= imageSet.count || imageIndex < 0){
            return nil;
        }
        return imageSet.objectAtIndex(imageIndex) as? NSMutableDictionary;
    }
    
    func getSpecIndex(key:NSString,value:AnyObject)->Int{
        for i in 0..<self.count{
            if(self.getEquip(i)!.valueForKey(key as String)!.isEqual(value)){
                return i;
            }
        }
        return -1;
    }
    
    func getEquipPath(index:Int)->NSURL{
        return NSURL(fileURLWithPath: (self.getEquip(index)!.objectForKey(equipKey.path) as! String)).URLByAppendingPathComponent("\(self.getEquipXMLID(index)).xml");
    }
    
    func getEquipXMLID(index:Int)->Int{
        return getEquip(index)!.objectForKey(equipKey.XMLID) as! Int;
    }
    
    func getEquipParentID(index:Int) -> Int {
        return getEquip(index)!.objectForKey(equipKey.parentID) as! Int;
    }
    
    func getEquipName(index:Int) -> NSString {
        return getEquip(index)!.objectForKey(equipKey.XMLName) as! NSString;
    }
    
    func getEquipImageSet(index:Int) -> NSMutableArray {
        return getEquip(index)!.objectForKey(equipKey.imageSet) as! NSMutableArray;
    }
    
    func getEquipGroupID(index:Int) -> Int {
        return getEquip(index)!.objectForKey(equipKey.groupID) as! Int;
    }
    
    func getEquipStatus(index:Int) -> Int {
        return getEquip(index)!.objectForKey(equipKey.status) as! Int;
    }
    
    func getImagePath(equipIndex:Int, imageIndex:Int) -> NSURL {
        let fileName = self.getImage(equipIndex, imageIndex: imageIndex)!.objectForKey(imageSetKey.imageName) as! NSString;
        let fileExt = fileName.pathExtension;
        return NSURL(fileURLWithPath: (self.getImage(equipIndex, imageIndex: imageIndex)!.objectForKey(imageSetKey.imagePath) as! String)).URLByAppendingPathComponent("\(self.getImage(equipIndex, imageIndex: imageIndex)!.objectForKey(imageSetKey.imageID) as! Int).\(fileExt)");
    }
    
    func getImageID(equipIndex:Int, imageIndex:Int) -> Int {
        return getImage(equipIndex, imageIndex: imageIndex)!.objectForKey(imageSetKey.imageID) as! Int;
    }
    
    func getImageName(equipIndex:Int, imageIndex:Int) -> NSString {
        return getImage(equipIndex, imageIndex: imageIndex)!.objectForKey(imageSetKey.imageName) as! NSString;
    }
    
    func getImageStatus(equipIndex:Int, imageIndex:Int) -> Int {
        return getImage(equipIndex, imageIndex: imageIndex)!.objectForKey(imageSetKey.status) as! Int;
    }
    
    func isMainImage(equipIndex:Int, imageIndex:Int) -> Bool{
        let name = getImageName(equipIndex, imageIndex: imageIndex);
        let parentID = getEquipParentID(equipIndex);
        return EquipImageInfo.isMainImage(name, parentId: parentID);
    }
    
    func readFromFile(url:NSURL)->Bool{
        let equipArray:NSMutableArray? = NSMutableArray(contentsOfURL: url);
        if(equipArray == nil){
            return false;
        }
        self.equipArray = equipArray!.mutableCopy() as! NSMutableArray;
        return true;
    }
    
    func writeToFile(url:NSURL)->Bool{
        return self.equipArray.writeToURL(url, atomically: true);
    }
    
    
    
}
