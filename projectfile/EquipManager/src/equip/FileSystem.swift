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
    
    internal struct equipKey{
        static let parentID: String     = "1";
        static let XMLID: String        = "2";
        static let XMLName: String      = "3";
        static let imageSet: String     = "4";
        static let path: String         = "5";
        static let groupID: String      = "6";
        static let status: String       = "7";  //abcd
        //a 0,1 download
        //b 0,1 delete
        //c 0,1 new
        //d 0,1 modify
    }
    
    internal struct imageSetKey{
        static let imageID: String      = "1";
        static let imagePath: String    = "2";
        static let imageName: String    = "3";
        static let status: String       = "4";  //abcd
        //a 0,1 download
        //b 0,1 delete
        //c 0,1 new
        //d 0,1 modify
    }
    
    let equipDict: MySafeMutableMethod<NSMutableDictionary>;
    let attrKey:MySafeMutableMethod<NSMutableArray>;
    
    var count:Int{
        get{
            attrKey.readRequest();
            let count = attrKey.subject.count;
            attrKey.readEnd();
            return count;
        }
    }
    
    init(){
        self.attrKey = MySafeMutableMethod(subject: NSMutableArray());
        self.equipDict = MySafeMutableMethod(subject: NSMutableDictionary());
    }
    
    init(equip:NSMutableDictionary){
        self.equipDict = MySafeMutableMethod(subject: equip.mutableCopy() as! NSMutableDictionary);
        self.attrKey = MySafeMutableMethod(subject: NSMutableArray(array: self.equipDict.subject.allKeys));
    }
    //添加设备
    func addEquip(_ equip:NSMutableDictionary){
        equipDict.writeRequest();
        equipDict.subject.setValue(equip.mutableCopy(), forKey: "\(equip.value(forKey: equipKey.parentID)!)");
        equipDict.writeEnd();
        attrKey.writeRequest();
        attrKey.subject.add("\(equip.value(forKey: equipKey.parentID)!)")
        attrKey.writeEnd()
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
    func addImage(_ key:String, image:NSMutableDictionary){
        equipDict.readRequest()
        if(equipDict.subject.allKeys.contains(where: {return key.isEqual($0)})){
            equipDict.readEnd()
            let newImage = image.mutableCopy() as! NSMutableDictionary;
            equipDict.writeRequest()
            ((equipDict.subject.object(forKey: key) as! NSMutableDictionary).object(forKey: equipKey.imageSet) as! NSMutableArray).add(newImage)
            equipDict.writeEnd()
        }else{
            equipDict.readEnd();
        }
        
    }
    //添加图片
    func addImage(_ key:String, imageID:Int, imagePath:String, imageName:String, status:Int = 0){
        let newImage:NSMutableDictionary = NSMutableDictionary();
        newImage.setValue(imageID, forKey: imageSetKey.imageID);
        newImage.setValue(imagePath, forKey: imageSetKey.imagePath);
        newImage.setValue(imageName, forKey: imageSetKey.imageName);
        newImage.setValue(status, forKey: imageSetKey.status);
        self.addImage(key, image: newImage);
    }
    
    func addImageArray(_ key:String, imageArray:NSMutableArray){
        equipDict.readRequest()
        if(equipDict.subject.allKeys.contains(where: {return key.isEqual($0)})){
            equipDict.readEnd()
            equipDict.writeRequest()
            let newImageArray = imageArray.mutableCopy() as! NSMutableArray;
            ((equipDict.subject.object(forKey: key) as! NSMutableDictionary).object(forKey: equipKey.imageSet) as! NSMutableArray).addObjects(from: newImageArray as [AnyObject])
            equipDict.writeEnd();
        }else{
            equipDict.readEnd();
        }
    }
    
    func deleteImage(_ equipkey: String, image: NSMutableDictionary) -> Bool {
        equipDict.readRequest()
        if(equipDict.subject.allKeys.contains(where: {return equipkey.isEqual($0)})){
            equipDict.readEnd()
            equipDict.writeRequest();
            ((equipDict.subject.object(forKey: equipkey) as! NSMutableDictionary).object(forKey: equipKey.imageSet) as! NSMutableArray).remove(image)
            equipDict.writeEnd()
            return true;
        }else{
            equipDict.readEnd();
            return false;
        }
        
    }
    
    func deleteEquip(_ key: String) -> Bool {
        equipDict.writeRequest()
        equipDict.subject.removeObject(forKey: key)
        equipDict.writeEnd()
        attrKey.writeRequest()
        attrKey.subject.remove(key)
        attrKey.writeEnd();
        return true;
    }
    
    func modifyParentID(_ key: String, parentId: Int) {
        equipDict.readRequest()
        if(equipDict.subject.allKeys.contains(where: {return key.isEqual($0)})){
            equipDict.readEnd()
            equipDict.writeRequest()
            let newEquip = (equipDict.subject.object(forKey: key) as! NSMutableDictionary).mutableCopy() as! NSMutableDictionary;
            newEquip.setValue(parentId, forKey: equipKey.parentID);
            equipDict.subject.removeObject(forKey: key)
            equipDict.subject.setValue(newEquip, forKey: "\(parentId)")
            equipDict.writeEnd();
            attrKey.writeRequest();
            let index = attrKey.subject.index(of: key);
            attrKey.subject.replaceObject(at: index, with: "\(parentId)");
            attrKey.writeEnd();
        }else{
            equipDict.readEnd();
        }
    }
    
    func modifyXMLID(_ key: String, id: Int) {
        equipDict.readRequest()
        if(equipDict.subject.allKeys.contains(where: {return key.isEqual($0)})){
            equipDict.readEnd()
            equipDict.writeRequest();
            (equipDict.subject.object(forKey: key) as! NSMutableDictionary).setValue(id, forKey: equipKey.XMLID);
            equipDict.writeEnd();
        }else{
            equipDict.readEnd();
        }
    }
    
 
    func modifyEquipStatus(_ key:String,status:Int){
        equipDict.readRequest()
        if(equipDict.subject.allKeys.contains(where: {return key.isEqual($0)})){
            equipDict.readEnd()
            equipDict.writeRequest();
            (equipDict.subject.object(forKey: key) as! NSMutableDictionary).setValue(status, forKey: equipKey.status);
            equipDict.writeEnd();
        }else{
            equipDict.readEnd();
        }
    }
    
  
    func modifyImageName(_ equipkey: String, imageIndex: Int, name:String){
        equipDict.readRequest()
        if(equipDict.subject.allKeys.contains(where: {return equipkey.isEqual($0)})){
            equipDict.readEnd()
            equipDict.writeRequest();
            (((equipDict.subject.object(forKey: equipkey) as! NSMutableDictionary).object(forKey: equipKey.imageSet) as! NSMutableArray).object(at: imageIndex) as! NSMutableDictionary).setValue(name, forKey: imageSetKey.imageName);
            equipDict.writeEnd();
        }else{
            equipDict.readEnd()
        }
    }
    
    func modifyImageID(_ equipkey: String, imageIndex: Int, id: Int) {
        equipDict.readRequest()
        if(equipDict.subject.allKeys.contains(where: {return equipkey.isEqual($0)})){
            equipDict.readEnd()
            equipDict.writeRequest();
            (((equipDict.subject.object(forKey: equipkey) as! NSMutableDictionary).object(forKey: equipKey.imageSet) as! NSMutableArray).object(at: imageIndex) as! NSMutableDictionary).setValue(id, forKey: imageSetKey.imageID);
            equipDict.writeEnd();
        }else{
            equipDict.readEnd();
        }
    }
    
   
    func modifyImageStatus(_ equipkey:String, imageIndex:Int, status:Int){
        equipDict.readRequest()
        if(equipDict.subject.allKeys.contains(where: {return equipkey.isEqual($0)})){
            equipDict.readEnd()
            equipDict.writeRequest();
            (((equipDict.subject.object(forKey: equipkey) as! NSMutableDictionary).object(forKey: equipKey.imageSet) as! NSMutableArray).object(at: imageIndex) as! NSMutableDictionary).setValue(status, forKey: imageSetKey.status);
            equipDict.writeEnd();
        }else{
            equipDict.readEnd();
        }
    }
   
    func getEquip(_ key:String)->NSMutableDictionary?{
        equipDict.readRequest()
        if(equipDict.subject.allKeys.contains(where: {return key.isEqual($0)})){
            let equip = equipDict.subject.object(forKey: key) as! NSMutableDictionary;
            equipDict.readEnd()
            return equip.mutableCopy() as? NSMutableDictionary;
        }else{
            equipDict.readEnd();
            return nil;
        }
    }
    
    func getImage(_ equipkey:String, imageIndex:Int)->NSMutableDictionary?{
        equipDict.readRequest()
        if(equipDict.subject.allKeys.contains(where: {return equipkey.isEqual($0)})){
            equipDict.readEnd();
        let imageSet:NSMutableArray = getEquipImageSet(equipkey);
        if(imageIndex >= imageSet.count || imageIndex < 0){
            return nil;
        }
        return imageSet.object(at: imageIndex) as? NSMutableDictionary;
        }else{
            equipDict.readEnd();
            return nil;
        }
    }
    
    func getSpecKey(_ key:String,value:AnyObject)->String{
        equipDict.readRequest();
        for (keyTmp, valueTmp) in equipDict.subject{
            if(((valueTmp as! NSMutableDictionary).value(forKey: key as String)! as AnyObject).isEqual(value)){
                equipDict.readEnd();
                return keyTmp as! String;
            }
        }
        equipDict.readEnd();
        return "";
    }
 
    func getEquipPath(_ key:String)->URL{
        let url: URL = URL(fileURLWithPath: self.getEquip(key)!.object(forKey: equipKey.path) as! String).appendingPathComponent("\(self.getEquipXMLID(key)).xml");
        return url;
    }
  
    func getEquipXMLID(_ key:String)->Int{
        let xmlID = self.getEquip(key)!.object(forKey: equipKey.XMLID) as! Int;
        return xmlID;
    }
    
    func getEquipParentID(_ key:String) -> Int {
        let parentID = getEquip(key)!.object(forKey: equipKey.parentID) as! Int;
        return parentID;
    }
    
    func getEquipName(_ key:String) -> String {
        let equipName = getEquip(key)!.object(forKey: equipKey.XMLName) as! String;
        return equipName;
    }
    
    func getEquipImageSet(_ key:String) -> NSMutableArray {
        let imageSet = getEquip(key)!.object(forKey: equipKey.imageSet) as! NSMutableArray;
        return imageSet;
    }
    
    func getEquipGroupID(_ key:String) -> Int {
        //print(getEquip(key));
        //let groupID = getEquip(key)!.object(forKey: equipKey.groupID) as! Int;
        return EquipManager.sharedInstance().defaultGroupId;
    }
   
    func getEquipStatus(_ key:String) -> Int {
        let equipStatus = getEquip(key)!.object(forKey: equipKey.status) as! Int;
        return equipStatus;
    }
    
    func getImageCount(_ equipkey: String) -> Int {
        let count = self.getEquipImageSet(equipkey).count;
        return count;
    }
    
   
    func getImagePath(_ equipkey:String, imageIndex:Int) -> URL? {
        if(self.getImage(equipkey, imageIndex: imageIndex) == nil){
            return nil;
        }
        let fileName = self.getImage(equipkey, imageIndex: imageIndex)!.object(forKey: imageSetKey.imageName) as! String;
        let fileExt = (fileName as NSString).pathExtension;
        let url = URL(fileURLWithPath: (self.getImage(equipkey, imageIndex: imageIndex)!.object(forKey: imageSetKey.imagePath) as! String)).appendingPathComponent("\(self.getImage(equipkey, imageIndex: imageIndex)!.object(forKey: imageSetKey.imageID) as! Int).\(fileExt)");
        return url;
    }

    func getImageID(_ equipkey:String, imageIndex:Int) -> Int {
        let imageID = getImage(equipkey, imageIndex: imageIndex)!.object(forKey: imageSetKey.imageID) as! Int
        return imageID;
    }

    func getImageName(_ equipkey:String, imageIndex:Int) -> String {
        let imageName = getImage(equipkey, imageIndex: imageIndex)!.object(forKey: imageSetKey.imageName) as! String;
        return imageName;
    }

    func getImageStatus(_ equipkey:String, imageIndex:Int) -> Int {
        let imageStatus = getImage(equipkey, imageIndex: imageIndex)!.object(forKey: imageSetKey.status) as! Int;
        return imageStatus;
    }
   
    func isMainImage(_ equipkey:String, imageIndex:Int) -> Bool{
        let name = getImageName(equipkey, imageIndex: imageIndex);
        let parentID = getEquipParentID(equipkey);
        return EquipImageInfo.isMainImage(name, parentId: parentID);
    }
    func setMainImage(_ equipkey:String, imageIndex:Int) -> Bool {
        if isMainImage(equipkey, imageIndex: imageIndex){
            return true;
        }
        let name = getImageName(equipkey, imageIndex: imageIndex);
        let parentID = getEquipParentID(equipkey);
        modifyImageName(equipkey, imageIndex: imageIndex, name: "\(parentID)_\(name)");
        modifyImageStatus(equipkey, imageIndex: imageIndex, status: getImageStatus(equipkey, imageIndex: imageIndex) | FileSystem.Status.modifty.rawValue);
        return true;
    }
    
    func resetMainImage(_ equipkey:String, imageIndex:Int) -> Bool {
        if !isMainImage(equipkey, imageIndex: imageIndex){
            return true;
        }
        var name = getImageName(equipkey, imageIndex: imageIndex);
        let parentID = getEquipParentID(equipkey);
        name = name.replacingOccurrences(of: "\(parentID)_", with: "")
        modifyImageName(equipkey, imageIndex: imageIndex, name: name);
        modifyImageStatus(equipkey, imageIndex: imageIndex, status: getImageStatus(equipkey, imageIndex: imageIndex) | FileSystem.Status.modifty.rawValue);
        return true;
    }
   
    func readFromFile(_ dicturl:URL, orderurl: URL)->Bool{
        equipDict.writeRequest();
        self.equipDict.subject = NSMutableDictionary(contentsOf: dicturl)!;
        equipDict.writeEnd();
        attrKey.writeRequest();
        attrKey.subject = NSMutableArray(contentsOf: orderurl)!;
        attrKey.writeEnd();
        return true;
    }
  
    func writeToFile(_ dicturl:URL, orderurl: URL)->Bool{
        equipDict.readRequest();
        let dictWrite = self.equipDict.subject.write(toFile: dicturl.path, atomically: true);
        equipDict.readEnd();
        attrKey.readRequest();
        let orderWrite = self.attrKey.subject.write(toFile: orderurl.path, atomically: true);
        attrKey.readEnd();
        return dictWrite && orderWrite;
    }
    
    
    
}
