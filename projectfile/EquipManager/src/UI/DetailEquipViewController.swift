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
    
    static var data_source:EquipInfo?;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationController?.setToolbarHidden(false, animated: true)
        
        menuToolbar()
        setEquipImage();
        setQRCodeImage();
        //手势识别，图片点击
        let equipTap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(DetailEquipViewController.equipImageTap(_:)));
        equipImage.addGestureRecognizer(equipTap);
        equipImage.userInteractionEnabled = true;
        let qrTap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(DetailEquipViewController.qrCodeTap(_:)));
        QRCodeImage.userInteractionEnabled = true;
        QRCodeImage.addGestureRecognizer(qrTap);
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //设置EquipImage
    func setEquipImage(){
        if(DetailEquipViewController.data_source == nil){
            equipImage.image = UIImage(named: "equipImage.png");
            return ;
        }
        if(DetailEquipViewController.data_source!.imageInfo.getDisplayedImageInfo() == nil){
            equipImage.image = UIImage(named: "equipImage.png");
            return ;
        }
        if(DetailEquipViewController.data_source!.imageInfo.getDisplayedImageInfo()!.getFileData().isEqualToData(NSData())){
            equipImage.image = UIImage(named: "equipImage.png");
            return ;
        }
        equipImage.image = UIImage(data: DetailEquipViewController.data_source!.imageInfo.getDisplayedImageInfo()!.getFileData());
        //to do
    }
    
    //点击设备图片
    func equipImageTap(sender:UITapGestureRecognizer){
        let equipImageView = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("EquipImage") as!EquipImagePickerTableViewController;
        EquipFileControl.sharedInstance().downloadEquipImageFromNet(DetailEquipViewController.data_source!.equipIndex);
        self.pleaseWait();
        self.navigationController?.pushViewController(equipImageView, animated: true);
    }
    
    //点击QRCode图片
    func qrCodeTap(sender:UITapGestureRecognizer) {
        print("qrCodeTap");
    }
    
    //获取equipImage里面显示的图片
    func getEquipImage()->UIImage?{
        return equipImage.image;
    }
    
    //设置QRCodeImage
    func setQRCodeImage(){
        QRCodeImage.image = (DetailEquipViewController.data_source!.xmlInfo.equipAttr.valueForKey(EquipmentAttrKey.codeKey.rawValue as String) as! String).qrImage;
        //生成二维码
    }
    //获取QRCodeImage里面的图片
    func getQRCodeImage()->UIImage?{
        return QRCodeImage.image;
        //to do
        
    }
    
    func menuToolbar(){
        let backButton = UIBarButtonItem(image: UIImage.init(named:"back"), style: .Plain, target: self, action: #selector(DetailEquipViewController.backPressed))
        let flexItem = UIBarButtonItem.init(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
        let homeItem = UIBarButtonItem(image: UIImage.init(named: "home"), style: .Plain, target: self, action: #selector(DetailEquipViewController.homePressed))
        let menuItem = UIBarButtonItem(image: UIImage.init(named: "new"), style: .Plain, target: self, action: #selector(DetailEquipViewController.menuPressed))
        let items = [backButton, flexItem, homeItem, flexItem, flexItem, flexItem, menuItem]
        self.setToolbarItems(items, animated: true)
    }
    
    func backPressed(){
        self.navigationController?.popViewControllerAnimated(true)
        //数据保存
    }
    
    func homePressed(){
        self.navigationController?.popToRootViewControllerAnimated(true)
        //数据保存或上传
    }
    
    
    func menuPressed(){
        let menuAlertController:UIAlertController = UIAlertController(title:"设备信息操作",message:"选择一项操作",preferredStyle:UIAlertControllerStyle.ActionSheet)
        
        menuAlertController.addAction(UIAlertAction(title: "打印信息", style: .Default, handler: { (UIAlertAction) -> Void in
            self.printEquipInfo()
        }))
        
        menuAlertController.addAction(UIAlertAction(title: "修改信息", style: UIAlertActionStyle.Default, handler: { (UIAlertAction) -> Void in
            self.modifyEquipInfo()
        }))
        menuAlertController.addAction(UIAlertAction(title: "设备处理", style: UIAlertActionStyle.Default, handler: { (UIAlertAction) -> Void in
            self.moreEquipManage()
        }))
        menuAlertController.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: { (UIAlertAction) -> Void in
            NSLog("cancel")
        }))
        
        self.presentViewController(menuAlertController, animated: true, completion: nil)
        
        
    }
    
    func modifyEquipInfo(){
        //修改信息
        //跳转到修改信息vc
    }
    
    func moreEquipManage(){
        let moreEquipManageAlertController:UIAlertController = UIAlertController(title:"设备处理",message:"选择一项操作",preferredStyle:UIAlertControllerStyle.ActionSheet)
        
        moreEquipManageAlertController.addAction(UIAlertAction(title: "设备报修", style: UIAlertActionStyle.Default, handler: { (UIAlertAction) -> Void in
            self.askFix()
        }))
        
        moreEquipManageAlertController.addAction(UIAlertAction(title: "维修记录", style: UIAlertActionStyle.Default, handler: { (UIAlertAction) -> Void in
            self.fixLog()
        }))
        
        moreEquipManageAlertController.addAction(UIAlertAction(title: "设备报废", style: UIAlertActionStyle.Default, handler: { (UIAlertAction) -> Void in
            self.uselessEquip()
        }))
        moreEquipManageAlertController.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: { (UIAlertAction) -> Void in
            NSLog("cancel")
        }))
        
        self.presentViewController(moreEquipManageAlertController, animated: true, completion: nil)
        
        
    }
    
    //打印当前设备信息
    func printEquipInfo() {
        self.pleaseWait();
        dispatch_async(dispatch_get_main_queue()){
            let viewRect = CGRectMake(0, 0, 840, 475.2);
            let keyRect = CGRectMake(20, 20, 280, 35);
            let valueRect = CGRectMake(320, 20, 280, 35);
            let qrImageRect = CGRectMake(600, 60, 200, 200);
            let barImageRect = CGRectMake(250, 300, 500, 150);
            
            let key:[String] = DetailEquipViewController.data_source!.xmlInfo.attrKey.objectsAtIndexes(NSIndexSet(indexesInRange: NSRange(location: 0, length: 5 ))) as! [String];
            let dict = DetailEquipViewController.data_source!.xmlInfo.equipAttr.dictionaryWithValuesForKeys(key);
            let qrImage = (DetailEquipViewController.data_source!.xmlInfo.equipAttr.valueForKey(EquipmentAttrKey.codeKey.rawValue as String) as! String).qrImageWithImage(self.getEquipImage());
            let barImage = (DetailEquipViewController.data_source!.xmlInfo.equipAttr.valueForKey(EquipmentAttrKey.codeKey.rawValue as String) as! String).barCode;
            
            
            let view = SwiftPrint.sharedInstance().visitingCardView(dict, key: key, image: [qrImage, barImage], viewRect: viewRect, labelRect: [keyRect, valueRect], imageRect: [qrImageRect, barImageRect])!
            let image = SwiftPrint.sharedInstance().drawVisitingCardSet([view,view]);
            self.clearAllNotice();
            self.printImages(image);
        }
        //打印信息
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
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
