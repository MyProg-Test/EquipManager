//
//  XmlParser.swift
//  EquipManager
//
//  Created by 李呱呱 on 16/7/25.
//  Copyright © 2016年 LY. All rights reserved.
//

import UIKit

//xml解析器
class XmlParser {
    var doc:GDataXMLDocument
    
    
    //从data里读取xml文档
    init(data:NSData){
        do{
            doc = try GDataXMLDocument (data: data, options: 0)
            doc.setCharacterEncoding("utf-8")
        }catch{
            doc = GDataXMLDocument();
            print(error);
        }
    }
    
    //建立一个空的xml文档
    init(){
        doc = GDataXMLDocument ()
        doc.setCharacterEncoding("utf-8")
    }
    
    //获取当前文档的根元素 最外围的<>
    func getRootElement () -> GDataXMLElement? {
        return doc.rootElement()
    }
    
    //设置当前文档的根元素
    func setRootElement (root:GDataXMLElement) -> Bool{
        do{
            doc = GDataXMLDocument(rootElement: root)
            return true
        }
    }
    
    //根据名字获取根元素下的第一个元素
    func getElementFromRoot(name:NSString) -> String{
        do{
            if (self.getRootElement() == nil){
                return "nil"
            }
            let root = self.getRootElement()!;
            //print(root.XMLString());
            let rtn = try root.nodesForXPath(name as String);
            if(rtn.count > 0){
                return (rtn[0] as! GDataXMLElement).stringValue();
            }else{
                return "";
            }
        }catch{
            print(error);
            return "";
        }
    }
    
    //根据名字获取根元素下的所有元素
    func getElementsFromRoot(name:NSString) -> [GDataXMLElement]? {
        if (self.getRootElement() == nil){
            return nil
        }
        return self.getRootElement()!.elementsForName(name as String) as? [GDataXMLElement]
    }
    
    //根据路径获取元素数组
    func getElementFromPath(path:NSString) -> [GDataXMLElement]?{
        do{
            return try doc.nodesForXPath(path as String) as? [GDataXMLElement]
        }catch{
            return nil
        }
    }
    
    //给根元素添加元素
    func addElementToRoot(key:NSString,value:NSString) -> Bool {
        if (self.getRootElement() == nil){
            return false
        }
        self.getRootElement()!.addChild(GDataXMLElement.elementWithName(key as String, stringValue: value as String))
        return true
    }
    
    //设置当前根元素下的第一个元素
    func setElementOfRoot(key:NSString,value:NSString) -> Bool {
        if (self.getRootElement() == nil){
            return false
        }
        if (try! self.getRootElement()!.nodesForXPath(key as String).isEmpty){
            return false
        }
        let element:GDataXMLElement = self.getRootElement()!.elementsForName(key as String)[0] as! GDataXMLElement
        element.setStringValue(value as String)
        return true
    }
    
    func writeToFile(path:NSURL) -> Bool {
        return doc.XMLData().writeToFile(path.path!, atomically: true)
        
    }
}
