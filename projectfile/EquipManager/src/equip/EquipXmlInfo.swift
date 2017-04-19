//
//  EquipXmlInfo.swift
//  EquipManager
//
//  Created by 李呱呱 on 16/7/24.
//  Copyright © 2016年 liguagua. All rights reserved.
//

import UIKit

enum EquipmentAttrKey:String{
    case codeKey                  = "编号";
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
    case locationKey              = "位置";
    case managerKey               = "使用";
    case managerPhoneKey          = "电话";
    case managerEmailKey          = "Email";
    case managerFaxKey            = "传真";
    case equipImageKey            = "设备图片";
    case twoCodeImage             = "二维码";
};

enum EquipmentKey:String {
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
    var equipkey:String
    let fileAttr:NSMutableDictionary
    var xmlParser:XmlParser
    var equipAttr:NSMutableDictionary
    
    //根据xml文件信息初始化设备信息
    init(key:String){
        self.equipkey = key
        fileAttr = EquipFileControl.sharedInstance().getEquipFromFile(self.equipkey)!;
        self.xmlParser = XmlParser(data: EquipFileControl.sharedInstance().getEquipData(self.equipkey));
        self.equipAttr = NSMutableDictionary()
        self.attrKey = NSMutableArray();
        initEquipAttrWithXml()
    }
    
    //根据设备信息新建xml信息
    init(equipAttr:NSMutableDictionary){
//        func getRandomID() -> String {
//            let time = Date();
//            let timeFormatter = DateFormatter();
//            timeFormatter.dateFormat = "yyyyMMddHHmmss";
//            return "\(timeFormatter.string(from: time))";
//        }
//        let id: Int = (getRandomID() as NSString).integerValue;
//        let name: String = "\(getRandomID()).xml";
//        let parentId: Int = id;
//        let path = getRandomID();
//        self.equipkey = "\(parentId)";
//        self.xmlParser = XmlParser()
//        self.equipAttr = equipAttr
//        self.attrKey = NSMutableArray();
//        _ = EquipFileControl.sharedInstance().addEquipInfoToFile(parentId, XMLID: id, XMLName: name, imageSet: NSMutableArray(), path: path, groupID: EquipManager.sharedInstance().defaultGroupId, status: FileSystem.Status.new.rawValue | FileSystem.Status.download.rawValue);
//        fileAttr = EquipFileControl.sharedInstance().getEquipFromFile(self.equipkey)!;
        self.equipkey = "";
        self.xmlParser = XmlParser()
        self.equipAttr = equipAttr
        self.attrKey = NSMutableArray();
        self.fileAttr = NSMutableDictionary();
        initXmlWithEquipAttr(equipAttr)
    }
    
