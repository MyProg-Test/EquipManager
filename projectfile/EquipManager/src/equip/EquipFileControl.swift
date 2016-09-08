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
    //返回当前文件中equip的数量
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
    
    //返回单例模式
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
    
    //从文件中读取信息
    func readInfoFromFile()->Bool{
        if(!NSFileManager.defaultManager().fileExistsAtPath(self.getEquipInfoFilePath().path!)){
            return false;
        }
        objc_sync_enter(self.fs);
        self.fs.readFromFile(self.getEquipInfoFilePath());
        objc_sync_exit(self.fs);
        return true;
    }
    
    //在文件中写入信息
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
    
    //添加equip信息到本地文件
    func addEquipInfoToFile(parentID:Int, XMLID:Int, XMLName:NSString, imageSet:NSMutableArray, path:NSString, groupID:Int,status:Int = 0)->Bool{
        if(!self.readInfoFromFile()){
            return false;
        }
        self.fs.addEquip(parentID, XMLID: XMLID, XMLName: XMLName, imageSet: imageSet, path: path,groupID: groupID, status: status);
        return self.writeInfoToFile();
    }
    //添加图片信息到文件中
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
    //在文件中修改图片名
    func modifyImageNameInFile(equipIndex:Int, imageIndex:Int, name:NSString)->Bool{
        if(!self.readInfoFromFile()){
            return false;
        }
        self.fs.modifyImageName(equipIndex, imageIndex: imageIndex, name: name);
        return self.writeInfoToFile();
    }
    //在文件中修改设备状态
    func modifyEquipStatusInFile(index:Int,status:Int) -> Bool {
        if(!self.readInfoFromFile()){
            return false;
        }
        self.fs.modifyEquipStatus(index, status: status);
        return writeInfoToFile();
    }
    //在文件中修改图片状态
    func modiftyImageStatusInFile(equipIndex:Int, imageIndex:Int, status:Int) -> Bool{
        if(!self.readInfoFromFile()){
            return false;
        }
        self.fs.modifyImageStatus(equipIndex, imageIndex: imageIndex, status: status);
        return writeInfoToFile();
    }
    //从文件中获取设备
    func getEquipFromFile(index:Int)->NSMutableDictionary?{
        if(!self.readInfoFromFile()){
            return nil;
        }
        return self.fs.getEquip(index);
    }
    //从文件中获取文件信息
    func getFileSystemFromFile()->FileSystem?{
        if(!self.readInfoFromFile()){
            return nil;
        }
        return self.fs;
    }
    //获取设备文件的路径
    func getEquipFilePathFromFile(index:Int) -> NSURL? {
        if(!self.readInfoFromFile()){
            return nil;
        }
        let url:NSURL = getEquipPath().URLByAppendingPathComponent(self.fs.getEquipPath(index).path!);
        return url;
    }
    //从文件中获取图片文件路径
    func getImageFilePathFromFile(equipIndex:Int, imageIndex:Int) -> NSURL?{
        if(!self.readInfoFromFile()){
            return nil;
        }
        let url:NSURL = getEquipPath().URLByAppendingPathComponent(self.fs.getImagePath(equipIndex,imageIndex: imageIndex).path!);
        return url;
    }
    
    //根据key和value获取设备的index
    func getSpecIndex(key:NSString,value:AnyObject)->Int{
        if(!self.readInfoFromFile()){
            return -1;
        }
        return self.fs.getSpecIndex(key, value: value);
    }
    
    //获取设备数组
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
    //和网络端交互设备信息
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
    //下载设备图片
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
    //检查当前路径，若不存在，则建立
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
