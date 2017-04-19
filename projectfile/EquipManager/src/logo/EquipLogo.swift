//
//  EquipLogo.swift
//  EquipManager
//
//  Created by 李呱呱 on 2016/10/2.
//  Copyright © 2016年 liguagua. All rights reserved.
//

import UIKit

class EquipLogo {
    
    var logoDict:NSMutableDictionary{
        get{
            return self.read().0;
        }
    };
    var key: NSMutableArray{
        get{
            return self.read().1;
        }
    }
    
    let download:MySafeMutableMethod<Int>
    
    var defaultFolderUrl:URL;
    var defaultKeyName:String;
    var defaultDataName:String;
    let MAINLOGO:String = "main";
    fileprivate static let _sharedInstance = EquipLogo();
    
    class func sharedInstance() -> EquipLogo{
        return _sharedInstance;
    }
    
    private init(){
        defaultFolderUrl = EquipFileControl.sharedInstance().getEquipAssociationPath().appendingPathComponent("Logo");
        defaultKeyName = "logo.key";
        defaultDataName = "logo.data";
        download = MySafeMutableMethod(subject: 0)
    }
    
    func getRandomID() -> String {
        let time = Date();
        let timeFormatter = DateFormatter();
        timeFormatter.dateFormat = "yyyyMMddHHmmss";
        return "\(timeFormatter.string(from: time))";
    }
    
    func read() -> (NSMutableDictionary,NSMutableArray) {
        let dataUrl = defaultFolderUrl.appendingPathComponent(defaultDataName);
        let keyUrl = defaultFolderUrl.appendingPathComponent(defaultKeyName);
        if !FileManager.default.fileExists(atPath: dataUrl.path) {
            try! FileManager.default.createDirectory(at: defaultFolderUrl, withIntermediateDirectories: true, attributes: nil);
            let empty: NSMutableDictionary = NSMutableDictionary();
            empty.write(toFile: dataUrl.path, atomically: true);
        }
        if !FileManager.default.fileExists(atPath: keyUrl.path) {
            try!FileManager.default.createDirectory(at: defaultFolderUrl, withIntermediateDirectories: true, attributes: nil);
            let empty: NSMutableArray = NSMutableArray();
            empty.write(toFile: keyUrl.path, atomically: true);
        }
        let dict: NSMutableDictionary = NSMutableDictionary(contentsOfFile: dataUrl.path)!;
        let key: NSMutableArray = NSMutableArray(contentsOfFile: keyUrl.path)!;
        
        return (dict,key);
    }
    
    func write(dict: NSMutableDictionary, key: NSMutableArray) {
        let dataUrl = defaultFolderUrl.appendingPathComponent(defaultDataName);
        let keyUrl = defaultFolderUrl.appendingPathComponent(defaultKeyName);
        if !FileManager.default.fileExists(atPath: dataUrl.path) {
            try! FileManager.default.createDirectory(at: defaultFolderUrl, withIntermediateDirectories: true, attributes: nil);
        }
        if !FileManager.default.fileExists(atPath: keyUrl.path) {
            try! FileManager.default.createDirectory(at: defaultFolderUrl, withIntermediateDirectories: true, attributes: nil);
        }
        dict.write(toFile: dataUrl.path, atomically: true);
        key.write(toFile: keyUrl.path, atomically: true);
    }
    
    func addLogo(image: UIImage, name:String = "") -> String {
        var nameTmp = name;
        if nameTmp == "" {
            nameTmp = "\(getRandomID()).png";
        }
        let dict = self.logoDict;
        let key = self.key;
        let data: Data = UIImagePNGRepresentation(image)!;
        dict.setValue(data, forKey: nameTmp);
        key.add(nameTmp);
        self.write(dict: dict, key: key);
        return nameTmp;
    }
    
    func setLogo(name: String) {
        let dict = self.logoDict;
        dict.setValue(name, forKey: MAINLOGO);
        self.write(dict: dict, key: self.key);
    }
    //jingmaixm
    //景迈小苗-FZ
    //
    
    func getLogo() -> UIImage {
        if !self.logoDict.allKeys.contains(where: {return ($0 as! String) == MAINLOGO}){
            return UIImage(named: "white.jpg")!;
        }
        let name: String = self.logoDict.value(forKey: MAINLOGO) as! String;
        let data: Data = self.logoDict.value(forKey: name) as! Data;
        let image: UIImage = UIImage(data: data)!;
        return image;
    }
    
    func getLogoList() -> [UIImage] {
        if self.logoDict.allKeys.count == 0 {
            return [];
        }
        var rtn: Array<UIImage> = Array();
        for key in self.key{
            let image: UIImage = UIImage(data: self.logoDict.value(forKey: key as! String) as! Data)!;
            rtn.append(image);
        }
        return rtn;
        
    }
    //上传logo
    func updateToNet(){
        let dataUrl = defaultFolderUrl.appendingPathComponent(defaultDataName);
        let keyUrl = defaultFolderUrl.appendingPathComponent(defaultKeyName);
        _ = NetworkOperation.sharedInstance().getResources(EquipManager.sharedInstance().rootId, handler: { (any) in
            //11.18 cut
        })
        _ = NetworkOperation.sharedInstance().uploadResource(EquipManager.sharedInstance().defaultGroupId, parentID: EquipManager.sharedInstance().defaultLogoID, fileURL: dataUrl, fileName: defaultDataName) { (any) in
        }
        _ = NetworkOperation.sharedInstance().uploadResource(EquipManager.sharedInstance().defaultGroupId, parentID: EquipManager.sharedInstance().defaultLogoID, fileURL: keyUrl, fileName: defaultKeyName, handler: { (any) in
        })
    }
    //从网络端更新
    func updateFromNet(){
        let dataUrl = defaultFolderUrl.appendingPathComponent(defaultDataName);
        let keyUrl = defaultFolderUrl.appendingPathComponent(defaultKeyName);
        if FileManager.default.fileExists(atPath: dataUrl.path) {
            try! FileManager.default.removeItem(at: dataUrl)
        }
        if FileManager.default.fileExists(atPath: keyUrl.path) {
            try! FileManager.default.removeItem(at: keyUrl)
        }
        _ = NetworkOperation.sharedInstance().getResources(EquipManager.sharedInstance().defaultLogoID, handler: { (any) in
            let resources = (any as! NSDictionary).value(forKey: NetworkOperation.NetConstant.DictKey.GetResources.Response.resources) as! NSArray
            for resource in resources {
                let r = resource as! NSDictionary
                let name = r.value(forKey: NetworkOperation.NetConstant.DictKey.GetResources.Response.ResourcesKey.name) as! String
                if (name == self.defaultDataName){
                    let id = r.value(forKey: NetworkOperation.NetConstant.DictKey.GetResources.Response.ResourcesKey.id) as! Int
                    _ = NetworkOperation.sharedInstance().downloadResource(id, url: dataUrl, handler: { (any) in
                    })
                }
                if (name == self.defaultKeyName){
                    let id = r.value(forKey: NetworkOperation.NetConstant.DictKey.GetResources.Response.ResourcesKey.id) as! Int
                    _ = NetworkOperation.sharedInstance().downloadResource(id, url: keyUrl, handler: { (any) in
                    })
                }

            }
        })
    }
    
}
//data
//control
