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
        case mask       = 0b1111;
        case download   = 0b1000;
        case delete     = 0b0100;
        case new        = 0b0010;
        case modifty    = 0b0001;
    }
    //设备key
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
    //图片组key
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
    //返回当前设备数量
    var count:Int{
        get{
            return self.equipArray.count;
        }
    }
    //获取图片数量
    func getImageCount(_ index:Int)->Int{
        let imageSet = self.getEquip(index)!.object(forKey: equipKey.imageSet);
        return (imageSet! as AnyObject).count;
    }
    
    init(){
        self.equipArray = NSMutableArray();
    }
    
    init(equip:NSMutableArray){
        self.equipArray = equip.mutableCopy() as! NSMutableArray;
    }
    //添加设备
    func addEquip(_ equip:NSMutableDictionary){
        objc_sync_enter(self);
        let newEquip = equip.mutableCopy() as! NSMutableDictionary;
        equipArray.add(newEquip);
        objc_sync_exit(self);
    }
    //添加设备
    func addEquip(_ parentID:Int = -1, XMLID:Int = -1, XMLName:String = "", imageSet:NSMutableArray, path:String, groupID: Int, status:Int = 0){
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
    //添加图片
    func addImage(_ index:Int, image:NSMutableDictionary){
        objc_sync_enter(self);
        let newImage = image.mutableCopy() as! NSMutableDictionary;
        ((equipArray.object(at: index) as AnyObject).object(forKey: equipKey.imageSet)! as AnyObject).add(newImage);
        objc_sync_exit(self);
    }
    //添加图片
    func addImage(_ index:Int, imageID:Int, imagePath:String, imageName:String, status:Int = 0){
        let newImage:NSMutableDictionary = NSMutableDictionary();
        newImage.setValue(imageID, forKey: imageSetKey.imageID);
        newImage.setValue(imagePath, forKey: imageSetKey.imagePath);
        newImage.setValue(imageName, forKey: imageSetKey.imageName);
        newImage.setValue(status, forKey: imageSetKey.status);
        self.addImage(index, image: newImage);
    }
    //添加图片数组
    func addImageArray(_ index:Int, imageArray:NSMutableArray){
        objc_sync_enter(self);
        if(index >= 0){
            let newImageArray = imageArray.mutableCopy() as! NSMutableArray;
            ((equipArray.object(at: index) as AnyObject).object(forKey: equipKey.imageSet)! as AnyObject).addObjects(from: newImageArray as [AnyObject]);
        }
        objc_sync_exit(self);
    }
    
    func deleteImage(_ equipIndex: Int, image: NSMutableDictionary) -> Bool {
        objc_sync_enter(self);
        ((equipArray.object(at: equipIndex) as AnyObject).object(forKey: FileSystem.equipKey.imageSet) as! NSMutableArray).remove(image);
        objc_sync_exit(self);
        return true;
    }
    
    func deleteEquip(_ equip: AnyObject) -> Bool {
        objc_sync_enter(self);
        equipArray.remove(equip);
        objc_sync_exit(self);
        return true;
    }
    
    func modifyParentID(_ index: Int, parentId: Int) {
        objc_sync_enter(self);
        (self.equipArray.object(at: index) as AnyObject).setValue(parentId, forKey: equipKey.parentID);
        objc_sync_exit(self);
    }
    
    func modifyXMLID(_ index: Int, id: Int) {
        objc_sync_enter(self);
        (self.equipArray.object(at: index) as AnyObject).setValue(id, forKey: equipKey.XMLID);
        objc_sync_exit(self);
    }
    //修改图片名
    func modifyImageName(_ equipIndex:Int, imageIndex:Int, name:String){
        objc_sync_enter(self);
        (((self.equipArray.object(at: equipIndex) as AnyObject).object(forKey: equipKey.imageSet) as AnyObject).object(at: imageIndex) as AnyObject).setValue(name, forKey: imageSetKey.imageName);
        objc_sync_exit(self);
    }
    //修改设备状态
    func modifyEquipStatus(_ index:Int,status:Int){
        objc_sync_enter(self);
        (self.equipArray.object(at: index) as AnyObject).setValue(status, forKey: equipKey.status);
        objc_sync_exit(self);
    }
    
    func modifyImageID(_ equipIndex: Int, imageIndex: Int, id: Int) {
        objc_sync_enter(self);
        ((self.equipArray.object(at: equipIndex) as AnyObject).object(forKey: equipKey.imageSet)! as AnyObject).setValue(id, forKey: imageSetKey.imageID);
        objc_sync_exit(self);
    }
    
    //修改图片状态
    func modifyImageStatus(_ equipIndex:Int, imageIndex:Int, status:Int){
        objc_sync_enter(self);
        ((self.equipArray.object(at: equipIndex) as AnyObject).object(forKey: equipKey.imageSet)! as AnyObject).setValue(status, forKey: imageSetKey.status);
        objc_sync_exit(self);
    }
    //获取设备
    func getEquip(_ index:Int)->NSMutableDictionary?{
        if(index >= self.count || index < 0){
            return nil;
        }
        let equip = equipArray.object(at: index) as! NSMutableDictionary;
        return equip.mutableCopy() as? NSMutableDictionary;
    }
    //获取图片
    func getImage(_ equipIndex:Int, imageIndex:Int)->NSMutableDictionary?{
        if(equipIndex >= self.count || equipIndex < 0){
            return nil;
        }
        let imageSet:NSMutableArray = getEquipImageSet(equipIndex);
        if(imageIndex >= imageSet.count || imageIndex < 0){
            return nil;
        }
        return imageSet.object(at: imageIndex) as? NSMutableDictionary;
    }
    //根据key和value获取index
    func getSpecIndex(_ key:String,value:AnyObject)->Int{
        for i in 0..<self.count{
            if((self.getEquip(i)!.value(forKey: key as String)! as AnyObject).isEqual(value)){
                return i;
            }
        }
        return -1;
    }
    //获取设备路径
    func getEquipPath(_ index:Int)->URL{
        return URL(fileURLWithPath: (self.getEquip(index)!.object(forKey: equipKey.path) as! String)).appendingPathComponent("\(self.getEquipXMLID(index)).xml");
    }
    //获取设备xmlID
    func getEquipXMLID(_ index:Int)->Int{
        return getEquip(index)!.object(forKey: equipKey.XMLID) as! Int;
    }
    //获取设备PID
    func getEquipParentID(_ index:Int) -> Int {
        return getEquip(index)!.object(forKey: equipKey.parentID) as! Int;
    }
    //获取设备名称
    func getEquipName(_ index:Int) -> String {
        return getEquip(index)!.object(forKey: equipKey.XMLName) as! String;
    }
    //获取设备的ImageSet
    func getEquipImageSet(_ index:Int) -> NSMutableArray {
        return getEquip(index)!.object(forKey: equipKey.imageSet) as! NSMutableArray;
    }
    //获取设备的groupID
    func getEquipGroupID(_ index:Int) -> Int {
        return getEquip(index)!.object(forKey: equipKey.groupID) as! Int;
    }
    //获取设备状态
    func getEquipStatus(_ index:Int) -> Int {
        return getEquip(index)!.object(forKey: equipKey.status) as! Int;
    }
    //获取图片路径
    func getImagePath(_ equipIndex:Int, imageIndex:Int) -> URL {
        let fileName = self.getImage(equipIndex, imageIndex: imageIndex)!.object(forKey: imageSetKey.imageName) as! String;
        let fileExt = (fileName as NSString).pathExtension;
        return URL(fileURLWithPath: (self.getImage(equipIndex, imageIndex: imageIndex)!.object(forKey: imageSetKey.imagePath) as! String)).appendingPathComponent("\(self.getImage(equipIndex, imageIndex: imageIndex)!.object(forKey: imageSetKey.imageID) as! Int).\(fileExt)");
    }
    //获取图片ID
    func getImageID(_ equipIndex:Int, imageIndex:Int) -> Int {
        return getImage(equipIndex, imageIndex: imageIndex)!.object(forKey: imageSetKey.imageID) as! Int;
    }
    //获取图片名称
    func getImageName(_ equipIndex:Int, imageIndex:Int) -> String {
        return getImage(equipIndex, imageIndex: imageIndex)!.object(forKey: imageSetKey.imageName) as! String;
    }
    //获取图片状态
    func getImageStatus(_ equipIndex:Int, imageIndex:Int) -> Int {
        return getImage(equipIndex, imageIndex: imageIndex)!.object(forKey: imageSetKey.status) as! Int;
    }
    //判断是否主图片
    func isMainImage(_ equipIndex:Int, imageIndex:Int) -> Bool{
        let name = getImageName(equipIndex, imageIndex: imageIndex);
        let parentID = getEquipParentID(equipIndex);
        return EquipImageInfo.isMainImage(name, parentId: parentID);
    }
    //从文件中读取
    func readFromFile(_ url:URL)->Bool{
        let equipArray:NSMutableArray? = NSMutableArray(contentsOf: url);
        if(equipArray == nil){
            return false;
        }
        self.equipArray = equipArray!.mutableCopy() as! NSMutableArray;
        return true;
    }
    //写入文件
    func writeToFile(_ url:URL)->Bool{
        return self.equipArray.write(toFile: url.path, atomically: true);
    }
    
    
    
}
