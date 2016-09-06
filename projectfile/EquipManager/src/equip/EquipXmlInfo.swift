//
//  EquipXmlInfo.swift
//  EquipManager
//
//  Created by LY on 16/7/24.
//  Copyright © 2016年 LY. All rights reserved.
//

import UIKit

enum EquipmentAttrKey:NSString{
    case codeKey                  = "仪器编号";
    case nameKey                  = "名称";
    case modelKey                 = "型号";
    case categoryNOKey            = "分类号";
    case categoryGBNOKey          = "国标分类号";
    case officeNameKey            = "所属部门";
    case specificationKey         = "规格";
    case serialNoKey              = "出厂(序列号)";
    case manufacturerKey          = "生产厂家";
    case countryKey               = "国别";
    case vendorKey                = "供货商";
    case priceKey                 = "价格(元)";
    case priceDollarKey           = "价格(美元)";
    case invoiceKey               = "发票";
    case outFactoryDateKey        = "生产日期";
    case purchaseDateKey          = "购置日期";
    case subjectsKey              = "经费科目";
    case sourceKey                = "仪器来源";
    case businessUsageNameKey     = "使用方向";
    case statusDesKey             = "设备状态";
    case campusKey                = "校区";
    case specialMarkKey           = "专用标记";
    case departmentNameKey        = "使用部门";
    case annualDepreciationKey    = "年增减值";
    case postingDateKey           = "入账日期";
    case cancellationDateKey      = "注销日期";
    case increasingNOKey          = "报增单号";
    case cancellationApprovalKey  = "注销批准人";
    case annexMarkedKey           = "有附件标注";
    case roomKey                  = "所在房间号";
    case locationKey              = "存放地点";
    case managerKey               = "领用人";
    case managerPhoneKey          = "电话";
    case managerEmailKey          = "Email";
    case managerFaxKey            = "传真";
    case equipImageKey            = "设备图片";
    case twoCodeImage             = "二维码";
};

enum EquipmentKey:NSString {
    case rootKey = "equipment"
    case codeKey = "code"
    case nameKey = "name"
    case modelKey = "model"
    case categoryNOKey = "categoryNO"
    case categoryGBNOKey = "categoryGBNO"
    case officeNameKey = "officeName"
    case specificationKey = "specification"
    case serialNoKey = "serialNo"
    case manufacturerKey = "manufacturer"
    case countryKey = "country"
    case vendorKey = "vendor"
    case priceKey = "price"
    case priceDollarKey = "priceDollar"
    case invoiceKey = "invoice"
    case outFactoryDateKey = "outFactoryDate"
    case purchaseDateKey = "purchaseDate"
    case subjectsKey = "subjects"
    case sourceKey = "source"
    case businessUsageNameKey = "businessUsageName"
    case statusDesKey = "statusDes"
    case campusKey  = "campus"
    case specialMarkKey = "specialMark"
    case departmentNameKey = "departmentName"
    case annualDepreciationKey = "annualDepreciation"
    case postingDateKey = "postingDate"
    case cancellationDateKey = "cancellationDate"
    case increasingNOKey = "increasingNO"
    case cancellationApprovalKey = "cancellationApproval"
    case annexMarkedKey = "annexMarked"
    case roomKey = "room"
    case locationKey = "location"
    case managerKey  = "manager"
    case managerPhoneKey = "managerPhone"
    case managerEmailKey = "managerEmail"
    case managerFaxKey  = "managerFax"
};


//设备的xml信息
class EquipXmlInfo {
    let attrKey:NSMutableArray;
    var xmlFile:FileInfo
    var xmlParser:XmlParser
    var equipAttr:NSMutableDictionary
    
    //根据xml文件信息初始化设备信息
    init(xmlFile:FileInfo){
        self.xmlFile = xmlFile
        self.xmlParser = XmlParser(data: self.xmlFile.getFileData())
        self.equipAttr = NSMutableDictionary()
        self.attrKey = NSMutableArray();
        initEquipAttrWithXml()
    }
    
    //根据设备信息初始化xml信息
    init(equipAttr:NSMutableDictionary, xmlFile:FileInfo){
        self.xmlFile = xmlFile
        self.xmlParser = XmlParser()
        self.equipAttr = equipAttr
        self.attrKey = NSMutableArray();
        initXmlWithEquipAttr(equipAttr)
    }
    
