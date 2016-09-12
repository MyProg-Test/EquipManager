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
    var fs:FileSystem?{
        get{
            return readInfoFromFile();
        }
    }
    //let fs:FileSystem = FileSystem();
    var count:Int{
        get{
            if(fs == nil){
                return 0;
            }
            return fs!.count;
        }
    }
    let rootPath:NSURL;
    let docPath:NSURL;
    let libPath:NSURL;
    let tmpPath:NSURL;
    
    //初始化路径
    private init(){
        docPath = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0];
        print(docPath);
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
    func readInfoFromFile()->FileSystem?{
        if(!NSFileManager.defaultManager().fileExistsAtPath(self.getEquipInfoFilePath().path!)){
            return nil;
        }
        let fs = FileSystem();
        fs.readFromFile(self.getEquipInfoFilePath());
        return fs;
    }
    
    //在文件中写入信息
    func writeInfoToFile(fs: FileSystem)->Bool{
        if(!NSFileManager.defaultManager().fileExistsAtPath(self.getEquipInfoPath().path!)){
            do{
                try NSFileManager.defaultManager().createDirectoryAtPath(self.getEquipInfoPath().path!, withIntermediateDirectories: true, attributes: nil);
            }catch{
                print(error);
                return false;
            }
        }
        return fs.writeToFile(self.getEquipInfoFilePath());
    }
    
    //添加equip信息到本地文件
    func addEquipInfoToFile(parentID:Int, XMLID:Int, XMLName:NSString, imageSet:NSMutableArray, path:NSString, groupID:Int,status:Int = 0)->Bool{
        if(self.fs == nil){
            return false;
        }
        let fs = self.fs;
        fs!.addEquip(parentID, XMLID: XMLID, XMLName: XMLName, imageSet: imageSet, path: path,groupID: groupID, status: status);
        return self.writeInfoToFile(fs!);
    }
    //添加图片信息到文件中
    func addImageInfoToFile(index:Int, imageID:Int, imagePath:NSString, imageName:NSString, status:Int = 0)->Bool{
        if(self.fs == nil){
            return false;
        }
        let fs = self.fs;
        if(index < self.count && index >= 0){
            fs!.addImage(index, imageID: imageID, imagePath: imagePath, imageName: imageName, status: status);
            return self.writeInfoToFile(fs!);
        }
        return false;
    }
    
    func deleteImageFromFile(equipIndex: Int, image: NSMutableDictionary) -> Bool {
        if(self.fs == nil){
            return false;
        }
        let fs = self.fs;
        if(equipIndex < self.count && equipIndex >= 0){
            fs!.deleteImage(equipIndex, image: image);
            return self.writeInfoToFile(fs!);
        }
        return false;
    }
    
    func deleteEquipFromFile(equip: NSMutableDictionary) -> Bool {
        if(self.fs == nil){
            return false;
        }
        let fs = self.fs;
        fs!.deleteEquip(equip);
        return self.writeInfoToFile(fs!);
    }
    //在文件中修改图片名
    func modifyImageNameInFile(equipIndex:Int, imageIndex:Int, name:NSString)->Bool{
        if(self.fs == nil){
            return false;
        }
        let fs = self.fs;
        fs!.modifyImageName(equipIndex, imageIndex: imageIndex, name: name);
        return self.writeInfoToFile(fs!);
    }
    
    func modifyXMLIDInFile(index: Int, id:Int) -> Bool {
        if(self.fs == nil){
            return false;
        }
        let fs = self.fs;
        fs!.modifyXMLID(index, id: id);
        return self.writeInfoToFile(fs!);
    }
    
    func modifyParentIDInFile(index: Int, parentId: Int) -> Bool {
        if(self.fs == nil){
            return false;
        }
        let fs = self.fs;
        fs!.modifyParentID(index, parentId: parentId);
        return self.writeInfoToFile(fs!);
    }
    
    //在文件中修改设备状态
    func modifyEquipStatusInFile(index:Int,status:Int) -> Bool {
        if(self.fs == nil){
            return false;
        }
        let fs = self.fs;
        fs!.modifyEquipStatus(index, status: status);
        return writeInfoToFile(fs!);
    }
    //在文件中修改图片状态
    func modifyImageStatusInFile(equipIndex:Int, imageIndex:Int, status:Int) -> Bool{
        if(self.fs == nil){
            return false;
        }
        let fs = self.fs;
        fs!.modifyImageStatus(equipIndex, imageIndex: imageIndex, status: status);
        return writeInfoToFile(fs!);
    }
    
    func modifyImageIDFromFile(equipIndex: Int, imageIndex: Int, id: Int) -> Bool {
        if(self.fs == nil){
            return false;
        }
        let fs = self.fs;
        fs!.modifyImageID(equipIndex, imageIndex: imageIndex, id: id);
        return writeInfoToFile(fs!);
    }
    
    //从文件中获取文件信息
    func getFileSystemFromFile()->FileSystem?{
        return self.fs;
    }
    
    //MARK:-getEquip
    
    //根据key和value获取设备的index
    func getSpecIndex(key:NSString,value:AnyObject)->Int{
        if(self.fs == nil){
            return -1;
        }
        return self.fs!.getSpecIndex(key, value: value);
    }
    
    func getEquipStatusFromFile(index:Int) -> Int {
        if(self.fs == nil){
            return 0;
        }
        return self.fs!.getEquipStatus(index);
    }
    
    //获取设备文件的路径
    func getEquipFilePathFromFile(index:Int) -> NSURL? {
        if(self.fs == nil){
            return nil;
        }
        let url:NSURL = getEquipPath().URLByAppendingPathComponent(self.fs!.getEquipPath(index).path!);
        return url;
    }
    
    //获取设备数组
    func getEquipArray()->NSMutableArray?{
        if(self.fs == nil){
            return nil;
        }
        return self.fs!.equipArray;
    }
    
    //从文件中获取设备
    func getEquipFromFile(index:Int)->NSMutableDictionary?{
        if(self.fs == nil){
            return nil;
        }
        return self.fs!.getEquip(index);
    }
    
    func getEquipParentIdFromFile(index: Int) -> Int {
        if(self.fs == nil){
            return 0;
        }
        if(index >= 0 && index < self.count){
            return fs!.getEquipParentID(index);
        }
        return 0;
    }
    
    func getEquipGroupIdFromFile(index: Int) -> Int {
        if(self.fs == nil){
            return 0;
        }
        if index >= 0 && index < self.count{
            return fs!.getEquipGroupID(index);
        }
        return 0;
    }
    
    func getEquipXMLIDFromFile(index: Int) -> Int {
        if(self.fs == nil){
            return 0;
        }
        if(index >= 0 && index < self.count){
            return fs!.getEquipXMLID(index);
        }
        return 0;
    }
    
    func getEquipNameFromFile(index: Int) -> NSString {
        if(self.fs == nil){
            return "";
        }
        if index >= 0 && index < self.count {
            return fs!.getEquipName(index);
        }
        return "";
    }
    
    //MARK:- getImage
    func isMainImageFromFile(equipIndex: Int, imageIndex: Int) -> Bool {
        if(self.fs == nil){
            return false;
        }
        return fs!.isMainImage(equipIndex, imageIndex: imageIndex);
    }
    func getImageStatusFromFile(equipIndex:Int, imageIndex:Int) -> Int {
        if(self.fs == nil){
            return 0;
        }
        return self.fs!.getImageStatus(equipIndex, imageIndex: imageIndex);
    }
    
    func getImageIDFromFile(equipIndex: Int, imageIndex: Int) -> Int {
        if(self.fs == nil){
            return 0;
        }
        if equipIndex >= 0 && equipIndex < self.count{
            if imageIndex >= 0 && imageIndex < self.getImageCountFromFile(equipIndex) {
                return fs!.getImageID(equipIndex, imageIndex: imageIndex);
            }
        }
        return 0;
    }
    
    func getImageNameFromFile(equipIndex: Int, imageIndex: Int) -> NSString {
        if(self.fs == nil){
            return "";
        }
        if equipIndex >= 0 && equipIndex < self.count{
            if imageIndex >= 0 && imageIndex < self.getImageCountFromFile(imageIndex) {
                return fs!.getImageName(equipIndex, imageIndex: imageIndex);
            }
        }
        return "";
    }
    
    func getImageFromFile(equipIndex: Int, imageIndex: Int) -> NSMutableDictionary? {
        if(self.fs == nil){
            return nil;
        }
        return self.fs?.getImage(equipIndex, imageIndex: imageIndex);
    }
    
    //从文件中获取图片文件路径
    func getImageFilePathFromFile(equipIndex:Int, imageIndex:Int) -> NSURL?{
        if(self.fs == nil){
            return nil;
        }
        let url:NSURL = getEquipPath().URLByAppendingPathComponent(self.fs!.getImagePath(equipIndex,imageIndex: imageIndex).path!);
        return url;
    }
    
    func getImageCountFromFile(index: Int) -> Int {
        if(self.fs == nil){
            return 0;
        }
        return self.fs!.getImageCount(index);
    }
    
    //检查设备相关路径是否存在，若不存在，则建立
    func checkForEquipAssociationFile()->Bool{
        do{
            if(!NSFileManager.defaultManager().fileExistsAtPath(getEquipInfoFilePath().path!)){
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
        if(self.fs == nil){
            self.checkForEquipAssociationFile();
        }
        let deleteEquipList: NSMutableArray = NSMutableArray();
        for index in 0.stride(to: self.count, by: 1) {
            if(!(self.getEquipStatusFromFile(index) & FileSystem.Status.Download.rawValue > 0)){
                NetworkOperation.sharedInstance().downloadResource(self.getEquipXMLIDFromFile(index), url: self.getEquipFilePathFromFile(index)!){ (any) in
                    print(any);
                    if(NSFileManager.defaultManager().fileExistsAtPath(self.getEquipFilePathFromFile(index)!.path!)){
                        if(self.modifyEquipStatusInFile(index, status: FileSystem.Status.Download.rawValue|self.getEquipStatusFromFile(index))){
                            print("\(self.getEquipNameFromFile(index)): download complete!");
                        }else{
                            print("\(self.getEquipNameFromFile(index)): error download status change!");
                        }
                    }else{
                        print("download error!");
                    }
                }
                //download
            }
            if(self.getEquipStatusFromFile(index) & FileSystem.Status.Modifty.rawValue > 0){
                NetworkOperation.sharedInstance().deleteResource(self.getEquipXMLIDFromFile(index)){
                    (any) in
                    print(any);
                    NetworkOperation.sharedInstance().uploadResourceReturnId(self.getEquipGroupIdFromFile(index), parentID: self.getEquipParentIdFromFile(index), fileURL: self.getEquipFilePathFromFile(index)!, fileName: self.getEquipNameFromFile(index)){(any) in
                        let newFile:NSDictionary = any.objectForKey(NetworkOperation.NetConstant.DictKey.UploadResourceReturnId.Response.file) as! NSDictionary;
                        let newid:Int = newFile.objectForKey(NetworkOperation.NetConstant.DictKey.UploadResourceReturnId.Response.FileKey.id) as! Int;
                        let oldPath = self.getEquipFilePathFromFile(index)!;
                        self.modifyXMLIDInFile(index, id: newid);
                        let newPath = self.getEquipFilePathFromFile(index)!;
                        do{
                            try NSFileManager.defaultManager().moveItemAtPath(oldPath.path!, toPath: newPath.path!);
                            self.modifyEquipStatusInFile(index, status: self.getEquipStatusFromFile(index) & ~FileSystem.Status.Modifty.rawValue);
                        }catch{
                            print(error);
                        }
                    }
                }
                //modify
            }
            if(self.getEquipStatusFromFile(index) & FileSystem.Status.Delete.rawValue > 0){
                NetworkOperation.sharedInstance().deleteResource(self.getEquipXMLIDFromFile(index)){ (any) in
                    print(any);
                    do{
                        try NSFileManager.defaultManager().removeItemAtPath(self.getEquipFilePathFromFile(index)!.URLByDeletingLastPathComponent!.path!);
                    }catch{
                        print(error);
                    }
                }
                deleteEquipList.addObject(self.getEquipFromFile(index)!);
                //delete
            }
            if(self.getEquipStatusFromFile(index) & FileSystem.Status.New.rawValue > 0){
                NetworkOperation.sharedInstance().createDir(self.getEquipGroupIdFromFile(index), name: self.getEquipNameFromFile(index).stringByDeletingPathExtension, parentID: EquipManager.sharedInstance().rootId){(any) in
                    print(any);
                    let dirID = any.objectForKey(NetworkOperation.NetConstant.DictKey.CreateDir.Response.id) as! Int;
                    self.modifyParentIDInFile(index, parentId: dirID);
                    NetworkOperation.sharedInstance().uploadResourceReturnId(self.getEquipGroupIdFromFile(index), parentID: self.getEquipParentIdFromFile(index), fileURL: self.getEquipFilePathFromFile(index)!, fileName: self.getEquipNameFromFile(index)){(any) in
                        print(any);
                        let newFile:NSDictionary = any.objectForKey(NetworkOperation.NetConstant.DictKey.UploadResourceReturnId.Response.file)!.firstObject as! NSDictionary;
                        let newid:Int = newFile.objectForKey(NetworkOperation.NetConstant.DictKey.UploadResourceReturnId.Response.FileKey.id) as! Int;
                        let oldPath = self.getEquipFilePathFromFile(index)!;
                        self.modifyXMLIDInFile(index, id: newid);
                        let newPath = self.getEquipFilePathFromFile(index)!;
                        do{
                            try NSFileManager.defaultManager().moveItemAtPath(oldPath.path!, toPath: newPath.path!);
                            self.modifyEquipStatusInFile(index, status: self.getEquipStatusFromFile(index) & ~FileSystem.Status.New.rawValue)
                        }catch{
                            print(error);
                        }
                    }
                }
                //new
                
            }
            let deleteImageList:NSMutableArray = NSMutableArray();
            for imageIndex in 0.stride(to: getImageCountFromFile(index), by: 1){
                if(self.isMainImageFromFile(index, imageIndex: imageIndex)){
                    if(!(self.getImageStatusFromFile(index, imageIndex: imageIndex) & FileSystem.Status.Download.rawValue > 0)){
                        let imageID = self.getImageIDFromFile(index, imageIndex: imageIndex);
                        NetworkOperation.sharedInstance().getThumbnail(imageID, handler: { (any) in
                            do{
                                let url = self.getImageFilePathFromFile(index, imageIndex: imageIndex)!;
                                if(!NSFileManager.defaultManager().fileExistsAtPath(url.URLByDeletingLastPathComponent!.path!)){
                                    try NSFileManager.defaultManager().createDirectoryAtPath(url.URLByDeletingLastPathComponent!.path!, withIntermediateDirectories: true, attributes: nil);
                                }
                                
                                any!.writeToFile(url.path!, atomically: true);
                                self.modifyImageStatusInFile(index, imageIndex: imageIndex, status: self.getImageStatusFromFile(index, imageIndex: imageIndex) | FileSystem.Status.Download.rawValue);
                            }catch{
                                print(error);
                            }
                        })
                    }
                    //Main
                }
                if(self.getImageStatusFromFile(index, imageIndex: imageIndex) & FileSystem.Status.Modifty.rawValue > 0){
                    NetworkOperation.sharedInstance().modifyResource(self.getImageIDFromFile(index, imageIndex: imageIndex), name: self.getImageNameFromFile(index, imageIndex: imageIndex).stringByDeletingPathExtension){ (any) in
                        print(any);
                        self.modifyImageStatusInFile(index, imageIndex: imageIndex, status: self.getImageStatusFromFile(index, imageIndex: imageIndex) & ~FileSystem.Status.Modifty.rawValue);
                    }
                    //modify
                }
                if(self.getImageStatusFromFile(index, imageIndex: imageIndex) & FileSystem.Status.Delete.rawValue > 0){
                    NetworkOperation.sharedInstance().deleteResource(self.getImageIDFromFile(index, imageIndex: imageIndex)){(any) in
                        print(any);
                    }
                    deleteImageList.addObject(self.getImageFromFile(index, imageIndex: imageIndex)!);
                    //delete
                }
                if(!(self.getImageStatusFromFile(index, imageIndex: imageIndex) & FileSystem.Status.Download.rawValue > 0)){
                    //download
                }
                if(self.getImageStatusFromFile(index, imageIndex: imageIndex) & FileSystem.Status.New.rawValue > 0) {
                    NetworkOperation.sharedInstance().uploadResourceReturnId(self.getEquipGroupIdFromFile(index), parentID: self.getEquipParentIdFromFile(index), fileURL: self.getImageFilePathFromFile(index, imageIndex: imageIndex)!, fileName: self.getImageNameFromFile(index, imageIndex: imageIndex)){(any) in
                        let newFile:NSDictionary = any.objectForKey(NetworkOperation.NetConstant.DictKey.UploadResourceReturnId.Response.file) as! NSDictionary;
                        let newid:Int = newFile.objectForKey(NetworkOperation.NetConstant.DictKey.UploadResourceReturnId.Response.FileKey.id) as! Int;
                        let oldPath = self.getImageFilePathFromFile(index, imageIndex: imageIndex)!;
                        self.modifyImageIDFromFile(index, imageIndex: imageIndex, id: newid);
                        let newPath = self.getEquipFilePathFromFile(index)!;
                        do{
                            try NSFileManager.defaultManager().moveItemAtPath(oldPath.path!, toPath: newPath.path!);
                            self.modifyEquipStatusInFile(index, status: self.getEquipStatusFromFile(index) & ~FileSystem.Status.New.rawValue)
                        }catch{
                            print(error);
                        }
                    }
                    //new
                }
                
                
            }
            for tmp in deleteImageList {
                self.deleteImageFromFile(index, image: tmp as! NSMutableDictionary);
            }
        }
        for tmp in deleteEquipList {
            self.deleteEquipFromFile(tmp as! NSMutableDictionary);
        }
    }
    //下载设备图片
    func downloadEquipImageFromNet(index:Int) {
        if(fs == nil){
            return ;
        }
        for imageIndex in 0..<fs!.getImageCount(index){
            let imageID = fs!.getImageID(index, imageIndex: imageIndex);
            let imageStatus = fs!.getImageStatus(index, imageIndex: imageIndex);
            if(!NSFileManager.defaultManager().fileExistsAtPath(self.getImageFilePathFromFile(index, imageIndex: imageIndex)!.path!)){
                NetworkOperation.sharedInstance().getThumbnail(imageID, handler: { (any) in
                    do{
                        let url = self.getImageFilePathFromFile(index, imageIndex: imageIndex)!;
                        if(!NSFileManager.defaultManager().fileExistsAtPath(url.URLByDeletingLastPathComponent!.path!)){
                            try NSFileManager.defaultManager().createDirectoryAtPath(url.URLByDeletingLastPathComponent!.path!, withIntermediateDirectories: true, attributes: nil);
                        }
                        any!.writeToFile(url.path!, atomically: true);
                        self.modifyImageStatusInFile(index, imageIndex: imageIndex, status: imageStatus | FileSystem.Status.Download.rawValue);
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
