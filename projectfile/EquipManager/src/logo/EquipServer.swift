//
//  EquipLogo.swift
//  EquipManager
//
//  Created by 李呱呱 on 2016/10/2.
//  Copyright © 2016年 liguagua. All rights reserved.
//

import UIKit

class EquipServer {
    
    var serverDict:NSMutableDictionary{
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
    let MAINSERVER:String = "main";
    fileprivate static let _sharedInstance = EquipServer();
    
    class func sharedInstance() -> EquipServer{
        return _sharedInstance;
    }
    
    private init(){
        defaultFolderUrl = EquipFileControl.sharedInstance().getEquipAssociationPath().appendingPathComponent("Server");
        defaultKeyName = "server.key";
        defaultDataName = "server.data";
        
    }
    
    func getRandomID() -> String {
        let time = Date();
        let timeFormatter = DateFormatter();
        timeFormatter.dateFormat = "yyMMddHHmmss";
        let postfix = arc4random()%1000;
        return "\(timeFormatter.string(from: time))\(postfix)";
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
    
    func addServer(server: String, name:String = "") -> String {
        var nameTmp = name;
        if nameTmp == "" {
            nameTmp = "\(getRandomID())";
            nameTmp = nameTmp.replacingOccurrences(of: ".", with: "");
        }
        let dict = self.serverDict;
        let key = self.key;
        dict.setValue(server, forKey: nameTmp);
        key.add(nameTmp);
        self.write(dict: dict, key: key);
        return nameTmp;
    }
    
    func removeServer(name: String) {
        let mainServer = self.getServerName();
        let dict = self.serverDict;
        let key = self.key;
        if(name == mainServer){
            dict.removeObject(forKey: self.MAINSERVER);
        }
        dict.removeObject(forKey: name);
        key.remove(name);
        self.write(dict: dict, key: key);
    }
    
    func setServer(name: String) {
        let dict = self.serverDict;
        dict.setValue(name, forKey: MAINSERVER);
        self.write(dict: dict, key: self.key);
    }
    
    func getServerName() -> String {
        if !self.serverDict.allKeys.contains(where: {return ($0 as! String) == MAINSERVER}){
            return "ccnl";
        }
        let name: String = self.serverDict.value(forKey: MAINSERVER) as! String;
        return name;
    }
    
    func getServer() -> String {
        if !self.serverDict.allKeys.contains(where: {return ($0 as! String) == MAINSERVER}){
            return "weblib.ccnl.scut.edu.cn/"
        }
        let name: String = self.serverDict.value(forKey: MAINSERVER) as! String;
        let server: String = self.serverDict.value(forKey: name) as! String;
        return server;
    }
    
    func getServerList() -> [String] {
        if self.serverDict.allKeys.count == 0 {
            _ = addServer(server: "weblib.ccnl.scut.edu.cn/", name: "ccnl")
            _ = addServer(server: "202.38.194.106:9090/",name:"scn")
//            _ = addServer(server: "weblib.ccnl.scut.edu.cn/", name: "ccnl")
//            _ = addServer(server: "weblib.scn.cn/",name:"scn")
            _ = addServer(server: "202.38.254.197:9090/",name:"9090")
        }
        var rtn: Array<String> = Array();
        for key in self.key{
            let server: String =  self.serverDict.value(forKey: key as! String) as! String
            rtn.append(server);
        }
        return rtn;
        
    }

}
//data
//control
