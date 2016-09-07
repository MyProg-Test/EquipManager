//
//  ImageFileInfo.swift
//  EquipManager
//
//  Created by LY on 16/7/24.
//  Copyright © 2016年 LY. All rights reserved.
//

import UIKit
enum Type {
    case PNG;
    case JPG;
    case JPGE;
    case GIF;
    case XML;
    case UNKNOWN;
}

enum SizeUnit : Int{
    case B  = 1;
    case KB = 2;
    case MB = 3;
    case GB = 4;
}
//文件信息
class FileInfo {
    //文件名
    var name            : NSString
    //文件id
    var id              : Int
    //文件parentID
    var parentId        : Int
    //文件本地路径
    var path            : NSURL
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
        path = NSURL()
        size = 0
        sizeUnit = .B
        type = .UNKNOWN;
    }
    
    //获取文件数据
    func getFileData() -> NSData {
        if(NSFileManager.defaultManager().fileExistsAtPath(self.path.path!)){
            return NSData(contentsOfFile: self.path.path!)!
        }
        return NSData();
    }
}
