//
//  EquipManager.swift
//  EquipManager
//
//  Created by 李呱呱 on 16/8/11.
//  Copyright © 2016年 LY. All rights reserved.
//

import UIKit

class EquipManager:NSObject{
    
    var rootId:Int = 0
    
    var defaultGroupId:Int = 1069;
    fileprivate static var _sharedInstance:EquipManager = EquipManager(rootId: 0);
    //根据rootID初始化
    init(rootId:Int){
        super.init();
        self.rootId = rootId;
    }
    //单例模式
    class func sharedInstance(_ rootId:Int) -> EquipManager{
        _sharedInstance.rootId = rootId;
        _sharedInstance.initWithLocal();
        _sharedInstance.initWithNet();
        _sharedInstance.combine();
        return _sharedInstance;
    }
    
    class func sharedInstance()->EquipManager{
        return _sharedInstance;
    }
    
    //从本地更新
    func initWithLocal(){
    }
    
    //从网络端更新
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
        for s in stride(from: 0, to: EquipNetInfo.sharedInstance().count, by: 1){
            let server = EquipNetInfo.sharedInstance().fs.getEquip(s)!;
            var matchFlag = false;
            for l in stride(from: 0, to: EquipFileControl.sharedInstance().count, by: 1){
                let local = EquipFileControl.sharedInstance().getEquipFromFile(l)!;
                if(dictionIsEqual(local, dict2: server, key: FileSystem.equipKey.XMLID as NSString)){
                    matchFlag = true;
                    let imageList:NSMutableArray = NSMutableArray();
                    for si in stride(from: 0, to: EquipNetInfo.sharedInstance().fs.getImageCount(s), by: 1){
                        let serverImageSet = EquipNetInfo.sharedInstance().fs.getImage(s, imageIndex: si)!;
                        var matchFlag2 = false;
                        for li in stride(from: 0, to: EquipFileControl.sharedInstance().fs!.getImageCount(l), by: 1){
                            let localImageSet = EquipFileControl.sharedInstance().fs!.getImage(l, imageIndex: li)!;
                            if(dictionIsEqual(serverImageSet, dict2: localImageSet, key: FileSystem.imageSetKey.imageID as NSString)){
                                matchFlag2 = true;
                                if(!dictionIsEqual(serverImageSet, dict2: localImageSet, key: FileSystem.imageSetKey.imageName as NSString)){
                                    if((EquipFileControl.sharedInstance().getImageStatusFromFile(l, imageIndex: li) & FileSystem.Status.modifty.rawValue) > 0){
                                        _ = EquipFileControl.sharedInstance().modifyImageNameInFile(l, imageIndex: li, name: serverImageSet.object(forKey: FileSystem.imageSetKey.imageName) as! String);
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
                        _ = EquipFileControl.sharedInstance().addImageInfoToFile(l, imageID: (tmp as AnyObject).object(forKey: FileSystem.imageSetKey.imageID) as! Int, imagePath: (tmp as AnyObject).object(forKey: FileSystem.imageSetKey.imagePath) as! String, imageName: (tmp as AnyObject).object(forKey: FileSystem.imageSetKey.imageName) as! String);
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
        for l in stride(from: 0, to: EquipFileControl.sharedInstance().count, by: 1) {
            var matchFlag = false;
            for s in stride(from: 0, to: EquipNetInfo.sharedInstance().count, by: 1) {
                if(dictionIsEqual(EquipFileControl.sharedInstance().getEquipFromFile(l)!, dict2: EquipNetInfo.sharedInstance().fs.getEquip(s)!, key: FileSystem.equipKey.XMLID as NSString)){
                    matchFlag = true;
                    let imageList:NSMutableArray = NSMutableArray();
                    for li in stride(from: 0, to: EquipFileControl.sharedInstance().getImageCountFromFile(l), by: 1) {
                        var matchFlag2 = false;
                        for si in stride(from: 0, to: EquipNetInfo.sharedInstance().fs.getImageCount(s), by: 1) {
                            if(dictionIsEqual(EquipFileControl.sharedInstance().getImageFromFile(l, imageIndex: li)!, dict2: EquipNetInfo.sharedInstance().fs.getImage(s, imageIndex: si)!, key: FileSystem.imageSetKey.imageID as NSString)){
                                matchFlag2 = true
                                break;
                            }
                        }
                        if(!matchFlag2){
                            if(EquipFileControl.sharedInstance().getImageStatusFromFile(l, imageIndex: li) & FileSystem.Status.new.rawValue == 0){
                                imageList.add(EquipFileControl.sharedInstance().getImageFromFile(l, imageIndex: li)!);
                            }
                        }
                    }
                    for tmp in imageList {
                        EquipFileControl.sharedInstance().deleteImageFromFile(l, image: tmp as! NSMutableDictionary);
                    }
                    break;
                }
            }
            if(!matchFlag){
                if(EquipFileControl.sharedInstance().getEquipStatusFromFile(l) & FileSystem.Status.new.rawValue == 0){
                    tmpList.add(EquipFileControl.sharedInstance().getEquipFromFile(l)!);
                }
            }
        }
        for tmp in tmpList {
            EquipFileControl.sharedInstance().deleteEquipFromFile(tmp as! NSMutableDictionary);
        }
        //进行节点操作
        EquipFileControl.sharedInstance().interactEquipWithNet();
    }
    
}