    //根据xml初始化equipAttr
    //9.5
    private func initEquipAttrWithXml(){
        initEquipAttrWithXmlHelper(.nameKey, equipmentAttrKey:.nameKey)
        initEquipAttrWithXmlHelper(.codeKey, equipmentAttrKey:.codeKey)
        initEquipAttrWithXmlHelper(.locationKey, equipmentAttrKey:.locationKey)
        initEquipAttrWithXmlHelper(.roomKey, equipmentAttrKey:.roomKey)
        
        initEquipAttrWithXmlHelper(.managerKey, equipmentAttrKey:.managerKey)
        initEquipAttrWithXmlHelper(.managerPhoneKey, equipmentAttrKey:.managerPhoneKey)
        initEquipAttrWithXmlHelper(.managerEmailKey, equipmentAttrKey:.managerEmailKey)
        initEquipAttrWithXmlHelper(.managerFaxKey, equipmentAttrKey:.managerFaxKey)
        
        initEquipAttrWithXmlHelper(.modelKey, equipmentAttrKey:.modelKey)
        initEquipAttrWithXmlHelper(.statusDesKey, equipmentAttrKey:.statusDesKey)
        
        initEquipAttrWithXmlHelper(.campusKey, equipmentAttrKey:.campusKey)
        initEquipAttrWithXmlHelper(.businessUsageNameKey, equipmentAttrKey:.businessUsageNameKey)
        initEquipAttrWithXmlHelper(.departmentNameKey, equipmentAttrKey:.departmentNameKey)
        
        initEquipAttrWithXmlHelper(.officeNameKey, equipmentAttrKey:.officeNameKey)
        initEquipAttrWithXmlHelper(.countryKey, equipmentAttrKey:.countryKey)
        initEquipAttrWithXmlHelper(.manufacturerKey, equipmentAttrKey:.manufacturerKey)
        initEquipAttrWithXmlHelper(.subjectsKey, equipmentAttrKey:.subjectsKey)
        
        //
        initEquipAttrWithXmlHelper(.annexMarkedKey, equipmentAttrKey:.annexMarkedKey)
        initEquipAttrWithXmlHelper(.annualDepreciationKey, equipmentAttrKey:.annualDepreciationKey)
        initEquipAttrWithXmlHelper(.cancellationApprovalKey, equipmentAttrKey:.cancellationApprovalKey)
        initEquipAttrWithXmlHelper(.cancellationDateKey, equipmentAttrKey:.cancellationDateKey)
        initEquipAttrWithXmlHelper(.categoryGBNOKey, equipmentAttrKey:.categoryGBNOKey)
        initEquipAttrWithXmlHelper(.categoryNOKey, equipmentAttrKey:.categoryNOKey)
        initEquipAttrWithXmlHelper(.increasingNOKey, equipmentAttrKey:.increasingNOKey)
        initEquipAttrWithXmlHelper(.invoiceKey, equipmentAttrKey:.invoiceKey)
        
        initEquipAttrWithXmlHelper(.outFactoryDateKey, equipmentAttrKey:.outFactoryDateKey)
        initEquipAttrWithXmlHelper(.postingDateKey, equipmentAttrKey:.postingDateKey)
        initEquipAttrWithXmlHelper(.priceDollarKey, equipmentAttrKey:.priceDollarKey)
        initEquipAttrWithXmlHelper(.priceKey, equipmentAttrKey:.priceKey)
        
        initEquipAttrWithXmlHelper(.purchaseDateKey, equipmentAttrKey:.purchaseDateKey)
        initEquipAttrWithXmlHelper(.serialNoKey, equipmentAttrKey:.serialNoKey)
        initEquipAttrWithXmlHelper(.sourceKey, equipmentAttrKey:.sourceKey)
        initEquipAttrWithXmlHelper(.specialMarkKey, equipmentAttrKey:.specialMarkKey)
        
        initEquipAttrWithXmlHelper(.specificationKey, equipmentAttrKey:.specificationKey)
        initEquipAttrWithXmlHelper(.vendorKey, equipmentAttrKey:.vendorKey)
        
    }
    
    private func initEquipAttrWithXmlHelper(equipmentKey:EquipmentKey, equipmentAttrKey:EquipmentAttrKey){
        objc_sync_enter(self.attrKey);
        self.equipAttr.setValue(self.xmlParser.getElementFromRoot(equipmentKey.rawValue), forKey: equipmentAttrKey.rawValue as String);
        self.attrKey.addObject(equipmentAttrKey.rawValue as String);
        objc_sync_exit(self.attrKey);
    }
    
