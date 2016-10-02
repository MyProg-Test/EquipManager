//
//  EquipLogo.swift
//  EquipManager
//
//  Created by 李呱呱 on 2016/10/2.
//  Copyright © 2016年 LY. All rights reserved.
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
    
    func getLogo() -> UIImage {
        if !self.logoDict.allKeys.contains(where: {return ($0 as! String) == MAINLOGO}){
            return UIImage(named: "logo.png")!;
        }
        let name: String = self.logoDict.value(forKey: MAINLOGO) as! String;
        let data: Data = self.logoDict.value(forKey: name) as! Data;
        let image: UIImage = UIImage(data: data)!;
        return image;
    }
    
    func getLogoList() -> [UIImage] {
        if self.logoDict.allKeys.count == 0 {
            addLogo(image: UIImage(named: "logo.png")!);
        }
        var rtn: Array<UIImage> = Array();
        for key in self.key{
            let image: UIImage = UIImage(data: self.logoDict.value(forKey: key as! String) as! Data)!;
            rtn.append(image);
        }
        return rtn;
        
    }
    
    
}
//data
//control
