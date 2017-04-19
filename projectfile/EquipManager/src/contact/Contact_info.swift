//
//  Contact_info.swift
//  AddressBook
//
//  Created by 李呱呱 on 2016/10/21.
//  Copyright (c) 2015年 liguagua. All rights reserved.
//

import UIKit
import CoreFoundation

class Contact_info: NSObject {
    var name:String?
    var acc:String?
    var other:String?
    init(name:String, other:String,acc:String){
        self.name = name
        self.other = other
        self.acc = acc
    }
    func getFirstLetter() -> String{
        let firstLe:NSString = (self.name! as NSString).substring(to: 1) as NSString
        let strTemp:NSMutableString = NSMutableString(string: firstLe)
        //转换
        CFStringTransform(strTemp as CFMutableString, nil, kCFStringTransformMandarinLatin, false)
        CFStringTransform(strTemp as CFMutableString, nil, kCFStringTransformStripDiacritics, false)
        //大写
        let UPN:NSString? = strTemp.uppercased as NSString?
        let sss = UPN!.substring(to: 1)
        
        let c:unichar = (sss as NSString).character(at: 0);
        if((c >= 48 && c <= 57) || c == 32){
            
            return "#"
        }
        return sss
        
    }
    func getName()->String{
        return self.name!
    }
    
    func getOther()->String{
        return self.other!
    }
    
    func getAcc()->String{
        return self.acc!
    }
    
}
