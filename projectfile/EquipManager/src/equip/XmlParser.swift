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
    init(data:Data){
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
    func setRootElement (_ root:GDataXMLElement) -> Bool{
        do{
            doc = GDataXMLDocument(rootElement: root)
            return true
        }
    }
    
    //根据名字获取根元素下的第一个元素
    func getElementFromRoot(_ name:String) -> String{
        do{
            if (self.getRootElement() == nil){
                return "nil"
            }
            let root = self.getRootElement()!;
            //print(root.XMLString());
            let rtn = try root.nodes(forXPath: name);
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
    func getElementsFromRoot(_ name:String) -> [GDataXMLElement]? {
        if (self.getRootElement() == nil){
            return nil
        }
        return self.getRootElement()!.elements(forName: name) as? [GDataXMLElement]
    }
    
    //根据路径获取元素数组
    func getElementFromPath(_ path:String) -> [GDataXMLElement]?{
        do{
            return try doc.nodes(forXPath: path) as? [GDataXMLElement]
        }catch{
            return nil
        }
    }
    
    //给根元素添加元素
    func addElementToRoot(_ key:String,value:String) -> Bool {
        if (self.getRootElement() == nil){
            return false
        }
        self.getRootElement()!.addChild(GDataXMLElement.element(withName: key, stringValue: value))
        return true
    }
    
    //设置当前根元素下的第一个元素
    func setElementOfRoot(_ key:String,value:String) -> Bool {
        if (self.getRootElement() == nil){
            return false
        }
        if (try! self.getRootElement()!.nodes(forXPath: key).isEmpty){
            return false
        }
        let element:GDataXMLElement = self.getRootElement()!.elements(forName: key)[0] as! GDataXMLElement
        element.setStringValue(value)
        return true
    }
    //写入文件
    func writeToFile(_ path:URL) {
        (doc.xmlData() as NSData).write(toFile: path.path, atomically: true);
    }
}
