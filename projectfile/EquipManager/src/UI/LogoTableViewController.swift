//
//  LogoTableViewController.swift
//  EquipManager
//
//  Created by 李呱呱 on 16/9/21.
//  Copyright © 2016年 LY. All rights reserved.
//

import UIKit

class LogoTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let logoArray = NSMutableArray()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationController?.setToolbarHidden(false, animated: false)
        logoArray.add(UIImage(named:"logo.png")!)
        logoArray.add(UIImage(named: "equipImage.png")!)
        logoArray.add(UIImage(named: "equipTwoCode.png")!)
        
        menuToolbar()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let image = logoArray.object(at: indexPath.row) as! UIImage
        SwiftPrint.sharedInstance().setLogo(image: image)
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "logoCell")
        (cell!.subviews[0].subviews[0] as! UIImageView).image = logoArray.object(at: indexPath.row) as? UIImage
        return cell!
    }

    
    func menuToolbar(){
        let backButton = UIBarButtonItem(image: UIImage.init(named:"back"), style: .plain, target: self, action: #selector(EquipListTableViewController.backPressed))
        let flexItem = UIBarButtonItem.init(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let homeItem = UIBarButtonItem(image: UIImage.init(named: "home"), style: .plain, target: self, action: #selector(EquipListTableViewController.homePressed))
        let menuItem = UIBarButtonItem(image: UIImage.init(named: "new"), style: .plain, target: self, action: #selector(EquipListTableViewController.menuPressed))
        let items = [backButton, flexItem, homeItem, flexItem, flexItem, flexItem, menuItem]
        self.setToolbarItems(items, animated: true)
    }
    
    func backPressed(){
        self.navigationController?.popViewController(animated: true)
        
    }
    
    func homePressed(){
        
        self.navigationController?.setToolbarHidden(true, animated: true)
        self.navigationController?.popToRootViewController(animated: true)
        //        CurrentInfo.sharedInstance.backToHome()
    }

    func menuPressed(){
        let menuAlertController:UIAlertController = UIAlertController(title:"选择Logo",message:"",preferredStyle:UIAlertControllerStyle.alert)
        
        menuAlertController.addAction(UIAlertAction(title: "设置Logo", style: UIAlertActionStyle.default, handler: { (UIAlertAction) -> Void in
            self.newLogo()
        }))
        
        menuAlertController.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel, handler: { (UIAlertAction) -> Void in
            NSLog("cancel")
        }))

        
        self.present(menuAlertController, animated: true, completion: nil)
        
    }
  
    func newLogo(){
        let uploadImageAlertController:UIAlertController = UIAlertController(title: "设置Logo", message: "选择来源", preferredStyle: UIAlertControllerStyle.alert)
        
        uploadImageAlertController.addAction(UIAlertAction(title: "本地照片", style: UIAlertActionStyle.default, handler: {(UIAlertAction)-> Void in self.imagePickerFromLocal()}))
        
        uploadImageAlertController.addAction(UIAlertAction(title: "拍照", style: UIAlertActionStyle.default, handler: {(UIAlertAction)-> Void in self.imagePickerFromCamera()}))
        
        uploadImageAlertController.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel, handler: { (UIAlertAction) -> Void in
            NSLog("cancel")
        }))
        self.present(uploadImageAlertController, animated: true, completion: nil);
    }
    
    func imagePickerFromLocal(){
        self.pickPic();
        //本地照片选择图片
    }
    
    func imagePickerFromCamera(){
        self.takePic();
        //拍照上传图片
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return logoArray.count
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        func getRandomID() -> String {
            let time = Date();
            let timeFormatter = DateFormatter();
            timeFormatter.dateFormat = "yyyyMMddHHmmss";
            return "\(timeFormatter.string(from: time))";
        }
        let lastChosen = NSDictionary(dictionary: info);
        if((lastChosen.object(forKey: UIImagePickerControllerMediaType) as! NSString) == (kUTTypeImage as NSString)){
            let chosenImage:UIImage = lastChosen.object(forKey: UIImagePickerControllerEditedImage) as! UIImage;
            SwiftPrint.sharedInstance().setLogo(image: chosenImage);
            logoArray.add(chosenImage);
            self.tableView.reloadData();
        }
        if((lastChosen.object(forKey: UIImagePickerControllerMediaType) as! NSString) == (kUTTypeMovie as NSString)){
            self.noticeError("设备只支持图片", autoClear: true, autoClearTime: 2)
        }
        picker.dismiss(animated: true, completion: nil);
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil);
    }
    
    func takePic(){
        getMediaResource(sourceType: UIImagePickerControllerSourceType.camera);
    }
    
    func pickPic(){
        getMediaResource(sourceType: UIImagePickerControllerSourceType.photoLibrary);
    }
    
    func getMediaResource(sourceType:UIImagePickerControllerSourceType){
        if(UIImagePickerController.isSourceTypeAvailable(sourceType)){
            let mediatypes:NSArray = UIImagePickerController.availableMediaTypes(for: sourceType)! as NSArray;
            let picker:UIImagePickerController = UIImagePickerController();
            picker.mediaTypes = mediatypes as [AnyObject] as! [String];
            picker.delegate = self;
            picker.allowsEditing = true;
            picker.sourceType = sourceType;
            let requiredmediatypes:NSString = kUTTypeImage as NSString;
            let arrmediatype:NSArray = NSArray(object: requiredmediatypes);
            picker.mediaTypes = arrmediatype as [AnyObject] as! [String];
            self.present(picker, animated: true, completion: nil);
        }else{
            self.noticeError("设备不支持拍照", autoClear: true, autoClearTime: 2);
        }
    }

}
