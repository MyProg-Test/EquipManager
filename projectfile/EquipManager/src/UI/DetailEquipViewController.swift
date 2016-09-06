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
    
    func equipImageTap(sender:UITapGestureRecognizer){
        let equipImageView = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("EquipImage") as!EquipImagePickerTableViewController;
        EquipFileControl.sharedInstance().downloadEquipImageFromNet(DetailEquipViewController.data_source!.equipIndex);
        self.navigationController?.pushViewController(equipImageView, animated: true);
    }
    
    func qrCodeTap(sender:UITapGestureRecognizer) {
        print("qrCodeTap");
    }
    
    func getEquipImage()->UIImage?{
        return equipImage.image;
    }
    
    func setQRCodeImage(){
        QRCodeImage.image = (DetailEquipViewController.data_source!.xmlInfo.equipAttr.valueForKey(EquipmentAttrKey.codeKey.rawValue as String) as! String).qrImage;
        //生成二维码
    }
    
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
    func askFix(){
        //报修
    }
    
    func fixLog(){
        //维修记录
    }
    
    func uselessEquip(){
        //设备报废
    }
    
    func selectImage(gest:UIGestureRecognizer){
        /*let CI:ChoseImage = ChoseImage();
         CI.currentfe = self.currentfe;
         self.navigationController?.pushViewController(CI, animated: true);
         return;*/
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
