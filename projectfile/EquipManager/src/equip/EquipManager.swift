//
//  EquipManager.swift
//  EquipManager
//
//  Created by 李呱呱 on 16/8/11.
//  Copyright © 2016年 liguagua. All rights reserved.
//

import UIKit

class EquipManager:NSObject{
    
    var rootId:Int = 0
    
    var defaultGroupId:Int = 1069
    //回收站文件夹
    var defaultTrashId:Int = 0
    //系统Logo文件夹
    var defaultLogoID:Int = 0
    
    fileprivate static let _sharedInstance:EquipManager = EquipManager(rootId: 0);
   
    init(rootId:Int){
        super.init();
        self.rootId = rootId;
    }
  
    class func sharedInstance(_ rootId:Int) -> EquipManager{
        _sharedInstance.rootId = rootId;
        return _sharedInstance;
    }
    
    class func sharedInstance()->EquipManager{
        return _sharedInstance;
    }
    
    func update() {
        initWithLocal();
        initWithNet();
        combine();
    }
    
  
    func initWithLocal(){
    }
    
   
    func initWithNet(){
        EquipNetInfo.sharedInstance().readFromNet(rootId);
    }
    
    //pipe
    //将本地和服务器节点合并
    func combine(){
        func dictionIsEqual(_ dict1:NSMutableDictionary, dict2:NSMutableDictionary, key:NSString)->Bool{
            return (dict1.object(forKey: key)! as AnyObject).isEqual(dict2.object(forKey: key));
        }
        //添加服务器有本地没有的文件节点，并处理所有设备的图片节点（图片路径和图片名字）
        let tmpList:NSMutableArray = NSMutableArray();
        for s in EquipNetInfo.sharedInstance().fs.attrKey.subject{
            let server = EquipNetInfo.sharedInstance().fs.getEquip(s as! String)!;
            var matchFlag = false;
            for l in EquipFileControl.sharedInstance().getFileSystemFromFile()!.attrKey.subject{
                let local = EquipFileControl.sharedInstance().getEquipFromFile(l as! String)!;
                if(dictionIsEqual(local, dict2: server, key: FileSystem.equipKey.XMLID as NSString)){
                    matchFlag = true;
                    let imageList:NSMutableArray = NSMutableArray();
                    for si in stride(from: 0, to: EquipNetInfo.sharedInstance().fs.getImageCount(s as! String), by: 1){
                        let serverImageSet = EquipNetInfo.sharedInstance().fs.getImage(s as! String, imageIndex: si)!;
                        var matchFlag2 = false;
                        for li in stride(from: 0, to: EquipFileControl.sharedInstance().fs!.getImageCount(l as! String), by: 1){
                            let localImageSet = EquipFileControl.sharedInstance().fs!.getImage(l as! String, imageIndex: li)!;
                            if(dictionIsEqual(serverImageSet, dict2: localImageSet, key: FileSystem.imageSetKey.imageID as NSString)){
                                matchFlag2 = true;
                                if(!dictionIsEqual(serverImageSet, dict2: localImageSet, key: FileSystem.imageSetKey.imageName as NSString)){
                                    if((EquipFileControl.sharedInstance().getImageStatusFromFile(l as! String, imageIndex: li) & FileSystem.Status.modifty.rawValue) == 0){
                                        _ = EquipFileControl.sharedInstance().modifyImageNameInFile(l as! String, imageIndex: li, name: serverImageSet.object(forKey: FileSystem.imageSetKey.imageName) as! String);
                                    }
                                }
                                break;
                            }
                        }
                        if(!matchFlag2){
                            imageList.add(serverImageSet);
                        }
                    }
                    for tmp in imageList {
                        _ = EquipFileControl.sharedInstance().addImageInfoToFile(l as! String, imageID: (tmp as AnyObject).object(forKey: FileSystem.imageSetKey.imageID) as! Int, imagePath: (tmp as AnyObject).object(forKey: FileSystem.imageSetKey.imagePath) as! String, imageName: (tmp as AnyObject).object(forKey: FileSystem.imageSetKey.imageName) as! String);
                    }
                    break;
                }
            }
            if(!matchFlag){
                tmpList.add(server);
            }
        }
        for tmp in tmpList {
            let equip:NSMutableDictionary = tmp as! NSMutableDictionary;
            _ = EquipFileControl.sharedInstance().addEquipInfoToFile(equip.object(forKey: FileSystem.equipKey.parentID) as! Int, XMLID: equip.object(forKey: FileSystem.equipKey.XMLID) as! Int, XMLName: equip.object(forKey: FileSystem.equipKey.XMLName) as! String, imageSet: equip.object(forKey: FileSystem.equipKey.imageSet) as! NSMutableArray, path: equip.object(forKey: FileSystem.equipKey.path) as! String, groupID: equip.object(forKey: FileSystem.equipKey.groupID) as! Int)
        }
        tmpList.removeAllObjects();
        //删去不是new的服务器没有的节点（暂时不考虑安卓的操作和人为的网页删除）
        for l in EquipFileControl.sharedInstance().getFileSystemFromFile()!.attrKey.subject {
            var matchFlag = false;
            for s in EquipNetInfo.sharedInstance().fs.attrKey.subject {
                if(dictionIsEqual(EquipFileControl.sharedInstance().getEquipFromFile(l as! String)!, dict2: EquipNetInfo.sharedInstance().fs.getEquip(s as! String)!, key: FileSystem.equipKey.XMLID as NSString)){
                    matchFlag = true;
                    let imageList:NSMutableArray = NSMutableArray();
                    for li in stride(from: 0, to: EquipFileControl.sharedInstance().getImageCountFromFile(l as! String), by: 1) {
                        var matchFlag2 = false;
                        for si in stride(from: 0, to: EquipNetInfo.sharedInstance().fs.getImageCount(s as! String), by: 1) {
                            if(dictionIsEqual(EquipFileControl.sharedInstance().getImageFromFile(l as! String, imageIndex: li)!, dict2: EquipNetInfo.sharedInstance().fs.getImage(s as! String, imageIndex: si)!, key: FileSystem.imageSetKey.imageID as NSString)){
                                matchFlag2 = true
                                break;
                            }
                        }
                        if(!matchFlag2){
                            if(EquipFileControl.sharedInstance().getImageStatusFromFile(l as! String, imageIndex: li) & FileSystem.Status.new.rawValue == 0){
                                imageList.add(EquipFileControl.sharedInstance().getImageFromFile(l as! String, imageIndex: li)!);
                            }
                        }
                    }
                    for tmp in imageList {
                        _ = EquipFileControl.sharedInstance().deleteImageFromFile(l as! String, image: tmp as! NSMutableDictionary);
                    }
                    break;
                }
            }
            if(!matchFlag){
                if(EquipFileControl.sharedInstance().getEquipStatusFromFile(l as! String) & FileSystem.Status.new.rawValue == 0){
                    tmpList.add(l);
                }
            }
        }
        for tmp in tmpList {
            _ = EquipFileControl.sharedInstance().deleteEquipFromFile(tmp as! String);
        }
        //进行节点操作
        EquipFileControl.sharedInstance().interactEquipWithNet();
    }
    
}
