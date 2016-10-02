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
    fileprivate static let _sharedInstance = EquipFileControl();
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
    let rootPath:URL;
    let docPath:URL;
    let libPath:URL;
    let tmpPath:URL;
    
    //初始化路径
    fileprivate init(){
        docPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0];
        print(docPath);
        rootPath = docPath.deletingLastPathComponent();
        libPath = rootPath.appendingPathComponent("Library")
        tmpPath = rootPath.appendingPathComponent("tmp");
        self.checkForEquipAssociationFile();
    }
    
    //返回单例模式
    class func sharedInstance()->EquipFileControl{
        return _sharedInstance;
    }
    
    //获取当前帐号路径
    func getAccountPath()->URL{
        return docPath.appendingPathComponent("Account");
    }
    
    //获取当前帐号下的设备路径
    func getEquipPath()->URL{
        return getAccountPath().appendingPathComponent("我的设备");
    }
    
    //获取当前帐号下设备的相关信息路径
    func getEquipAssociationPath()->URL{
        return getEquipPath().appendingPathComponent("Equip");
    }
    
    //获取当前帐号下设备信息路径
    func getEquipInfoPath()->URL{
        return getEquipAssociationPath().appendingPathComponent("Infos");
    }
    
    //获取当前帐号下设备日志路径
    func getEquipLogsPath()->URL{
        return getEquipAssociationPath().appendingPathComponent("Logs");
    }
    
    //获取当前帐号下设备信息文件路径
    func getEquipInfoFilePath()->URL{
        return getEquipInfoPath().appendingPathComponent(equipInfoName, isDirectory: false);
    }
    
    //创建空设备文件
    func createEmptyEquipFile(_ url:URL)->Bool{
        let data:NSMutableArray = NSMutableArray();
        return data.write(toFile: url.path, atomically: true);
    }
    
    //从文件中读取信息
    func readInfoFromFile()->FileSystem?{
        if(!FileManager.default.fileExists(atPath: self.getEquipInfoFilePath().path)){
            return nil;
        }
        let fs = FileSystem();
        _ = fs.readFromFile(self.getEquipInfoFilePath());
        return fs;
    }
    
    //在文件中写入信息
    func writeInfoToFile(_ fs: FileSystem)->Bool{
        if(!FileManager.default.fileExists(atPath: self.getEquipInfoPath().path)){
            do{
                try FileManager.default.createDirectory(atPath: self.getEquipInfoPath().path, withIntermediateDirectories: true, attributes: nil);
            }catch{
                print(error);
                return false;
            }
        }
        return fs.writeToFile(self.getEquipInfoFilePath());
    }
    
    //添加equip信息到本地文件
    func addEquipInfoToFile(_ parentID:Int, XMLID:Int, XMLName:String, imageSet:NSMutableArray, path:String, groupID:Int,status:Int = 0)->Bool{
        if(self.fs == nil){
            return false;
        }
        let fs = self.fs;
        fs!.addEquip(parentID, XMLID: XMLID, XMLName: XMLName, imageSet: imageSet, path: path,groupID: groupID, status: status);
        return self.writeInfoToFile(fs!);
    }
    //添加图片信息到文件中
    func addImageInfoToFile(_ index:Int, imageID:Int, imagePath:String, imageName:String, status:Int = 0)->Bool{
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
    
    func deleteImageFromFile(_ equipIndex: Int, image: NSMutableDictionary) -> Bool {
        if(self.fs == nil){
            return false;
        }
        let fs = self.fs;
        if(equipIndex < self.count && equipIndex >= 0){
            _ = fs!.deleteImage(equipIndex, image: image);
            return self.writeInfoToFile(fs!);
        }
        return false;
    }
    
    func deleteEquipFromFile(_ equip: NSMutableDictionary) -> Bool {
        if(self.fs == nil){
            return false;
        }
        let fs = self.fs;
        _ = fs!.deleteEquip(equip);
        return self.writeInfoToFile(fs!);
    }
    //在文件中修改图片名
    func modifyImageNameInFile(_ equipIndex:Int, imageIndex:Int, name:String)->Bool{
        if(self.fs == nil){
            return false;
        }
        let fs = self.fs;
        fs!.modifyImageName(equipIndex, imageIndex: imageIndex, name: name);
        return self.writeInfoToFile(fs!);
    }
    
    func modifyXMLIDInFile(_ index: Int, id:Int) -> Bool {
        if(self.fs == nil){
            return false;
        }
        let fs = self.fs;
        fs!.modifyXMLID(index, id: id);
        return self.writeInfoToFile(fs!);
    }
    
    func modifyParentIDInFile(_ index: Int, parentId: Int) -> Bool {
        if(self.fs == nil){
            return false;
        }
        let fs = self.fs;
        fs!.modifyParentID(index, parentId: parentId);
        return self.writeInfoToFile(fs!);
    }
    
    //在文件中修改设备状态
    func modifyEquipStatusInFile(_ index:Int,status:Int) -> Bool {
        if(self.fs == nil){
            return false;
        }
        let fs = self.fs;
        fs!.modifyEquipStatus(index, status: status);
        return writeInfoToFile(fs!);
    }
    //在文件中修改图片状态
    func modifyImageStatusInFile(_ equipIndex:Int, imageIndex:Int, status:Int) -> Bool{
        if(self.fs == nil){
            return false;
        }
        let fs = self.fs;
        fs!.modifyImageStatus(equipIndex, imageIndex: imageIndex, status: status);
        return writeInfoToFile(fs!);
    }
    
    func modifyImageIDFromFile(_ equipIndex: Int, imageIndex: Int, id: Int) -> Bool {
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
    func getSpecIndex(_ key:String,value:AnyObject)->Int{
        if(self.fs == nil){
            return -1;
        }
        return self.fs!.getSpecIndex(key, value: value);
    }
    
    func getEquipStatusFromFile(_ index:Int) -> Int {
        if(self.fs == nil){
            return 0;
        }
        return self.fs!.getEquipStatus(index);
    }
    
    //获取设备文件的路径
    func getEquipFilePathFromFile(_ index:Int) -> URL? {
        if(self.fs == nil){
            return nil;
        }
        let url:URL = getEquipPath().appendingPathComponent(self.fs!.getEquipPath(index).path);
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
    func getEquipFromFile(_ index:Int)->NSMutableDictionary?{
        if(self.fs == nil){
            return nil;
        }
        return self.fs!.getEquip(index);
    }
    
    func getEquipParentIdFromFile(_ index: Int) -> Int {
        if(self.fs == nil){
            return 0;
        }
        if(index >= 0 && index < self.count){
            return fs!.getEquipParentID(index);
        }
        return 0;
    }
    
    func getEquipGroupIdFromFile(_ index: Int) -> Int {
        if(self.fs == nil){
            return 0;
        }
        if index >= 0 && index < self.count{
            return fs!.getEquipGroupID(index);
        }
        return 0;
    }
    
    func getEquipXMLIDFromFile(_ index: Int) -> Int {
        if(self.fs == nil){
            return 0;
        }
        if(index >= 0 && index < self.count){
            return fs!.getEquipXMLID(index);
        }
        return 0;
    }
    
    func getEquipNameFromFile(_ index: Int) -> String {
        if(self.fs == nil){
            return "";
        }
        if index >= 0 && index < self.count {
            return fs!.getEquipName(index);
        }
        return "";
    }
    
    //MARK:- getImage
    func isMainImageFromFile(_ equipIndex: Int, imageIndex: Int) -> Bool {
        if(self.fs == nil){
            return false;
        }
        return fs!.isMainImage(equipIndex, imageIndex: imageIndex);
    }
    
    func setMainImageFromFile(_ equipIndex: Int, imageIndex: Int) -> Bool {
        if(self.fs == nil){
            return false;
        }
        let fs = self.fs;
        _ = fs!.setMainImage(equipIndex, imageIndex: imageIndex);
        return writeInfoToFile(fs!);
        
    }
    
    func resetMainImageFromFile(_ equipIndex: Int, imageIndex: Int) -> Bool {
        if(self.fs == nil){
            return false;
        }
        let fs = self.fs;
        _ = fs!.resetMainImage(equipIndex, imageIndex: imageIndex);
        return writeInfoToFile(fs!);
        
    }
    func getImageStatusFromFile(_ equipIndex:Int, imageIndex:Int) -> Int {
        if(self.fs == nil){
            return 0;
        }
        return self.fs!.getImageStatus(equipIndex, imageIndex: imageIndex);
    }
    
    func getImageIDFromFile(_ equipIndex: Int, imageIndex: Int) -> Int {
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
    
    func getImageNameFromFile(_ equipIndex: Int, imageIndex: Int) -> String {
        if(self.fs == nil){
            return "";
        }
        if equipIndex >= 0 && equipIndex < self.count{
            if imageIndex >= 0 && imageIndex < self.getImageCountFromFile(equipIndex) {
                return fs!.getImageName(equipIndex, imageIndex: imageIndex);
            }
        }
        return "";
    }
    
    func getImageFromFile(_ equipIndex: Int, imageIndex: Int) -> NSMutableDictionary? {
        if(self.fs == nil){
            return nil;
        }
        return self.fs?.getImage(equipIndex, imageIndex: imageIndex);
    }
    
    //从文件中获取图片文件路径
    func getImageFilePathFromFile(_ equipIndex:Int, imageIndex:Int) -> URL?{
        if(self.fs == nil){
            return nil;
        }
        let url:URL = getEquipPath().appendingPathComponent(self.fs!.getImagePath(equipIndex,imageIndex: imageIndex).path);
        return url;
    }
    
    func getImageCountFromFile(_ index: Int) -> Int {
        if(self.fs == nil){
            return 0;
        }
        return self.fs!.getImageCount(index);
    }
    
    //检查设备相关路径是否存在，若不存在，则建立
    func checkForEquipAssociationFile()->Bool{
        do{
            if(!FileManager.default.fileExists(atPath: getEquipInfoFilePath().path)){
                try FileManager.default.createDirectory(atPath: getEquipInfoPath().path, withIntermediateDirectories: true, attributes: nil);
                createEmptyEquipFile(getEquipInfoFilePath());
            }
            if(!FileManager.default.fileExists(atPath: getEquipLogsPath().path)){
                try FileManager.default.createDirectory(atPath: getEquipLogsPath().path, withIntermediateDirectories: true, attributes: nil);
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
            _ = self.checkForEquipAssociationFile();
        }
        let deleteEquipList: NSMutableArray = NSMutableArray();
        for index in stride(from: 0, to: self.count, by: 1) {
            if(!(self.getEquipStatusFromFile(index) & FileSystem.Status.download.rawValue > 0)){
                _ = NetworkOperation.sharedInstance().downloadResource(self.getEquipXMLIDFromFile(index), url: self.getEquipFilePathFromFile(index)!){ (any) in
                    if(FileManager.default.fileExists(atPath: self.getEquipFilePathFromFile(index)!.path)){
                        if(self.modifyEquipStatusInFile(index, status: FileSystem.Status.download.rawValue|self.getEquipStatusFromFile(index))){
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
            if(self.getEquipStatusFromFile(index) & FileSystem.Status.modifty.rawValue > 0){
                NetworkOperation.sharedInstance().deleteResource(self.getEquipXMLIDFromFile(index)){
                    (any) in
                    print(any);
                    NetworkOperation.sharedInstance().uploadResourceReturnId(self.getEquipGroupIdFromFile(index), parentID: self.getEquipParentIdFromFile(index), fileURL: self.getEquipFilePathFromFile(index)!, fileName: self.getEquipNameFromFile(index)){(any) in
                        let newFile:NSDictionary = (any.object(forKey: NetworkOperation.NetConstant.DictKey.UploadResourceReturnId.Response.file)! as AnyObject).firstObject as! NSDictionary;
                        let newid:Int = newFile.object(forKey: NetworkOperation.NetConstant.DictKey.UploadResourceReturnId.Response.FileKey.id) as! Int;
                        let oldPath = self.getEquipFilePathFromFile(index)!;
                        self.modifyXMLIDInFile(index, id: newid);
                        let newPath = self.getEquipFilePathFromFile(index)!;
                        do{
                            try FileManager.default.moveItem(atPath: oldPath.path, toPath: newPath.path);
                            self.modifyEquipStatusInFile(index, status: self.getEquipStatusFromFile(index) & ~FileSystem.Status.modifty.rawValue);
                        }catch{
                            print(error);
                        }
                    }
                }
                //modify
            }
            if(self.getEquipStatusFromFile(index) & FileSystem.Status.delete.rawValue > 0){
                NetworkOperation.sharedInstance().deleteResource(self.getEquipXMLIDFromFile(index)){ (any) in
                    print(any);
                    do{
                        try FileManager.default.removeItem(atPath: self.getEquipFilePathFromFile(index)!.deletingLastPathComponent().path);
                    }catch{
                        print(error);
                    }
                }
                deleteEquipList.add(self.getEquipFromFile(index)!);
                //delete
            }
            if(self.getEquipStatusFromFile(index) & FileSystem.Status.new.rawValue > 0){
                _ = NetworkOperation.sharedInstance().createDir(self.getEquipGroupIdFromFile(index), name: (self.getEquipNameFromFile(index) as NSString).deletingPathExtension, parentID: EquipManager.sharedInstance().rootId){(any) in
                    print(any);
                    let dirID = any.object(forKey: NetworkOperation.NetConstant.DictKey.CreateDir.Response.id) as! Int;
                    _ = self.modifyParentIDInFile(index, parentId: dirID);
                    _ = NetworkOperation.sharedInstance().uploadResourceReturnId(self.getEquipGroupIdFromFile(index), parentID: self.getEquipParentIdFromFile(index), fileURL: self.getEquipFilePathFromFile(index)!, fileName: self.getEquipNameFromFile(index)){(any) in
                        print(any);
                        let newFile:NSDictionary = (any.object(forKey: NetworkOperation.NetConstant.DictKey.UploadResourceReturnId.Response.file)! as AnyObject).firstObject as! NSDictionary;
                        let newid:Int = newFile.object(forKey: NetworkOperation.NetConstant.DictKey.UploadResourceReturnId.Response.FileKey.id) as! Int;
                        let oldPath = self.getEquipFilePathFromFile(index)!;
                        _ = self.modifyXMLIDInFile(index, id: newid);
                        let newPath = self.getEquipFilePathFromFile(index)!;
                        do{
                            try FileManager.default.moveItem(atPath: oldPath.path, toPath: newPath.path);
                            _ = self.modifyEquipStatusInFile(index, status: self.getEquipStatusFromFile(index) & ~FileSystem.Status.new.rawValue)
                        }catch{
                            print(error);
                        }
                    }
                }
                //new
                
            }
            let deleteImageList:NSMutableArray = NSMutableArray();
            for imageIndex in stride(from: 0, to: getImageCountFromFile(index), by: 1){
                if(self.isMainImageFromFile(index, imageIndex: imageIndex)){
                    if(!(self.getImageStatusFromFile(index, imageIndex: imageIndex) & FileSystem.Status.download.rawValue > 0)){
                        let imageID = self.getImageIDFromFile(index, imageIndex: imageIndex);
                        NetworkOperation.sharedInstance().getThumbnail(imageID, handler: { (any) in
                            do{
                                let url = self.getImageFilePathFromFile(index, imageIndex: imageIndex)!;
                                if(!FileManager.default.fileExists(atPath: url.deletingLastPathComponent().path)){
                                    try FileManager.default.createDirectory(atPath: url.deletingLastPathComponent().path, withIntermediateDirectories: true, attributes: nil);
                                }
                                
                                any!.write(toFile: url.path, atomically: true);
                                self.modifyImageStatusInFile(index, imageIndex: imageIndex, status: self.getImageStatusFromFile(index, imageIndex: imageIndex) | FileSystem.Status.download.rawValue);
                            }catch{
                                print(error);
                            }
                        })
                    }
                    //Main
                }
                if(self.getImageStatusFromFile(index, imageIndex: imageIndex) & FileSystem.Status.modifty.rawValue > 0){
                    NetworkOperation.sharedInstance().modifyResource(self.getImageIDFromFile(index, imageIndex: imageIndex), name: (self.getImageNameFromFile(index, imageIndex: imageIndex) as NSString).deletingPathExtension){ (any) in
                        print(any);
                        self.modifyImageStatusInFile(index, imageIndex: imageIndex, status: self.getImageStatusFromFile(index, imageIndex: imageIndex) & ~FileSystem.Status.modifty.rawValue);
                    }
                    //modify
                }
                if(self.getImageStatusFromFile(index, imageIndex: imageIndex) & FileSystem.Status.delete.rawValue > 0){
                    NetworkOperation.sharedInstance().deleteResource(self.getImageIDFromFile(index, imageIndex: imageIndex)){(any) in
                        print(any);
                    }
                    deleteImageList.add(self.getImageFromFile(index, imageIndex: imageIndex)!);
                    //delete
                }
                if(!(self.getImageStatusFromFile(index, imageIndex: imageIndex) & FileSystem.Status.download.rawValue > 0)){
                    //download
                }
                if(self.getImageStatusFromFile(index, imageIndex: imageIndex) & FileSystem.Status.new.rawValue > 0) {
                    NetworkOperation.sharedInstance().uploadResourceReturnId(self.getEquipGroupIdFromFile(index), parentID: self.getEquipParentIdFromFile(index), fileURL: self.getImageFilePathFromFile(index, imageIndex: imageIndex)!, fileName: self.getImageNameFromFile(index, imageIndex: imageIndex)){(any) in
                        let newFile:NSDictionary = (any.object(forKey: NetworkOperation.NetConstant.DictKey.UploadResourceReturnId.Response.file)! as AnyObject).firstObject as! NSDictionary;
                        let newid:Int = newFile.object(forKey: NetworkOperation.NetConstant.DictKey.UploadResourceReturnId.Response.FileKey.id) as! Int;
                        let oldPath = self.getImageFilePathFromFile(index, imageIndex: imageIndex)!;
                        self.modifyImageIDFromFile(index, imageIndex: imageIndex, id: newid);
                        let newPath = self.getImageFilePathFromFile(index, imageIndex: imageIndex)!;
                        do{
                            try FileManager.default.moveItem(atPath: oldPath.path, toPath: newPath.path);
                            self.modifyImageStatusInFile(index, imageIndex: imageIndex, status: self.getImageStatusFromFile(index, imageIndex: imageIndex) & ~FileSystem.Status.new.rawValue);
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
    func downloadEquipImageFromNet(_ index:Int) {
        if(fs == nil){
            return ;
        }
        for imageIndex in 0..<fs!.getImageCount(index){
            let imageID = fs!.getImageID(index, imageIndex: imageIndex);
            let imageStatus = fs!.getImageStatus(index, imageIndex: imageIndex);
            if(!FileManager.default.fileExists(atPath: self.getImageFilePathFromFile(index, imageIndex: imageIndex)!.path)){
                NetworkOperation.sharedInstance().getThumbnail(imageID, handler: { (any) in
                    do{
                        let url = self.getImageFilePathFromFile(index, imageIndex: imageIndex)!;
                        if(!FileManager.default.fileExists(atPath: url.deletingLastPathComponent().path)){
                            try FileManager.default.createDirectory(atPath: url.deletingLastPathComponent().path, withIntermediateDirectories: true, attributes: nil);
                        }
                        any!.write(toFile: url.path, atomically: true);
                        self.modifyImageStatusInFile(index, imageIndex: imageIndex, status: imageStatus | FileSystem.Status.download.rawValue);
                    }catch{
                        print(error);
                    }
                })
            }
        }
    }
    //检查当前路径，若不存在，则建立
    func checkForPath(_ url:URL)->Bool{
        do{
            let folder = url.deletingLastPathComponent();
            if(!FileManager.default.fileExists(atPath: folder.path)){
                try FileManager.default.createDirectory(atPath: folder.path, withIntermediateDirectories: true, attributes: nil);
            }
            return true;
        }catch{
            print(error);
            return false;
        }
    }
    
    
}
