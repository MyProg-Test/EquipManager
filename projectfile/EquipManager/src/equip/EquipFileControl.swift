//
//  EquipFileControl.swift
//  EquipManager
//
//  Created by 李呱呱 on 16/7/31.
//  Copyright © 2016年 LY. All rights reserved.
//

import UIKit

//本地设备的文件控制
class EquipFileControl {
    private static let _sharedInstance = EquipFileControl();
    let equipInfoName = "EquipInfo.info";
    let fs:FileSystem = FileSystem();
    var count:Int{
        get{
            if(!self.readInfoFromFile()){
                return 0;
            }
            
            return fs.count;
        }
    }
    let rootPath:NSURL;
    let docPath:NSURL;
    let libPath:NSURL;
    let tmpPath:NSURL;
    
    //初始化路径
    private init(){
        docPath = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0];
        rootPath = docPath.URLByDeletingLastPathComponent!;
        libPath = rootPath.URLByAppendingPathComponent("Library")
        tmpPath = rootPath.URLByAppendingPathComponent("tmp");
        self.checkForEquipAssociationFile();
    }
    
    class func sharedInstance()->EquipFileControl{
        return _sharedInstance;
    }
    
    //获取当前帐号路径
    func getAccountPath()->NSURL{
        return docPath.URLByAppendingPathComponent("Account");
    }
    
    //获取当前帐号下的设备路径
    func getEquipPath()->NSURL{
        return getAccountPath().URLByAppendingPathComponent("我的设备");
    }
    
    //获取当前帐号下设备的相关信息路径
    func getEquipAssociationPath()->NSURL{
        return getEquipPath().URLByAppendingPathComponent("Equip");
    }
    
    //获取当前帐号下设备信息路径
    func getEquipInfoPath()->NSURL{
        return getEquipAssociationPath().URLByAppendingPathComponent("Infos");
    }
    
    //获取当前帐号下设备日志路径
    func getEquipLogsPath()->NSURL{
        return getEquipAssociationPath().URLByAppendingPathComponent("Logs");
    }
    
    //获取当前帐号下设备信息文件路径
    func getEquipInfoFilePath()->NSURL{
        return getEquipInfoPath().URLByAppendingPathComponent(equipInfoName, isDirectory: false);
    }
    
    //创建空设备文件
    func createEmptyEquipFile(url:NSURL)->Bool{
        let data:NSMutableArray = NSMutableArray();
        return data.writeToURL(url, atomically: true);
    }
    
    //read file
    func readInfoFromFile()->Bool{
        if(!NSFileManager.defaultManager().fileExistsAtPath(self.getEquipInfoFilePath().path!)){
            return false;
        }
        objc_sync_enter(self.fs);
        self.fs.readFromFile(self.getEquipInfoFilePath());
        objc_sync_exit(self.fs);
        return true;
    }
    
    //write file
    func writeInfoToFile()->Bool{
        if(!NSFileManager.defaultManager().fileExistsAtPath(self.getEquipInfoPath().path!)){
            do{
                try NSFileManager.defaultManager().createDirectoryAtPath(self.getEquipInfoPath().path!, withIntermediateDirectories: true, attributes: nil);
            }catch{
                print(error);
                return false;
            }
        }
        return self.fs.writeToFile(self.getEquipInfoFilePath());
    }
    
    //add equip into local file
    func addEquipInfoToFile(parentID:Int, XMLID:Int, XMLName:NSString, imageSet:NSMutableArray, path:NSString, groupID:Int,status:Int = 0)->Bool{
        if(!self.readInfoFromFile()){
            return false;
        }
        self.fs.addEquip(parentID, XMLID: XMLID, XMLName: XMLName, imageSet: imageSet, path: path,groupID: groupID, status: status);
        return self.writeInfoToFile();
    }
    
    func addImageInfoToFile(index:Int, imageID:Int, imagePath:NSString, imageName:NSString, status:Int = 0)->Bool{
        if(!self.readInfoFromFile()){
            return false;
        }
        if(index < self.fs.count && index >= 0){
            self.fs.addImage(index, imageID: imageID, imagePath: imagePath, imageName: imageName, status: status);
            return self.writeInfoToFile();
        }
        return false;
    }
    
    func modifyImageNameInFile(equipIndex:Int, imageIndex:Int, name:NSString)->Bool{
        if(!self.readInfoFromFile()){
            return false;
        }
        self.fs.modifyImageName(equipIndex, imageIndex: imageIndex, name: name);
        return self.writeInfoToFile();
    }
    
    func modifyEquipStatusInFile(index:Int,status:Int) -> Bool {
        if(!self.readInfoFromFile()){
            return false;
        }
        self.fs.modifyEquipStatus(index, status: status);
        return writeInfoToFile();
    }
    
    func modiftyImageStatusInFile(equipIndex:Int, imageIndex:Int, status:Int) -> Bool{
        if(!self.readInfoFromFile()){
            return false;
        }
        self.fs.modifyImageStatus(equipIndex, imageIndex: imageIndex, status: status);
        return writeInfoToFile();
    }
    
    func getEquipFromFile(index:Int)->NSMutableDictionary?{
        if(!self.readInfoFromFile()){
            return nil;
        }
        return self.fs.getEquip(index);
    }
    
    func getFileSystemFromFile()->FileSystem?{
        if(!self.readInfoFromFile()){
            return nil;
        }
        return self.fs;
    }
    
    func getEquipFilePathFromFile(index:Int) -> NSURL? {
        if(!self.readInfoFromFile()){
            return nil;
        }
        let url:NSURL = getEquipPath().URLByAppendingPathComponent(self.fs.getEquipPath(index).path!);
        return url;
    }
    
    func getImageFilePathFromFile(equipIndex:Int, imageIndex:Int) -> NSURL?{
        if(!self.readInfoFromFile()){
            return nil;
        }
        let url:NSURL = getEquipPath().URLByAppendingPathComponent(self.fs.getImagePath(equipIndex,imageIndex: imageIndex).path!);
        return url;
    }
    
    //get Equip dictionary with key and value
    func getSpecIndex(key:NSString,value:AnyObject)->Int{
        if(!self.readInfoFromFile()){
            return -1;
        }
        return self.fs.getSpecIndex(key, value: value);
    }
    
    //get EquipArray
    func getEquipArray()->NSMutableArray?{
        if(!self.readInfoFromFile()){
            return nil;
        }
        return self.fs.equipArray;
    }
    
    //检查设备相关路径是否存在，若不存在，则建立
    func checkForEquipAssociationFile()->Bool{
        do{
            if(!NSFileManager.defaultManager().fileExistsAtPath(getEquipInfoPath().path!)){
                try NSFileManager.defaultManager().createDirectoryAtPath(getEquipInfoPath().path!, withIntermediateDirectories: true, attributes: nil);
                createEmptyEquipFile(getEquipInfoFilePath());
            }
            if(!NSFileManager.defaultManager().fileExistsAtPath(getEquipLogsPath().path!)){
                try NSFileManager.defaultManager().createDirectoryAtPath(getEquipLogsPath().path!, withIntermediateDirectories: true, attributes: nil);
            }
            return true;
        }catch{
            print(error);
            return false;
        }
    }
    
    func interactEquipWithNet(){
        if(!self.readInfoFromFile()){
            return ;
        }
        for index in 0..<fs.count {
            let equipStatus:Int = fs.getEquipStatus(index);
            if(!(equipStatus & FileSystem.Status.Download.rawValue > 0)){
                NetworkOperation.sharedInstance().downloadResource(fs.getEquipXMLID(index), url: getEquipFilePathFromFile(index)!, handler: { (any) in
                    print(any);
                    if(NSFileManager.defaultManager().fileExistsAtPath(self.getEquipFilePathFromFile(index)!.path!)){
                        if(self.modifyEquipStatusInFile(index, status: FileSystem.Status.Download.rawValue|equipStatus)){
                            print("\(self.fs.getEquipName(index)): download complete!");
                        }else{
                            print("\(self.fs.getEquipName(index)): error download status change!");
                        }
                    }else{
                        print("download error!");
                    }
                })
                //download
            }
            if(equipStatus & FileSystem.Status.Modifty.rawValue > 0){
                //modify
            }
            if(equipStatus & FileSystem.Status.Delete.rawValue > 0){
                //delete
            }
            if(equipStatus & FileSystem.Status.New.rawValue > 0){
                //new
                
            }
            
            for imageIndex in 0..<fs.getImageCount(index){
                let imageStatus = fs.getImageStatus(index, imageIndex: imageIndex);
                if(fs.isMainImage(index, imageIndex: imageIndex)){
                    if(!(imageStatus & FileSystem.Status.Download.rawValue > 0)){
                        let imageID = fs.getImageID(index, imageIndex: imageIndex);
                        NetworkOperation.sharedInstance().getThumbnail(imageID, handler: { (any) in
                            do{
                                let url = self.getImageFilePathFromFile(index, imageIndex: imageIndex)!;
                                if(!NSFileManager.defaultManager().fileExistsAtPath(url.URLByDeletingLastPathComponent!.path!)){
                                    try NSFileManager.defaultManager().createDirectoryAtPath(url.URLByDeletingLastPathComponent!.path!, withIntermediateDirectories: true, attributes: nil);
                                }
                                any!.writeToFile(url.path!, atomically: true);
                                self.modiftyImageStatusInFile(index, imageIndex: imageIndex, status: imageStatus | FileSystem.Status.Download.rawValue);
                            }catch{
                                print(error);
                            }
                        })
                    }
                    //Main
                }
                if(imageStatus & FileSystem.Status.Modifty.rawValue > 0){
                    //modify
                }
                if(imageStatus & FileSystem.Status.Delete.rawValue > 0){
                    //delete
                }
                if(!(imageStatus & FileSystem.Status.Download.rawValue > 0)){
                    //download
                }
                if(imageStatus & FileSystem.Status.New.rawValue > 0) {
                    //new
                }
                
                
            }
            
            
        }
    }
    
    func downloadEquipImageFromNet(index:Int) {
        for imageIndex in 0..<fs.getImageCount(index){
            let imageID = fs.getImageID(index, imageIndex: imageIndex);
            let imageStatus = fs.getImageStatus(index, imageIndex: imageIndex);
            if(!NSFileManager.defaultManager().fileExistsAtPath(self.getImageFilePathFromFile(index, imageIndex: imageIndex)!.path!)){
                NetworkOperation.sharedInstance().getThumbnail(imageID, handler: { (any) in
                    do{
                        let url = self.getImageFilePathFromFile(index, imageIndex: imageIndex)!;
                        if(!NSFileManager.defaultManager().fileExistsAtPath(url.URLByDeletingLastPathComponent!.path!)){
                            try NSFileManager.defaultManager().createDirectoryAtPath(url.URLByDeletingLastPathComponent!.path!, withIntermediateDirectories: true, attributes: nil);
                        }
                        any!.writeToFile(url.path!, atomically: true);
                        self.modiftyImageStatusInFile(index, imageIndex: imageIndex, status: imageStatus | FileSystem.Status.Download.rawValue);
                    }catch{
                        print(error);
                    }
                })
            }
        }
    }
    
    func checkForPath(url:NSURL)->Bool{
        do{
            let folder = url.URLByDeletingLastPathComponent!;
            if(!NSFileManager.defaultManager().fileExistsAtPath(folder.path!)){
                try NSFileManager.defaultManager().createDirectoryAtPath(folder.path!, withIntermediateDirectories: true, attributes: nil);
            }
            return true;
        }catch{
            print(error);
            return false;
        }
    }
    
    
}
