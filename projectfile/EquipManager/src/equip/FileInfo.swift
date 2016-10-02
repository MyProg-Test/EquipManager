//
//  ImageFileInfo.swift
//  EquipManager
//
//  Created by LY on 16/7/24.
//  Copyright © 2016年 LY. All rights reserved.
//

import UIKit
enum Type {
    case png;
    case jpg;
    case jpge;
    case gif;
    case xml;
    case unknown;
}

enum SizeUnit : Int{
    case b  = 1;
    case kb = 2;
    case mb = 3;
    case gb = 4;
}
//文件信息
class FileInfo {
    //文件名
    var name            : String
    //文件id
    var id              : Int
    //文件parentID
    var parentId        : Int
    //文件本地路径
    var path            : URL
    //文件类型
    var type            : Type
    //文件大小
    var size            : Double
    //文件大小的单位
    var sizeUnit        : SizeUnit
    
    
    init(){
        name = ""
        id = -1
        parentId = -1
        path = NSURL() as URL;
        size = 0;
        sizeUnit = .b
        type = .unknown;
    }
    
    //获取文件数据
    func getFileData() -> Data {
        if(FileManager.default.fileExists(atPath: self.path.path)){
            return (try! Data(contentsOf: URL(fileURLWithPath: self.path.path)))
        }
        return Data();
    }
}
