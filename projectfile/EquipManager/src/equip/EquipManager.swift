//
//  EquipManager.swift
//  EquipManager
//
//  Created by 李呱呱 on 16/8/11.
//  Copyright © 2016年 LY. All rights reserved.
//

import UIKit

class EquipManager:NSObject{
    var timer:NSTimer?;
    
    var rootId:Int = 0{
        didSet{
            if(rootId != 0){
                initWithLocal();
                initWithNet();
                timer = NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: #selector(EquipManager.combine), userInfo: nil, repeats: true);
            }
        }
    };
    
    var defaultGroupId:Int = 1069;
    private static var _sharedInstance:EquipManager = EquipManager(rootId: 0);
    //根据rootID初始化
    init(rootId:Int){
        super.init();
        self.rootId = rootId;
    }
    //单例模式
    class func sharedInstance(rootId:Int) -> EquipManager{
        _sharedInstance.rootId = rootId;
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
        if(EquipNetInfo.sharedInstance().isReadFromNetComplete){
            func dictionIsEqual(dict1:NSMutableDictionary, dict2:NSMutableDictionary, key:NSString)->Bool{
                return dict1.objectForKey(key)!.isEqual(dict2.objectForKey(key));
            }
            //添加服务器有本地没有的文件节点，并处理所有设备的图片节点（图片路径和图片名字）
            let tmpList:NSMutableArray = NSMutableArray();
            for s in 0.stride(to: EquipNetInfo.sharedInstance().count, by: 1){
                let server = EquipNetInfo.sharedInstance().fs.getEquip(s)!;
                var matchFlag = false;
                for l in 0.stride(to: EquipFileControl.sharedInstance().count, by: 1){
                    let local = EquipFileControl.sharedInstance().getEquipFromFile(l)!;
                    if(dictionIsEqual(local, dict2: server, key: FileSystem.equipKey.XMLID)){
                        matchFlag = true;
                        let imageList:NSMutableArray = NSMutableArray();
                        for si in 0.stride(to: EquipNetInfo.sharedInstance().fs.getImageCount(s), by: 1){
                            let serverImageSet = EquipNetInfo.sharedInstance().fs.getImage(s, imageIndex: si)!;
                            var matchFlag2 = false;
                            for li in 0.stride(to: EquipFileControl.sharedInstance().fs!.getImageCount(l), by: 1){
                                let localImageSet = EquipFileControl.sharedInstance().fs!.getImage(l, imageIndex: li)!;
                                if(dictionIsEqual(serverImageSet, dict2: localImageSet, key: FileSystem.imageSetKey.imageID)){
                                    matchFlag2 = true;
                                    if(!dictionIsEqual(serverImageSet, dict2: localImageSet, key: FileSystem.imageSetKey.imageName)){
                                        if((EquipFileControl.sharedInstance().getImageStatusFromFile(l, imageIndex: li) & FileSystem.Status.Modifty.rawValue) > 0){
                                            EquipFileControl.sharedInstance().modifyImageNameInFile(l, imageIndex: li, name: serverImageSet.objectForKey(FileSystem.imageSetKey.imageName) as! NSString);
                                        }
                                    }
                                    break;
                                }
                            }
                            if(!matchFlag2){
                                imageList.addObject(serverImageSet);
                            }
                        }
                        for tmp in imageList {
                            EquipFileControl.sharedInstance().addImageInfoToFile(l, imageID: tmp.objectForKey(FileSystem.imageSetKey.imageID) as! Int, imagePath: tmp.objectForKey(FileSystem.imageSetKey.imagePath) as! NSString, imageName: tmp.objectForKey(FileSystem.imageSetKey.imageName) as! NSString);
                        }
                        break;
                    }
                }
                if(!matchFlag){
                    tmpList.addObject(server);
                }
            }
            for tmp in tmpList {
                let equip:NSMutableDictionary = tmp as! NSMutableDictionary;
                EquipFileControl.sharedInstance().addEquipInfoToFile(equip.objectForKey(FileSystem.equipKey.parentID) as! Int, XMLID: equip.objectForKey(FileSystem.equipKey.XMLID) as! Int, XMLName: equip.objectForKey(FileSystem.equipKey.XMLName) as! NSString, imageSet: equip.objectForKey(FileSystem.equipKey.imageSet) as! NSMutableArray, path: equip.objectForKey(FileSystem.equipKey.path) as! NSString, groupID: equip.objectForKey(FileSystem.equipKey.groupID) as! Int)
            }
            tmpList.removeAllObjects();
            //删去不是new的服务器没有的节点（暂时不考虑安卓的操作和人为的网页删除）
            for l in 0.stride(to: EquipFileControl.sharedInstance().count, by: 1) {
                var matchFlag = false;
                for s in 0.stride(to: EquipNetInfo.sharedInstance().count, by: 1) {
                    if(dictionIsEqual(EquipFileControl.sharedInstance().getEquipFromFile(l)!, dict2: EquipNetInfo.sharedInstance().fs.getEquip(s)!, key: FileSystem.equipKey.XMLID)){
                        matchFlag = true;
                        let imageList:NSMutableArray = NSMutableArray();
                        for li in 0.stride(to: EquipFileControl.sharedInstance().getImageCountFromFile(l), by: 1) {
                            var matchFlag2 = false;
                            for si in 0.stride(to: EquipNetInfo.sharedInstance().fs.getImageCount(s), by: 1) {
                                if(dictionIsEqual(EquipFileControl.sharedInstance().getImageFromFile(l, imageIndex: li)!, dict2: EquipNetInfo.sharedInstance().fs.getImage(s, imageIndex: si)!, key: FileSystem.imageSetKey.imageID)){
                                    matchFlag2 = true
                                    break;
                                }
                            }
                            if(!matchFlag2){
                                if(EquipFileControl.sharedInstance().getImageStatusFromFile(l, imageIndex: li) & FileSystem.Status.New.rawValue == 0){
                                    imageList.addObject(EquipFileControl.sharedInstance().getImageFromFile(l, imageIndex: li)!);
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
                    if(EquipFileControl.sharedInstance().getEquipStatusFromFile(l) & FileSystem.Status.New.rawValue == 0){
                        tmpList.addObject(EquipFileControl.sharedInstance().getEquipFromFile(l)!);
                    }
                }
            }
            for tmp in tmpList {
                EquipFileControl.sharedInstance().deleteEquipFromFile(tmp as! NSMutableDictionary);
            }
            //进行节点操作
            EquipFileControl.sharedInstance().interactEquipWithNet();
            
            if(timer != nil){
                timer?.invalidate();
                timer = nil;
            }
        }
    }
    
}