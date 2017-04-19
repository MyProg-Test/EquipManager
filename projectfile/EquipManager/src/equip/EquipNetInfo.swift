//
//  Equip.swift
//  EquipManager
//
//  Created by 李呱呱 on 16/7/24.
//  Copyright © 2016年 liguagua. All rights reserved.
//

import UIKit

class EquipNetInfo {
    
    fileprivate static let _sharedInstance = EquipNetInfo();
    let fs:FileSystem = FileSystem();
    
    
    var count:Int{
        get{
            return fs.count;
        }
    }
    
    fileprivate init(){
        
    }

    class func sharedInstance()->EquipNetInfo{
        return _sharedInstance;
    }
  
    func checkForID(_ id:Int, handler:@escaping (Bool)->Void){
        _ = NetworkOperation.sharedInstance().getResourceInfo(id) { (any) in
            handler(any.object(forKey: NetworkOperation.NetConstant.DictKey.GetResourceInfo.Response.displayName) != nil);
        }
    }
    
    func addEquipFromNet(_ parentID:Int, parentName:String) -> GCDSemaphore{
        let rtn = NetworkOperation.sharedInstance().getResources(parentID) { (any) in
            if let resArray = any.object(forKey: NetworkOperation.NetConstant.DictKey.GetResources.Response.resources){
                let tmpArray = resArray as! NSArray;
                let imageSet:NSMutableArray = NSMutableArray();
                for i in 0..<tmpArray.count{
                    let fileName = (tmpArray.object(at: i) as AnyObject).object(forKey: NetworkOperation.NetConstant.DictKey.GetResources.Response.ResourcesKey.displayName) as! String;
                    if(self.isImage(fileName)){
                        let imageID:Int = (tmpArray.object(at: i) as AnyObject).object(forKey: NetworkOperation.NetConstant.DictKey.GetResources.Response.ResourcesKey.id) as! Int;
                        let imageName:String = fileName;
                        let image:NSMutableDictionary = NSMutableDictionary();
                        image.setValue(imageID, forKey: FileSystem.imageSetKey.imageID);
                        image.setValue(imageName, forKey: FileSystem.imageSetKey.imageName);
                        image.setValue(parentName, forKey: FileSystem.imageSetKey.imagePath);
                        image.setValue(0, forKey: FileSystem.imageSetKey.status);
                        imageSet.add(image);
                    }
                    if(self.isXml(fileName)){
                        let XMLID:Int = (tmpArray.object(at: i) as AnyObject).object(forKey: NetworkOperation.NetConstant.DictKey.GetResources.Response.ResourcesKey.id) as! Int;
                        let groupID:Int = (tmpArray.object(at: i) as AnyObject).object(forKey: NetworkOperation.NetConstant.DictKey.GetResources.Response.ResourcesKey.groupId) as! Int;
                        self.fs.addEquip(parentID, XMLID: XMLID, XMLName: fileName, imageSet: NSMutableArray(), path: parentName, groupID: groupID);
                        
                    }
                }
                objc_sync_enter(self.fs);
                let index = self.fs.getSpecKey(FileSystem.equipKey.parentID, value: parentID as AnyObject);
                self.fs.addImageArray(index, imageArray: imageSet);
                objc_sync_exit(self.fs);
                //debug-------------------------------
                if(index != ""){
                    //print(self.fs.writeToFile(EquipFileControl.sharedInstance().getEquipInfoFilePath()));
                    print(index)
                    print(self.fs.getEquipPath(index).path);
                    for i in 0..<(self.fs.getEquip(index)!.value(forKey: FileSystem.equipKey.imageSet)! as AnyObject).count{
                        if(EquipImageInfo.isMainImage(self.fs.getImageName(index, imageIndex: i), parentId: parentID)){
                            print("\(self.fs.getImagePath(index, imageIndex: i)!.path)----")
                        }else{
                            print(self.fs.getImagePath(index, imageIndex: i)!.path);
                        }
                    }
                }
                //debug-----------------------------------
                
                
            }
        }
        return rtn;
        
    }
  
    func readFromNet(_ rootID:Int){
        var waitList = Array<GCDSemaphore>();
        fs.attrKey.writeRequest();
        fs.attrKey.subject.removeAllObjects();
        fs.attrKey.writeEnd();
        fs.equipDict.writeRequest();
        fs.equipDict.subject.removeAllObjects();
        fs.equipDict.writeEnd();
        let wait = NetworkOperation.sharedInstance().getResources(rootID) { (any) in
            if let folderResArray = any.object(forKey: NetworkOperation.NetConstant.DictKey.GetResources.Response.resources){
                for i in 0..<(folderResArray as AnyObject).count{
                    let folderRes:NSDictionary = (folderResArray as AnyObject).object(at: i) as! NSDictionary;
                    let id = folderRes.object(forKey: NetworkOperation.NetConstant.DictKey.GetResources.Response.ResourcesKey.id) as! Int;
                    let parentName = folderRes.object(forKey: NetworkOperation.NetConstant.DictKey.GetResources.Response.ResourcesKey.displayName) as! String
                    waitList.append(self.addEquipFromNet(id, parentName: parentName));
                }
            }
        }
        _ = wait.lock(message: "getFolder: \(Thread.current)");
        for i in waitList{
            _ = i.lock(message: "getEquip: \(i)");
        }
    }
    
   
    func isImage(_ Name:String)->Bool{
        let ext = (Name as NSString).pathExtension.lowercased()
        let imageType = ["jpg","png"];
        for i in 0..<imageType.count{
            if(ext.hasSuffix(imageType[i])){
                return true;
            }
        }
        return false;
    }
   
    func isXml(_ Name:String)->Bool{
        let ext = (Name as NSString).pathExtension.lowercased()
        let imageType = ["xml"];
        for i in 0..<imageType.count{
            if(ext.hasSuffix(imageType[i])){
                return true;
            }
        }
        return false;
    }
}