    // 根据equipAttr初始化xml
    //9.5
    private func initXmlWithEquipAttr(equipAttr:NSMutableDictionary){
        let rootElement:GDataXMLElement = GDataXMLElement.elementWithName(EquipmentKey.rootKey.rawValue as String)
        self.xmlParser.setRootElement(rootElement)
        
        initXmlWithEquipAttrHelper(.nameKey, equipmentAttrKey:.nameKey)
        initXmlWithEquipAttrHelper(.codeKey, equipmentAttrKey:.codeKey)
        initXmlWithEquipAttrHelper(.locationKey, equipmentAttrKey:.locationKey)
        initXmlWithEquipAttrHelper(.roomKey, equipmentAttrKey:.roomKey)
        
        initXmlWithEquipAttrHelper(.managerKey, equipmentAttrKey:.managerKey)
        initXmlWithEquipAttrHelper(.managerPhoneKey, equipmentAttrKey:.managerPhoneKey)
        initXmlWithEquipAttrHelper(.managerEmailKey, equipmentAttrKey:.managerEmailKey)
        initXmlWithEquipAttrHelper(.managerFaxKey, equipmentAttrKey:.managerFaxKey)
        
        initXmlWithEquipAttrHelper(.modelKey, equipmentAttrKey:.modelKey)
        initXmlWithEquipAttrHelper(.statusDesKey, equipmentAttrKey:.statusDesKey)
        initXmlWithEquipAttrHelper(.campusKey, equipmentAttrKey:.campusKey)
        initXmlWithEquipAttrHelper(.businessUsageNameKey, equipmentAttrKey:.businessUsageNameKey)
        initXmlWithEquipAttrHelper(.departmentNameKey, equipmentAttrKey:.departmentNameKey)
        
        initXmlWithEquipAttrHelper(.officeNameKey, equipmentAttrKey:.officeNameKey)
        initXmlWithEquipAttrHelper(.countryKey, equipmentAttrKey:.countryKey)
        initXmlWithEquipAttrHelper(.manufacturerKey, equipmentAttrKey:.manufacturerKey)
        initXmlWithEquipAttrHelper(.subjectsKey, equipmentAttrKey:.subjectsKey)
        
        //
        initXmlWithEquipAttrHelper(.annexMarkedKey, equipmentAttrKey:.annexMarkedKey)
        initXmlWithEquipAttrHelper(.annualDepreciationKey, equipmentAttrKey:.annualDepreciationKey)
        initXmlWithEquipAttrHelper(.cancellationApprovalKey, equipmentAttrKey:.cancellationApprovalKey)
        initXmlWithEquipAttrHelper(.cancellationDateKey, equipmentAttrKey:.cancellationDateKey)
        initXmlWithEquipAttrHelper(.categoryGBNOKey, equipmentAttrKey:.categoryGBNOKey)
        initXmlWithEquipAttrHelper(.categoryNOKey, equipmentAttrKey:.categoryNOKey)
        initXmlWithEquipAttrHelper(.increasingNOKey, equipmentAttrKey:.increasingNOKey)
        initXmlWithEquipAttrHelper(.invoiceKey, equipmentAttrKey:.invoiceKey)
        
        initXmlWithEquipAttrHelper(.outFactoryDateKey, equipmentAttrKey:.outFactoryDateKey)
        initXmlWithEquipAttrHelper(.postingDateKey, equipmentAttrKey:.postingDateKey)
        initXmlWithEquipAttrHelper(.priceDollarKey, equipmentAttrKey:.priceDollarKey)
        initXmlWithEquipAttrHelper(.priceKey, equipmentAttrKey:.priceKey)
        initXmlWithEquipAttrHelper(.purchaseDateKey, equipmentAttrKey:.purchaseDateKey)
        initXmlWithEquipAttrHelper(.serialNoKey, equipmentAttrKey:.serialNoKey)
        initXmlWithEquipAttrHelper(.sourceKey, equipmentAttrKey:.sourceKey)
        initXmlWithEquipAttrHelper(.specialMarkKey, equipmentAttrKey:.specialMarkKey)
        initXmlWithEquipAttrHelper(.specificationKey, equipmentAttrKey:.specificationKey)
        initXmlWithEquipAttrHelper(.vendorKey, equipmentAttrKey:.vendorKey)
        
    }
    
    private func initXmlWithEquipAttrHelper(equipmentKey:EquipmentKey, equipmentAttrKey:EquipmentAttrKey){
        objc_sync_enter(self.attrKey);
        self.xmlParser.addElementToRoot(equipmentKey.rawValue, value: self.equipAttr.valueForKey(equipmentAttrKey.rawValue as String) as! (String))
        self.attrKey.addObject(equipmentAttrKey.rawValue as String);
        objc_sync_exit(self.attrKey);
    }
    
    //将设备信息更新到文件中
    func updateToFile() -> Bool{
        return self.xmlParser.writeToFile(self.xmlFile.path)
    }
    
    //从文件中更新xml信息
    func updateFromFile(){
        self.xmlParser = XmlParser(data: self.xmlFile.getFileData())
        self.equipAttr = NSMutableDictionary()
        initEquipAttrWithXml()
    }
    
    //修改xml
    func modifyXml(equipmentKey:EquipmentKey, equipmentAttrKey:EquipmentAttrKey, value:NSString) {
        self.xmlParser.setElementOfRoot(equipmentKey.rawValue as String, value: value)
        self.equipAttr.setValue(value, forKey: equipmentAttrKey.rawValue as String)
    }
    
}


