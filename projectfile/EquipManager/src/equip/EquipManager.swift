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
                timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(EquipManager.combine), userInfo: nil, repeats: true);
            }
        }
    };
    private static var _sharedInstance:EquipManager = EquipManager(rootId: 0);
    
    init(rootId:Int){
        super.init();
        self.rootId = rootId;
    }
    
    class func sharedInstance(rootId:Int) -> EquipManager{
        _sharedInstance.rootId = rootId;
        return _sharedInstance;
    }
    
    //local
    func initWithLocal(){
    }
    
    //net
    func initWithNet(){
        EquipNetInfo.sharedInstance().readFromNet(rootId);
    }
    
    //pipe
    func combine(){
        if(EquipNetInfo.sharedInstance().isReadFromNetComplete){
            func dictionIsEqual(dict1:NSMutableDictionary, dict2:NSMutableDictionary, key:NSString)->Bool{
                return dict1.objectForKey(key)!.isEqual(dict2.objectForKey(key));
            }
            //添加服务器有本地没有的文件节点，并处理所有设备的图片节点（图片路径和图片名字）
            let tmpList:NSMutableArray = NSMutableArray();
            for s in 0..<EquipNetInfo.sharedInstance().count{
                let server = EquipNetInfo.sharedInstance().fs.getEquip(s)!;
                var matchFlag = false;
                for l in 0..<EquipFileControl.sharedInstance().count{
                    let local = EquipFileControl.sharedInstance().getEquipFromFile(l)!;
                    if(dictionIsEqual(local, dict2: server, key: FileSystem.equipKey.XMLID)){
                        matchFlag = true;
                        for si in 0..<server.objectForKey(FileSystem.equipKey.imageSet)!.count{
                            let serverImageSet = EquipNetInfo.sharedInstance().fs.getImage(s, imageIndex: si)!;
                            var matchFlag2 = false;
                            for li in 0..<local.objectForKey(FileSystem.equipKey.imageSet)!.count{
                                let localImageSet = EquipFileControl.sharedInstance().fs.getImage(l, imageIndex: li)!;
                                if(dictionIsEqual(serverImageSet, dict2: localImageSet, key: FileSystem.imageSetKey.imageID)){
                                    matchFlag2 = true;
                                    if(!dictionIsEqual(serverImageSet, dict2: localImageSet, key: FileSystem.imageSetKey.imageName)){
                                        EquipFileControl.sharedInstance().modifyImageNameInFile(l, imageIndex: li, name: serverImageSet.objectForKey(FileSystem.imageSetKey.imageName) as! NSString);
                                    }
                                    break;
                                }
                            }
                            if(!matchFlag2){
                                EquipFileControl.sharedInstance().addImageInfoToFile(l, imageID: serverImageSet.objectForKey(FileSystem.imageSetKey.imageID) as! Int, imagePath: serverImageSet.objectForKey(FileSystem.imageSetKey.imagePath) as! NSString, imageName: serverImageSet.objectForKey(FileSystem.imageSetKey.imageName) as! NSString);
                            }
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
            //删去不是new的服务器没有的节点（暂时不考虑安卓的操作和人为的网页删除）
            //进行节点操作
            EquipFileControl.sharedInstance().interactEquipWithNet();
            
            if(timer != nil){
                timer?.invalidate();
                timer = nil;
            }
        }
    }
    
}