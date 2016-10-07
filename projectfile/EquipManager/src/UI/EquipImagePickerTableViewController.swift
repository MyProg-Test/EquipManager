//
//  EquipImagePickerTableViewController.swift
//  Crabfans_2016
//
//  Created by 李呱呱 on 16/8/9.
//  Copyright © 2016年 liguagua. All rights reserved.
//

import UIKit

class EquipImagePickerTableViewController: UITableViewController,UIAlertViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationController?.setToolbarHidden(false, animated: true)
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.separatorStyle  = .singleLine
        
        GCDThread(global: .utility).async{
            GCDThread().async{
                self.clearAllNotice();
                self.tableView.reloadData();
            }
        }
        
        menuToolbar()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "编辑", style: .done, target: self, action: #selector(EquipImagePickerTableViewController.editImageCell))
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    //长按
    func longPressed(_ sender:UILongPressGestureRecognizer){
        // chose to do
    }
    
    //下拉刷新(to do)
    @IBAction func fresh(_ sender: UIRefreshControl) {
        self.tableView.reloadData();
        sender.endRefreshing();
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
        if(DetailEquipViewController.data_source == nil){
            return 0
        }
        return DetailEquipViewController.data_source!.imageInfo.historyImage.count;
    }
    //数据源DetailEquipViewController.data_source
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let equipImageCellIdentifier = "equipImageCell";
        var cell:EquipImageTableViewCell! = tableView.dequeueReusableCell(withIdentifier: equipImageCellIdentifier) as? EquipImageTableViewCell;
        if(cell == nil){
            cell = EquipImageTableViewCell(style: .default, reuseIdentifier: equipImageCellIdentifier);
        }
        cell.imageInCell.image = DetailEquipViewController.data_source!.imageInfo.getImage((indexPath as NSIndexPath).row);
        cell.imageNameInCell.text = EquipFileControl.sharedInstance().getFileSystemFromFile()!.getImageName(DetailEquipViewController.data_source!.equipkey, imageIndex: (indexPath as NSIndexPath).row) as String;
        return cell
    }
    
    
    
    func menuToolbar(){
        let backButton = UIBarButtonItem(image: UIImage.init(named:"back"), style: .plain, target: self, action: #selector(EquipImagePickerTableViewController.backPressed))
        let flexItem = UIBarButtonItem.init(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let homeItem = UIBarButtonItem(image: UIImage.init(named: "home"), style: .plain, target: self, action: #selector(EquipImagePickerTableViewController.homePressed))
        let menuItem = UIBarButtonItem(image: UIImage.init(named: "new"), style: .plain, target: self, action: #selector(EquipImagePickerTableViewController.menuPressed))
        let items = [backButton, flexItem, homeItem, flexItem, flexItem, flexItem, menuItem]
        self.setToolbarItems(items, animated: true)
    }
    
    func backPressed(){
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func homePressed(){
        _ = self.navigationController?.popToRootViewController(animated: true)
    }
    
    func menuPressed(){
        let imageAlertController:UIAlertController = UIAlertController(title: "图片操作", message: "选择一项操作", preferredStyle: UIAlertControllerStyle.alert)
        
        imageAlertController.addAction(UIAlertAction(title: "上传图片", style: UIAlertActionStyle.default, handler: {(UIAlertAction)-> Void in self.uploadImage()}))
        
        imageAlertController.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel, handler: { (UIAlertAction) -> Void in
            NSLog("cancel")
        }))
        
    }
    
    func uploadImage(){
        let uploadImageAlertController:UIAlertController = UIAlertController(title: "上传图片", message: "选择图片来源", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        uploadImageAlertController.addAction(UIAlertAction(title: "本地照片", style: UIAlertActionStyle.default, handler: {(UIAlertAction)-> Void in self.imagePickerFromLocal()}))
        
        uploadImageAlertController.addAction(UIAlertAction(title: "拍照上传", style: UIAlertActionStyle.default, handler: {(UIAlertAction)-> Void in self.imagePickerFromCamera()}))
        
        uploadImageAlertController.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel, handler: { (UIAlertAction) -> Void in
            NSLog("cancel")
        }))
    }
    
    func imagePickerFromLocal(){
        //本地照片选择图片
    }
    
    func imagePickerFromCamera(){
        //拍照上传图片
    }
    
    func editImageCell(){
        //右上角的编辑按钮
    }
    
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    //10.6
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
            let imageName = getRandomID();
            //10.7
            let equipkey = DetailEquipViewController.data_source!.equipkey;
            let dictInfo = EquipFileControl.sharedInstance().fs!.equipDict.subject.object(forKey: equipkey) as! NSMutableDictionary;
            
            _ = EquipFileControl.sharedInstance().addImageInfoToFile(equipkey, imageID: (imageName as NSString).integerValue, imagePath: dictInfo.object(forKey: FileSystem.equipKey.path) as! String, imageName: "\(imageName).png", status: FileSystem.Status.new.rawValue | FileSystem.Status.download.rawValue);
            let chosenImageData: Data = UIImagePNGRepresentation(chosenImage)!;
            try! chosenImageData.write(to: EquipFileControl.sharedInstance().getImageFilePathFromFile(equipkey, imageIndex: DetailEquipViewController.data_source!.imageInfo.historyImage.count)!);
            for i in stride(from: 0, to: EquipFileControl.sharedInstance().getImageCountFromFile(equipkey), by: 1){
                if EquipFileControl.sharedInstance().isMainImageFromFile(equipkey, imageIndex: i){
                    _ = EquipFileControl.sharedInstance().resetMainImageFromFile(equipkey, imageIndex: i);
                }
            }
            _ = EquipFileControl.sharedInstance().setMainImageFromFile(equipkey, imageIndex: DetailEquipViewController.data_source!.imageInfo.historyImage.count);
            DetailEquipViewController.data_source!.updateEquip(equipkey);
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
    
    /*
     // Override to support editing the table view.
     override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
     if editingStyle == .Delete {
     // Delete the row from the data source
     tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
     } else if editingStyle == .Insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
