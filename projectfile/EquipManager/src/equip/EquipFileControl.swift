//
//  EquipFileControl.swift
//  EquipManager
//
//  Created by 李呱呱 on 16/7/31.
//  Copyright © 2016年 liguagua. All rights reserved.
//

import UIKit

//本地设备的文件控制
class EquipFileControl {
    fileprivate static let _sharedInstance = EquipFileControl();
    let equipDictInfoName = "EquipDictInfo.info";
    let equipOrderInfoName = "EquipOrderInfo.info"
    
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
    
    
    fileprivate init(){
        docPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0];
        print(docPath);
        rootPath = docPath.deletingLastPathComponent();
        libPath = rootPath.appendingPathComponent("Library")
        tmpPath = rootPath.appendingPathComponent("tmp");
        _ = self.checkForEquipAssociationFile();
    }
    
 
    class func sharedInstance()->EquipFileControl{
        return _sharedInstance;
    }
    
    
    func getAccountPath()->URL{
        return docPath.appendingPathComponent("Account");
    }
    
   
    func getEquipPath()->URL{
        return getAccountPath().appendingPathComponent("我的设备");
    }
    
  
    func getEquipAssociationPath()->URL{
        return getEquipPath().appendingPathComponent("Equip");
    }
    
   
    func getEquipInfoPath()->URL{
        return getEquipAssociationPath().appendingPathComponent("Infos");
    }
    
   
    func getEquipLogsPath()->URL{
        return getEquipAssociationPath().appendingPathComponent("Logs");
    }
    
    
    func getEquipInfoDictFilePath()->URL{
        return getEquipInfoPath().appendingPathComponent(equipDictInfoName, isDirectory: false);
    }
    
    func getEquipInfoOrderFilePath() -> URL{
        return getEquipInfoPath().appendingPathComponent(equipOrderInfoName, isDirectory: false);
    }
    

    func createEmptyDictFile(_ url:URL)->Bool{
        let data:NSMutableDictionary = NSMutableDictionary();
        return data.write(toFile: url.path, atomically: true);
    }
    
    func createEmptyArrayFile(_ url:URL)->Bool{
        let data:NSMutableArray = NSMutableArray();
        return data.write(toFile: url.path, atomically: true);
    }
    
  
    func readInfoFromFile()->FileSystem?{
        if(!FileManager.default.fileExists(atPath: self.getEquipInfoDictFilePath().path) || !FileManager.default.fileExists(atPath: self.getEquipInfoOrderFilePath().path)){
            return nil;
        }
        let fs = FileSystem();
        _ = fs.readFromFile(self.getEquipInfoDictFilePath(), orderurl: self.getEquipInfoOrderFilePath());
        return fs;
    }
    

    func writeInfoToFile(_ fs: FileSystem)->Bool{
        if(!FileManager.default.fileExists(atPath: self.getEquipInfoPath().path)){
            do{
                try FileManager.default.createDirectory(atPath: self.getEquipInfoPath().path, withIntermediateDirectories: true, attributes: nil);
            }catch{
                print(error);
                return false;
            }
        }
        return fs.writeToFile(self.getEquipInfoDictFilePath(), orderurl: self.getEquipInfoOrderFilePath());
    }
    

    func addEquipInfoToFile(_ parentID:Int, XMLID:Int, XMLName:String, imageSet:NSMutableArray, path:String, groupID:Int,status:Int = 0)->Bool{
        if(self.fs == nil){
            return false;
        }
        let fs = self.fs;
        fs!.addEquip(parentID, XMLID: XMLID, XMLName: XMLName, imageSet: imageSet, path: path,groupID: groupID, status: status);
        return self.writeInfoToFile(fs!);
    }
 
    func addImageInfoToFile(_ key:String, imageID:Int, imagePath:String, imageName:String, status:Int = 0)->Bool{
        if(self.fs == nil){
            return false;
        }
        let fs = self.fs;
        fs!.addImage(key, imageID: imageID, imagePath: imagePath, imageName: imageName, status: status);
        return self.writeInfoToFile(fs!);
    }
    
    func deleteImageFromFile(_ equipkey: String, image: NSMutableDictionary) -> Bool {
        if(self.fs == nil){
            return false;
        }
        let fs = self.fs;
        _ = fs!.deleteImage(equipkey, image: image);
        return self.writeInfoToFile(fs!);
    }
    
    func deleteEquipFromFile(_ key: String) -> Bool {
        if(self.fs == nil){
            return false;
        }
        let fs = self.fs;
        _ = fs!.deleteEquip(key);
        return self.writeInfoToFile(fs!);
    }
   
    func modifyImageNameInFile(_ equipkey:String, imageIndex:Int, name:String)->Bool{
        if(self.fs == nil){
            return false;
        }
        let fs = self.fs;
        fs!.modifyImageName(equipkey, imageIndex: imageIndex, name: name);
        return self.writeInfoToFile(fs!);
    }
    
    func modifyXMLIDInFile(_ key: String, id:Int) -> Bool {
        if(self.fs == nil){
            return false;
        }
        let fs = self.fs;
        fs!.modifyXMLID(key, id: id);
        return self.writeInfoToFile(fs!);
    }
    
    func modifyParentIDInFile(_ key: String, parentId: Int) -> Bool {
        if(self.fs == nil){
            return false;
        }
        let fs = self.fs;
        fs!.modifyParentID(key, parentId: parentId);
        return self.writeInfoToFile(fs!);
    }
    
  
    func modifyEquipStatusInFile(_ key:String,status:Int) -> Bool {
        if(self.fs == nil){
            return false;
        }
        let fs = self.fs;
        fs!.modifyEquipStatus(key, status: status);
        return writeInfoToFile(fs!);
    }
 
    func modifyImageStatusInFile(_ equipkey:String, imageIndex:Int, status:Int) -> Bool{
        if(self.fs == nil){
            return false;
        }
        let fs = self.fs;
        fs!.modifyImageStatus(equipkey, imageIndex: imageIndex, status: status);
        return writeInfoToFile(fs!);
    }
    
    func modifyImageIDFromFile(_ equipkey: String, imageIndex: Int, id: Int) -> Bool {
        if(self.fs == nil){
            return false;
        }
        let fs = self.fs;
        fs!.modifyImageID(equipkey, imageIndex: imageIndex, id: id);
        return writeInfoToFile(fs!);
    }
    
   
    func getFileSystemFromFile()->FileSystem?{
        return self.fs;
    }
    
    //MARK:-getEquip
    
    
    func getSpecKey(_ key:String,value:AnyObject)->String{
        if(self.fs == nil){
            return "";
        }
        return self.fs!.getSpecKey(key, value: value);
    }
    
    func getEquipStatusFromFile(_ key:String) -> Int {
        if(self.fs == nil){
            return 0;
        }
        return self.fs!.getEquipStatus(key);
    }
    
  
    func getEquipFilePathFromFile(_ key:String) -> URL? {
        if(self.fs == nil){
            return nil;
        }
        let url:URL = getEquipPath().appendingPathComponent(self.fs!.getEquipPath(key).path);
        return url;
    }
    
  
    func getEquipDict()->NSMutableDictionary?{
        if(self.fs == nil){
            return nil;
        }
        return self.fs!.equipDict.subject.mutableCopy() as? NSMutableDictionary;
    }
    
  
    func getEquipFromFile(_ key:String)->NSMutableDictionary?{
        if(self.fs == nil){
            return nil;
        }
        return self.fs!.getEquip(key);
    }
    
    func getEquipParentIdFromFile(_ key: String) -> Int {
        if(self.fs == nil){
            return 0;
        }
        return fs!.getEquipParentID(key);
    }
    
    func getEquipGroupIdFromFile(_ key: String) -> Int {
        if(self.fs == nil){
            return 0;
        }
        return fs!.getEquipGroupID(key);
    }
    
    func getEquipXMLIDFromFile(_ key: String) -> Int {
        if(self.fs == nil){
            return 0;
        }
        return fs!.getEquipXMLID(key);
    }
    
    func getEquipNameFromFile(_ key: String) -> String {
        if(self.fs == nil){
            return "";
        }
        return fs!.getEquipName(key);
    }
    
    func getEquipData(_ key: String) -> Data {
        if(FileManager.default.fileExists(atPath: self.getEquipFilePathFromFile(key)!.path)){
            return (try! Data(contentsOf: self.getEquipFilePathFromFile(key)!))
        }
        return Data();
    }
    
    //MARK:- getImage
    func isMainImageFromFile(_ equipkey: String, imageIndex: Int) -> Bool {
        if(self.fs == nil){
            return false;
        }
        return fs!.isMainImage(equipkey, imageIndex: imageIndex);
    }
    func getImageStatusFromFile(_ equipkey:String, imageIndex:Int) -> Int {
        if(self.fs == nil){
            return 0;
        }
        return self.fs!.getImageStatus(equipkey, imageIndex: imageIndex);
    }
    
    func setMainImageFromFile(_ equipkey: String, imageIndex: Int) -> Bool {
        if(self.fs == nil){
            return false;
        }
        let fs = self.fs;
        _ = fs!.setMainImage(equipkey
            , imageIndex: imageIndex);
        return writeInfoToFile(fs!);
        
    }
    
    func resetMainImageFromFile(_ equipkey: String, imageIndex: Int) -> Bool {
        if(self.fs == nil){
            return false;
        }
        let fs = self.fs;
        _ = fs!.resetMainImage(equipkey, imageIndex: imageIndex);
        return writeInfoToFile(fs!);
        
    }
    
    func getImageIDFromFile(_ equipkey: String, imageIndex: Int) -> Int {
        if(self.fs == nil){
            return 0;
        }
        if imageIndex >= 0 && imageIndex < self.getImageCountFromFile(equipkey) {
            return fs!.getImageID(equipkey, imageIndex: imageIndex);
        }
        
        return 0;
    }
    
    func getImageNameFromFile(_ equipkey: String, imageIndex: Int) -> String {
        if(self.fs == nil){
            return "";
        }
        
        if imageIndex >= 0 && imageIndex < self.getImageCountFromFile(equipkey) {
            return fs!.getImageName(equipkey, imageIndex: imageIndex);
        }
        
        return "";
    }
    
    func getImageFromFile(_ equipkey: String, imageIndex: Int) -> NSMutableDictionary? {
        if(self.fs == nil){
            return nil;
        }
        return self.fs?.getImage(equipkey, imageIndex: imageIndex);
    }
    
   
    func getImageFilePathFromFile(_ equipkey:String, imageIndex:Int) -> URL?{
        if(self.fs == nil){
            return nil;
        }
        if(self.fs!.getImagePath(equipkey,imageIndex: imageIndex) == nil){
            return nil;
        }
        let url:URL = getEquipPath().appendingPathComponent(self.fs!.getImagePath(equipkey,imageIndex: imageIndex)!.path);
        return url;
    }
    
    func getImageCountFromFile(_ key: String) -> Int {
        if(self.fs == nil){
            return 0;
        }
        return self.fs!.getImageCount(key);
    }
    
    func getImageData(_ equipkey: String, imageIndex: Int) -> Data {
        if self.getImageFilePathFromFile(equipkey, imageIndex: imageIndex) == nil {
            return Data();
        }
        if(FileManager.default.fileExists(atPath: self.getImageFilePathFromFile(equipkey, imageIndex: imageIndex)!.path)){
            return (try! Data(contentsOf: self.getImageFilePathFromFile(equipkey, imageIndex: imageIndex)!))
        }
        return Data();
    }
    
   
    func checkForEquipAssociationFile()->Bool{
        do{
            if(!FileManager.default.fileExists(atPath: getEquipInfoDictFilePath().path) || !FileManager.default.fileExists(atPath: getEquipInfoOrderFilePath().path)){
                try FileManager.default.createDirectory(atPath: getEquipInfoPath().path, withIntermediateDirectories: true, attributes: nil);
                _ = createEmptyDictFile(getEquipInfoDictFilePath());
                _ = createEmptyArrayFile(getEquipInfoOrderFilePath());
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
 
    func interactEquipWithNet(){
        if(self.fs == nil){
            _ = self.checkForEquipAssociationFile();
        }
        let deleteEquipList: NSMutableArray = NSMutableArray();
        for key in self.fs!.attrKey.subject {
            var keyString = key as! String;
            if(!(self.getEquipStatusFromFile(keyString) & FileSystem.Status.download.rawValue > 0)){
                _ = NetworkOperation.sharedInstance().downloadResource(self.getEquipXMLIDFromFile(keyString), url: self.getEquipFilePathFromFile(keyString)!){ (any) in
                    if(FileManager.default.fileExists(atPath: self.getEquipFilePathFromFile(keyString)!.path)){
                        if(self.modifyEquipStatusInFile(keyString, status: FileSystem.Status.download.rawValue|self.getEquipStatusFromFile(keyString))){
                            print("\(self.getEquipNameFromFile(keyString)): download complete!");
                        }else{
                            print("\(self.getEquipNameFromFile(keyString)): error download status change!");
                        }
                    }else{
                        print("download error!");
                    }
                }
                //download
            }
            if(self.getEquipStatusFromFile(keyString) & FileSystem.Status.modifty.rawValue > 0){
                _ = NetworkOperation.sharedInstance().deleteResource(self.getEquipXMLIDFromFile(keyString)){
                    (any) in
                    _ = NetworkOperation.sharedInstance().uploadResourceReturnId(self.getEquipGroupIdFromFile(keyString), parentID: self.getEquipParentIdFromFile(keyString), fileURL: self.getEquipFilePathFromFile(keyString)!, fileName: self.getEquipNameFromFile(keyString)){(any) in
                        let newFile:NSDictionary = (any.object(forKey: NetworkOperation.NetConstant.DictKey.UploadResourceReturnId.Response.file) as! Array<NSDictionary>)[0];
                        let newid:Int = newFile.object(forKey: NetworkOperation.NetConstant.DictKey.UploadResourceReturnId.Response.FileKey.id) as! Int;
                        let oldPath = self.getEquipFilePathFromFile(keyString)!;
                        _ = self.modifyXMLIDInFile(keyString, id: newid);
                        let newPath = self.getEquipFilePathFromFile(keyString)!;
                        do{
                            try FileManager.default.moveItem(atPath: oldPath.path, toPath: newPath.path);
                            _ = self.modifyEquipStatusInFile(keyString, status: self.getEquipStatusFromFile(keyString) & ~FileSystem.Status.modifty.rawValue);
                        }catch{
                            print(error);
                        }
                    }
                }
                //modify
            }
            if(self.getEquipStatusFromFile(keyString) & FileSystem.Status.delete.rawValue > 0){
                _ = NetworkOperation.sharedInstance().deleteResource(self.getEquipXMLIDFromFile(keyString)){ (any) in
                    do{
                        try FileManager.default.removeItem(atPath: self.getEquipFilePathFromFile(keyString)!.deletingLastPathComponent().path);
                    }catch{
                        print(error);
                    }
                }
                deleteEquipList.add(keyString);
                //delete
            }
            if(self.getEquipStatusFromFile(keyString) & FileSystem.Status.new.rawValue > 0){
                _ = NetworkOperation.sharedInstance().createDir(self.getEquipGroupIdFromFile(keyString), name: (self.getEquipNameFromFile(keyString) as NSString).deletingPathExtension, parentID: EquipManager.sharedInstance().rootId){(any) in
                    let dirID = any.object(forKey: NetworkOperation.NetConstant.DictKey.CreateDir.Response.id) as! Int;
                    _ = self.modifyParentIDInFile(keyString, parentId: dirID);
                    keyString = "\(dirID)";
                    _ = NetworkOperation.sharedInstance().uploadResourceReturnId(self.getEquipGroupIdFromFile(keyString), parentID: self.getEquipParentIdFromFile(keyString), fileURL: self.getEquipFilePathFromFile(keyString)!, fileName: self.getEquipNameFromFile(keyString)){(any) in
                        let newFile:NSDictionary = (any.object(forKey: NetworkOperation.NetConstant.DictKey.UploadResourceReturnId.Response.file)! as AnyObject).firstObject as! NSDictionary;
                        let newid:Int = newFile.object(forKey: NetworkOperation.NetConstant.DictKey.UploadResourceReturnId.Response.FileKey.id) as! Int;
                        let oldPath = self.getEquipFilePathFromFile(keyString)!;
                        _ = self.modifyXMLIDInFile(keyString, id: newid);
                        let newPath = self.getEquipFilePathFromFile(keyString)!;
                        do{
                            try FileManager.default.moveItem(atPath: oldPath.path, toPath: newPath.path);
                            _ = self.modifyEquipStatusInFile(keyString, status: self.getEquipStatusFromFile(keyString) & ~FileSystem.Status.new.rawValue)
                        }catch{
                            print(error);
                        }
                    }
                }
                //new
                
            }
            let deleteImageList:NSMutableArray = NSMutableArray();
            for imageIndex in stride(from: 0, to: getImageCountFromFile(keyString), by: 1){
                if(self.isMainImageFromFile(keyString, imageIndex: imageIndex)){
                    if(!(self.getImageStatusFromFile(keyString, imageIndex: imageIndex) & FileSystem.Status.download.rawValue > 0)){
                        let imageID = self.getImageIDFromFile(keyString, imageIndex: imageIndex);
                        _ = NetworkOperation.sharedInstance().getThumbnail(imageID, handler: { (any) in
                            do{
                                let url = self.getImageFilePathFromFile(keyString, imageIndex: imageIndex)!;
                                if(!FileManager.default.fileExists(atPath: url.deletingLastPathComponent().path)){
                                    try FileManager.default.createDirectory(atPath: url.deletingLastPathComponent().path, withIntermediateDirectories: true, attributes: nil);
                                }
                                
                                _ = any!.write(toFile: url.path, atomically: true);
                                _ = self.modifyImageStatusInFile(keyString, imageIndex: imageIndex, status: self.getImageStatusFromFile(keyString, imageIndex: imageIndex) | FileSystem.Status.download.rawValue);
                            }catch{
                                print(error);
                            }
                        })
                    }
                    //Main
                }
                if(self.getImageStatusFromFile(keyString, imageIndex: imageIndex) & FileSystem.Status.modifty.rawValue > 0){
                    _ = NetworkOperation.sharedInstance().modifyResource(self.getImageIDFromFile(keyString, imageIndex: imageIndex), name: (self.getImageNameFromFile(keyString, imageIndex: imageIndex) as NSString).deletingPathExtension){ (any) in
                        _ = self.modifyImageStatusInFile(keyString, imageIndex: imageIndex, status: self.getImageStatusFromFile(keyString, imageIndex: imageIndex) & ~FileSystem.Status.modifty.rawValue);
                    }
                    //modify
                }
                if(self.getImageStatusFromFile(keyString, imageIndex: imageIndex) & FileSystem.Status.delete.rawValue > 0){
                    _ = NetworkOperation.sharedInstance().deleteResource(self.getImageIDFromFile(keyString, imageIndex: imageIndex)){(any) in
                        print(any);
                    }
                    deleteImageList.add(self.getImageFromFile(keyString, imageIndex: imageIndex)!);
                    //delete
                }
                if(!(self.getImageStatusFromFile(keyString, imageIndex: imageIndex) & FileSystem.Status.download.rawValue > 0)){
                    //download
                }
                if(self.getImageStatusFromFile(keyString, imageIndex: imageIndex) & FileSystem.Status.new.rawValue > 0) {
                    _ = NetworkOperation.sharedInstance().uploadResourceReturnId(self.getEquipGroupIdFromFile(keyString), parentID: self.getEquipParentIdFromFile(keyString), fileURL: self.getImageFilePathFromFile(keyString, imageIndex: imageIndex)!, fileName: self.getImageNameFromFile(keyString, imageIndex: imageIndex)){(any) in
                        print(any)
                        let newFile:NSDictionary = (any.object(forKey: NetworkOperation.NetConstant.DictKey.UploadResourceReturnId.Response.file) as! NSArray).firstObject as! NSDictionary;
                        
                        let newid:Int = newFile.object(forKey: NetworkOperation.NetConstant.DictKey.UploadResourceReturnId.Response.FileKey.id) as! Int;
                        let oldPath = self.getImageFilePathFromFile(keyString, imageIndex: imageIndex)!;
                        _ = self.modifyImageIDFromFile(keyString, imageIndex: imageIndex, id: newid);
                        let newPath = self.getImageFilePathFromFile(keyString, imageIndex: imageIndex)!;
                        do{
                            try FileManager.default.moveItem(atPath: oldPath.path, toPath: newPath.path);
                            _ = self.modifyEquipStatusInFile(keyString, status: self.getEquipStatusFromFile(keyString) & ~FileSystem.Status.new.rawValue)
                        }catch{
                            print(error);
                        }
                    }
                    //new
                }
                
                
            }
            for tmp in deleteImageList {
                _ = self.deleteImageFromFile(keyString, image: tmp as! NSMutableDictionary);
            }
        }
        for tmp in deleteEquipList {
            _ = self.deleteEquipFromFile(tmp as! String);
        }
    }
 
    func downloadEquipImageFromNet(_ key:String) {
        if(fs == nil){
            return ;
        }
        let waitList: MySafeMutableMethod = MySafeMutableMethod<Array<GCDSemaphore>>(subject: Array<GCDSemaphore>());
        for imageIndex in 0..<fs!.getImageCount(key){
            let imageID = fs!.getImageID(key, imageIndex: imageIndex);
            let imageStatus = fs!.getImageStatus(key, imageIndex: imageIndex);
            if(!FileManager.default.fileExists(atPath: self.getImageFilePathFromFile(key, imageIndex: imageIndex)!.path)){
                let sema = NetworkOperation.sharedInstance().getThumbnail(imageID, handler: { (any) in
                    do{
                        let url = self.getImageFilePathFromFile(key, imageIndex: imageIndex)!;
                        if(!FileManager.default.fileExists(atPath: url.deletingLastPathComponent().path)){
                            try FileManager.default.createDirectory(atPath: url.deletingLastPathComponent().path, withIntermediateDirectories: true, attributes: nil);
                        }
                        _ = any!.write(toFile: url.path, atomically: true);
                        _ = self.modifyImageStatusInFile(key, imageIndex: imageIndex, status: imageStatus | FileSystem.Status.download.rawValue);
                    }catch{
                        print(error);
                    }
                });
                waitList.writeRequest();
                waitList.subject.append(sema);
                waitList.writeEnd();
            }
        }
        for i in waitList.subject {
            _ = i.lock();
        }
    }
 
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
