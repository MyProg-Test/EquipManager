//
//  Equip.swift
//  EquipManager
//
//  Created by LY on 16/7/24.
//  Copyright © 2016年 LY. All rights reserved.
//

import UIKit

class EquipNetInfo {
    
    private static let _sharedInstance = EquipNetInfo();
    let fs:FileSystem = FileSystem();
    let readFromNetRecord = NSMutableArray();
    
    //返回当前文件数
    var count:Int{
        get{
            return fs.count;
        }
    }
    //返回当前网络读取是否结束
    var isReadFromNetComplete:Bool{
        get{
            objc_sync_enter(NetworkOperation.sharedInstance().getResourcesQueue);
            if(NetworkOperation.sharedInstance().getResourcesComplete){
                objc_sync_exit(NetworkOperation.sharedInstance().getResourcesQueue);
                return true;
            }
            let array = NSMutableArray();
            for queue in readFromNetRecord {
                if(NetworkOperation.sharedInstance().getResourcesQueue.containsObject(queue)){
                    objc_sync_exit(NetworkOperation.sharedInstance().getResourcesQueue);
                    objc_sync_enter(readFromNetRecord);
                    readFromNetRecord.removeObjectsInArray(array as [AnyObject]);
                    objc_sync_exit(readFromNetRecord);
                    return false;
                }else{
                    array.addObject(queue);
                }
            }
            readFromNetRecord.removeAllObjects();
            objc_sync_exit(NetworkOperation.sharedInstance().getResourcesQueue);
            return true;
        }
    }
    
    
    private init(){
        
    }
    //单例模式
    class func sharedInstance()->EquipNetInfo{
        return _sharedInstance;
    }
    //检查ID是否存在
    func checkForID(id:Int, handler:(Bool)->Void){
        NetworkOperation.sharedInstance().getResourceInfo(id) { (any) in
            handler(any.objectForKey(NetworkOperation.NetConstant.DictKey.GetResourceInfo.Response.displayName) != nil);
        }
    }
    //从网络端添加设备
    func addEquipFromNet(parentID:Int, parentName:NSString) -> NSString{
        let stamp = NetworkOperation.sharedInstance().getResources(parentID) { (any) in
            if let resArray = any.objectForKey(NetworkOperation.NetConstant.DictKey.GetResources.Response.resources){
                let tmpArray = resArray as! NSMutableArray;
                let imageSet:NSMutableArray = NSMutableArray();
                for i in 0..<tmpArray.count{
                    let fileName = tmpArray.objectAtIndex(i).objectForKey(NetworkOperation.NetConstant.DictKey.GetResources.Response.ResourcesKey.displayName) as! NSString;
                    if(self.isImage(fileName)){
                        let imageID:Int = tmpArray.objectAtIndex(i).objectForKey(NetworkOperation.NetConstant.DictKey.GetResources.Response.ResourcesKey.id) as! Int;
                        let imageName:NSString = fileName;
                        let image:NSMutableDictionary = NSMutableDictionary();
                        image.setValue(imageID, forKey: FileSystem.imageSetKey.imageID);
                        image.setValue(imageName, forKey: FileSystem.imageSetKey.imageName);
                        image.setValue("\(parentName)/" as NSString, forKey: FileSystem.imageSetKey.imagePath);
                        image.setValue(0, forKey: FileSystem.imageSetKey.status);
                        imageSet.addObject(image);
                    }
                    if(self.isXml(fileName)){
                        let XMLID:Int = tmpArray.objectAtIndex(i).objectForKey(NetworkOperation.NetConstant.DictKey.GetResources.Response.ResourcesKey.id) as! Int;
                        let groupID:Int = tmpArray.objectAtIndex(i).objectForKey(NetworkOperation.NetConstant.DictKey.GetResources.Response.ResourcesKey.groupId) as! Int;
                        self.fs.addEquip(parentID, XMLID: XMLID, XMLName: fileName, imageSet: NSMutableArray(), path: "\(parentName)/" as NSString, groupID: groupID);
                        
                    }
                }
                objc_sync_enter(self.fs);
                let index = self.fs.getSpecIndex(FileSystem.equipKey.parentID, value: parentID);
                self.fs.addImageArray(index, imageArray: imageSet);
                objc_sync_exit(self.fs);
                //debug-------------------------------
                if(index != -1){
                    //print(self.fs.writeToFile(EquipFileControl.sharedInstance().getEquipInfoFilePath()));
                    print(index)
                    print(self.fs.getEquipPath(index).path!);
                    for i in 0..<self.fs.getEquip(index)!.valueForKey(FileSystem.equipKey.imageSet)!.count{
                        if(EquipImageInfo.isMainImage(self.fs.getImageName(index, imageIndex: i), parentId: parentID)){
                            print("\(self.fs.getImagePath(index, imageIndex: i).path!)----")
                        }else{
                            print(self.fs.getImagePath(index, imageIndex: i).path!);
                        }
                    }
                }
                //debug-----------------------------------
                
                
            }
        }
        return stamp;
        
    }
    //从网络端读取
    func readFromNet(rootID:Int){
        NetworkOperation.sharedInstance().getResources(rootID) { (any) in
            objc_sync_enter(self.fs.equipArray);
            self.fs.equipArray.removeAllObjects();
            objc_sync_exit(self.fs.equipArray);
            if let folderResArray = any.objectForKey(NetworkOperation.NetConstant.DictKey.GetResources.Response.resources){
                for i in 0..<folderResArray.count{
                    let folderRes:NSDictionary = folderResArray.objectAtIndex(i) as! NSDictionary;
                    let id = folderRes.objectForKey(NetworkOperation.NetConstant.DictKey.GetResources.Response.ResourcesKey.id) as! Int;
                    let parentName = folderRes.objectForKey(NetworkOperation.NetConstant.DictKey.GetResources.Response.ResourcesKey.displayName) as! NSString
                    objc_sync_enter(self.readFromNetRecord)
                    self.readFromNetRecord.addObject(self.addEquipFromNet(id, parentName: parentName));
                    objc_sync_exit(self.readFromNetRecord);
                }
            }
        }
    }
    //判断当前是否为图片
    func isImage(Name:NSString)->Bool{
        let ext = Name.pathExtension.lowercaseString
        let imageType = ["jpg","png"];
        for i in 0..<imageType.count{
            if(ext.hasSuffix(imageType[i])){
                return true;
            }
        }
        return false;
    }
    //判断是否为xml
    func isXml(Name:NSString)->Bool{
        let ext = Name.pathExtension.lowercaseString
        let imageType = ["xml"];
        for i in 0..<imageType.count{
            if(ext.hasSuffix(imageType[i])){
                return true;
            }
        }
        return false;
    }    
}