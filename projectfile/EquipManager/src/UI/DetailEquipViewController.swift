//
//  DetailEquipViewController.swift
//  Crabfans_2016
//
//  Created by 李呱呱 on 16/8/8.
//  Copyright © 2016年 liguagua. All rights reserved.
//

import UIKit

class DetailEquipViewController: UIViewController {
    
    @IBOutlet weak var equipImage: UIImageView!
    @IBOutlet weak var QRCodeImage: UIImageView!
    @IBOutlet weak var containerView:UIView!
    
    static var data_source:EquipInfo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationController?.setToolbarHidden(false, animated: true)
        
        menuToolbar()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        setEquipImage()
        setQRCodeImage()
        //手势识别，图片点击
        let equipTap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(DetailEquipViewController.equipImageTap(_:)))
        equipImage.addGestureRecognizer(equipTap)
        equipImage.isUserInteractionEnabled = true
        let qrTap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(DetailEquipViewController.qrCodeTap(_:)))
        QRCodeImage.isUserInteractionEnabled = true
        QRCodeImage.addGestureRecognizer(qrTap)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        for i in equipImage.gestureRecognizers! {
            equipImage.removeGestureRecognizer(i)
        }
        for i in QRCodeImage.gestureRecognizers! {
            QRCodeImage.removeGestureRecognizer(i)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //设置EquipImage
    func setEquipImage(){
        if(DetailEquipViewController.data_source == nil){
            equipImage.image = UIImage(named: "equipImage.png")
            return
        }
        equipImage.image = DetailEquipViewController.data_source!.imageInfo.getMainImage()
        //to do
    }
    
    //点击设备图片
    func equipImageTap(_ sender:UITapGestureRecognizer){
        self.pleaseWait()
        GCDThread(global: .utility).async {
            let equipImageView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EquipImage") as!EquipImagePickerTableViewController
            EquipFileControl.sharedInstance().downloadEquipImageFromNet(DetailEquipViewController.data_source!.equipkey)
            GCDThread().async {
                self.navigationController?.pushViewController(equipImageView, animated: true)
            }
        }
    }
    
    //点击QRCode图片 放大
    func qrCodeTap(_ sender:UITapGestureRecognizer) {
        print("qrCodeTap")
        let clickImageView:UIImageView = sender.view as! UIImageView
        XWScanImage.scanBigImage(with: clickImageView)
    }
    

    //获取equipImage里面显示的图片
    func getEquipImage()->UIImage?{
        return equipImage.image
    }
    //10.8
    //设置QRCodeImage
    func setQRCodeImage(){
//        QRCodeImage.image = (DetailEquipViewController.data_source!.xmlInfo.equipAttr.value(forKey: EquipmentAttrKey.codeKey.rawValue as String) as! String).qrImage
        let infoKey:[String] = [EquipmentAttrKey.nameKey.rawValue,EquipmentAttrKey.codeKey.rawValue,EquipmentAttrKey.locationKey.rawValue]
        let infoDict:[String:Any] = DetailEquipViewController.data_source!.xmlInfo.equipAttr.dictionaryWithValues(forKeys: infoKey)
        
        let info:String = infoDict.description

        QRCodeImage.image = info.qrImageWithImage(getEquipImage())
        //生成二维码
    }
    //获取QRCodeImage里面的图片
    func getQRCodeImage()->UIImage?{
        return QRCodeImage.image
        //to do
        
    }
    
    func menuToolbar(){
        let backButton = UIBarButtonItem(image: UIImage.init(named:"back"), style: .plain, target: self, action: #selector(DetailEquipViewController.backPressed))
        let flexItem = UIBarButtonItem.init(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let homeItem = UIBarButtonItem(image: UIImage.init(named: "home"), style: .plain, target: self, action: #selector(DetailEquipViewController.homePressed))
        let menuItem = UIBarButtonItem(image: UIImage.init(named: "new"), style: .plain, target: self, action: #selector(DetailEquipViewController.menuPressed))
        let items = [backButton, flexItem, homeItem, flexItem, flexItem, flexItem, menuItem]
        self.setToolbarItems(items, animated: true)
    }
    
    func backPressed(){
        self.navigationController!.popViewController(animated: true)
        //数据保存
    }
    
    func homePressed(){
        self.navigationController!.popToRootViewController(animated: true)
        //数据保存或上传
    }
    
    
    func menuPressed(){
        let menuAlertController:UIAlertController = UIAlertController(title:"设备信息操作",message:"选择一项操作",preferredStyle:UIAlertControllerStyle.alert)
        
        menuAlertController.addAction(UIAlertAction(title: "复制设备", style: UIAlertActionStyle.default, handler: { (UIAlertAction) -> Void in
            self.copyEquipInfo()
        }))
        
        menuAlertController.addAction(UIAlertAction(title: "设备处理", style: UIAlertActionStyle.default, handler: { (UIAlertAction) -> Void in
            self.moreEquipManage()
        }))
        
        menuAlertController.addAction(UIAlertAction(title: "打印标签", style: UIAlertActionStyle.default, handler: { (UIAlertAction) -> Void in
            self.printSelect()
        }))
        
        menuAlertController.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel, handler: { (UIAlertAction) -> Void in
            NSLog("cancel")
        }))
        
        self.present(menuAlertController, animated: true, completion: nil)
        
    }
    
    func copyEquipInfo(){
        func getRandomName() -> String {
            let time = Date();
            let timeFormatter = DateFormatter();
            timeFormatter.dateFormat = "yyyyMMddHHmmss";
            return "\(timeFormatter.string(from: time))";
        }
        let oldEquip: EquipXmlInfo = DetailEquipViewController.data_source!.xmlInfo
        let newEquip: EquipXmlInfo = EquipXmlInfo(equipAttr: oldEquip.equipAttr)
        
        //_ = equip.updateToFile(); online
        let rootId = EquipManager.sharedInstance().rootId;
        let groupId = EquipManager.sharedInstance().defaultGroupId;
        let foldName = getRandomName();
        let xmlName = "equip.xml"
        let uploadData = newEquip.xmlParser.doc.xmlData()!;
        self.pleaseWait();
        _ = NetworkOperation.sharedInstance().createDir(groupId, name: foldName, parentID: rootId){
            (any) in
            print(any);
            let response = any as! NSDictionary
            let parentId = response.value(forKey: NetworkOperation.NetConstant.DictKey.CreateDir.Response.id) as! Int
            
            _ = NetworkOperation.sharedInstance().uploadResourceReturnId(groupId, parentID: parentId, fileData: uploadData, fileName: xmlName){
                (any) in
                let response = any as! NSDictionary;
                let file = (response.value(forKey: NetworkOperation.NetConstant.DictKey.UploadResourceReturnId.Response.file) as! NSArray).object(at: 0) as! NSDictionary;
                let xmlId = file.value(forKey: NetworkOperation.NetConstant.DictKey.UploadResourceReturnId.Response.FileKey.id) as! Int;
                _ = EquipFileControl.sharedInstance().addEquipInfoToFile(parentId, XMLID: xmlId, XMLName: xmlName, imageSet: NSMutableArray(), path: "\(parentId)", groupID: groupId, status: FileSystem.Status.download.rawValue);
                newEquip.equipkey = "\(parentId)"
                //复制的设备编号随机一个
                newEquip.modifyXml(equipmentAttrKey: .codeKey, value: getRandomName())
                
                let success: Bool = newEquip.updateToFile()
                GCDThread().async {
                    self.clearAllNotice();
                    if success{
                        self.noticeSuccess("复制完成", autoClear: true, autoClearTime: 2)
                    }else{
                        self.noticeError("复制失败", autoClear: true, autoClearTime: 2)
                    }
                }
                
            }
        }
        
    }
    
    func moreEquipManage(){
        let moreEquipManageAlertController:UIAlertController = UIAlertController(title:"设备处理",message:"选择一项操作",preferredStyle:UIAlertControllerStyle.alert)
        
        moreEquipManageAlertController.addAction(UIAlertAction(title: "设备报修", style: UIAlertActionStyle.default, handler: { (UIAlertAction) -> Void in
            self.askFix()
        }))
        
        moreEquipManageAlertController.addAction(UIAlertAction(title: "维修记录", style: UIAlertActionStyle.default, handler: { (UIAlertAction) -> Void in
            self.fixLog()
        }))
        
        moreEquipManageAlertController.addAction(UIAlertAction(title: "设备报废", style: UIAlertActionStyle.default, handler: { (UIAlertAction) -> Void in
            self.uselessEquip()
        }))
        moreEquipManageAlertController.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel, handler: { (UIAlertAction) -> Void in
            NSLog("cancel")
        }))
        
        self.present(moreEquipManageAlertController, animated: true, completion: nil)
        
        
    }
    
    func askFix(){
        //报修
    }
    
    func fixLog(){
        //维修记录
    }
    
    func uselessEquip(){
        //设备报废
    }
    
    func printSelect() {
        /**/
        //打印信息 
        self.pleaseWait();
        
        GCDThread().async{
            
            
            var key: Array<String> = Array();
            key.append(EquipmentAttrKey.managerKey.rawValue)
            key.append(EquipmentAttrKey.nameKey.rawValue)
            key.append(EquipmentAttrKey.codeKey.rawValue)
            key.append(EquipmentAttrKey.locationKey.rawValue)
            
            let dict = DetailEquipViewController.data_source!.xmlInfo.equipAttr.dictionaryWithValues(forKeys: key);
            
            
            //10.14 more 二维码内容 五字段
            let infoKey:[String] = [EquipmentAttrKey.nameKey.rawValue,EquipmentAttrKey.managerKey.rawValue,EquipmentAttrKey.codeKey.rawValue,EquipmentAttrKey.locationKey.rawValue,EquipmentAttrKey.manufacturerKey.rawValue]
            let infoDict:[String:Any] = DetailEquipViewController.data_source!.xmlInfo.equipAttr.dictionaryWithValues(forKeys: infoKey)
            
            let info:String = infoDict.description
            
            
            let qrImage = info.qrImageWithImage (self.getEquipImage());
            
            let barImage = (DetailEquipViewController.data_source!.xmlInfo.equipAttr.value(forKey: EquipmentAttrKey.codeKey.rawValue as String) as! String).barCode;
            
            let logoImage = EquipLogo.sharedInstance().getLogo();
            
            let printImage = SwiftPrint.sharedInstance().labelCard(dict: dict as! [String : String], key: key, qrImage: qrImage, logoImage: logoImage, barImage: barImage);
            let printImageData = UIImagePNGRepresentation(printImage)!;
            //安装去除注释
            //let _ = NetworkOperation.sharedInstance().uploadResource(EquipManager.sharedInstance().defaultGroupId, parentID: DetailEquipViewController.data_source!.xmlInfo.xmlFile.parentId, fileData: printImageData, fileName: "设备标签.png", handler: {(any) in});
            let image = SwiftPrint.sharedInstance().singlePrint(image: printImage, row: 0);
            self.clearAllNotice();
            self.printImage(image: image);
        }
    }
    
}
