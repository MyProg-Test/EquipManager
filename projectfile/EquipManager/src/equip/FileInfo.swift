//
//  FileInfo.swift
//  EquipManager
//
//  Created by LY on 16/9/12.
//  Copyright © 2016年 LY. All rights reserved.
//

import UIKit

//描述一个文件的基本信息

@objc protocol FileInfoProtocal {
    optional var data:NSData{ get };
    optional var isExist:Bool{ get };
    optional var parentFileInfo:AnyObject{ get };
    
}

class FileInfoClass: FileInfoProtocal {
    lazy var name: String = "";
    var parentIdentifier: AnyObject?;
    
    
}

class LocalFileInfo: FileInfoClass {
    
}

class FileInfoFactory: <#super class#> {
    <#code#>
}
