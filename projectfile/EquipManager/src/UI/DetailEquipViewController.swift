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
    
    //点击QRCode图片
    func qrCodeTap(_ sender:UITapGestureRecognizer) {
        print("qrCodeTap")
    }
    
    //获取equipImage里面显示的图片
    func getEquipImage()->UIImage?{
        return equipImage.image
    }
    
    //设置QRCodeImage
    func setQRCodeImage(){
        QRCodeImage.image = (DetailEquipViewController.data_source!.xmlInfo.equipAttr.value(forKey: EquipmentAttrKey.codeKey.rawValue as String) as! String).qrImage
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
        
        menuAlertController.addAction(UIAlertAction(title: "修改信息", style: UIAlertActionStyle.default, handler: { (UIAlertAction) -> Void in
            self.modifyEquipInfo()
        }))
        menuAlertController.addAction(UIAlertAction(title: "设备处理", style: UIAlertActionStyle.default, handler: { (UIAlertAction) -> Void in
            self.moreEquipManage()
        }))
        menuAlertController.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel, handler: { (UIAlertAction) -> Void in
            NSLog("cancel")
        }))
        
        self.present(menuAlertController, animated: true, completion: nil)
        
        
    }
    
    func modifyEquipInfo(){
        //修改信息
        //跳转到修改信息vc
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
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