    //根据xml初始化equipAttr
    //9.5
    fileprivate func initEquipAttrWithXml(){
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
    
    fileprivate func initEquipAttrWithXmlHelper(_ equipmentKey:EquipmentKey, equipmentAttrKey:EquipmentAttrKey){
        objc_sync_enter(self.attrKey);
        self.equipAttr.setValue(self.xmlParser.getElementFromRoot(equipmentKey.rawValue), forKey: equipmentAttrKey.rawValue as String);
        self.attrKey.add(equipmentAttrKey.rawValue as String);
        objc_sync_exit(self.attrKey);
    }
    
    // 根据equipAttr初始化xml
    //9.5
    fileprivate func initXmlWithEquipAttr(_ equipAttr:NSMutableDictionary){
        let rootElement:GDataXMLElement = GDataXMLElement.element(withName: EquipmentKey.rootKey.rawValue as String)
        _ = self.xmlParser.setRootElement(rootElement)
        
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
    
    fileprivate func initXmlWithEquipAttrHelper(_ equipmentKey:EquipmentKey, equipmentAttrKey:EquipmentAttrKey){
        if(self.equipAttr.value(forKey: equipmentAttrKey.rawValue as String) == nil){
            self.equipAttr.setValue("", forKey: equipmentAttrKey.rawValue as String);
        }
        objc_sync_enter(self.attrKey);
        _ = self.xmlParser.addElementToRoot(equipmentKey.rawValue, value: self.equipAttr.value(forKey: equipmentAttrKey.rawValue as String) as! (String))
        self.attrKey.add(equipmentAttrKey.rawValue as String);
        objc_sync_exit(self.attrKey);
    }
    
    //将设备信息更新到文件中
    func updateToFile() -> Bool{
        
        do{
            if(!FileManager.default.fileExists(atPath: EquipFileControl.sharedInstance().getEquipFilePathFromFile(self.equipkey)!.deletingLastPathComponent().path)){
                try FileManager.default.createDirectory(atPath: EquipFileControl.sharedInstance().getEquipFilePathFromFile(self.equipkey)!.deletingLastPathComponent().path, withIntermediateDirectories: true, attributes: nil);
            }
            return self.xmlParser.writeToFile(EquipFileControl.sharedInstance().getEquipFilePathFromFile(self.equipkey)!)
            
        }catch{
            print(error);
            return false
        }
        
    }
    
    //从文件中更新xml信息
    func updateFromFile(){
        self.xmlParser = XmlParser(data: EquipFileControl.sharedInstance().getEquipData(self.equipkey))
        self.equipAttr = NSMutableDictionary()
        initEquipAttrWithXml()
    }
    
    //修改xml
    func modifyXml(equipmentAttrKey:EquipmentAttrKey, value:String) {
        _ = self.xmlParser.setElementOfRoot(self.translation(attrKey: equipmentAttrKey).rawValue as String, value: value)
        self.equipAttr.setValue(value, forKey: equipmentAttrKey.rawValue as String)
        let oldStatus: Int = EquipFileControl.sharedInstance().getEquipStatusFromFile(self.equipkey);
        _ = EquipFileControl.sharedInstance().modifyEquipStatusInFile(self.equipkey, status: oldStatus | FileSystem.Status.modifty.rawValue);
        _ = self.updateToFile();
    }
    
    func translation(attrKey: EquipmentAttrKey) -> EquipmentKey {
        switch attrKey {
        case .annexMarkedKey:
            return .annexMarkedKey
        case .annualDepreciationKey:
            return .annualDepreciationKey
        case .businessUsageNameKey:
            return .businessUsageNameKey
        case .campusKey:
            return .campusKey
        case .cancellationApprovalKey:
            return .cancellationApprovalKey
        case .cancellationDateKey:
            return .cancellationDateKey
        case .categoryGBNOKey:
            return .categoryGBNOKey
        case .categoryNOKey:
            return .categoryNOKey
        case .codeKey:
            return .codeKey
        case .countryKey:
            return .countryKey
        case .departmentNameKey:
            return .departmentNameKey
        case .increasingNOKey:
            return .increasingNOKey
        case .invoiceKey:
            return .invoiceKey
        case .locationKey:
            return .locationKey
        case .managerEmailKey:
            return .managerEmailKey
        case .managerFaxKey:
            return .managerFaxKey
        case .managerKey:
            return .managerKey
        case .managerPhoneKey:
            return .managerPhoneKey
        case .manufacturerKey:
            return .manufacturerKey
        case .modelKey:
            return .modelKey
        case .nameKey:
            return .nameKey
        case .officeNameKey:
            return .officeNameKey
        case .outFactoryDateKey:
            return .outFactoryDateKey
        case .postingDateKey:
            return .postingDateKey
        case .priceDollarKey:
            return .priceDollarKey
        case .priceKey:
            return .priceKey
        case .purchaseDateKey:
            return .purchaseDateKey
        case .roomKey:
            return .roomKey
        case .serialNoKey:
            return .serialNoKey
        case .sourceKey:
            return .sourceKey
        case .specialMarkKey:
            return .specialMarkKey
        case .specificationKey:
            return .specificationKey
        case .statusDesKey:
            return .statusDesKey
        case .subjectsKey:
            return .subjectsKey
        case .vendorKey:
            return .vendorKey
        default:
            return .annexMarkedKey;
        }
    }
    
    func getQRImage(image:UIImage) -> UIImage {
        let infoKey:[String] = [EquipmentAttrKey.nameKey.rawValue,EquipmentAttrKey.managerKey.rawValue,EquipmentAttrKey.codeKey.rawValue,EquipmentAttrKey.locationKey.rawValue,EquipmentAttrKey.manufacturerKey.rawValue]
        let infoDict:[String:Any] = equipAttr.dictionaryWithValues(forKeys: infoKey)
        
        let info:String = infoDict.description
        
        return info.qrImageWithImage(image)
    }
}


