//
//  EquipListTableViewController.swift
//  Crabfans_2016
//
//  Created by 李呱呱 on 16/8/5.
//  Copyright © 2016年 liguagua. All rights reserved.
//

import UIKit

public struct menuItem {
    var imageName: String
    var itemName: String
}

class EquipListTableViewController: UITableViewController,UIGestureRecognizerDelegate,UISearchBarDelegate{
    
    var doneItem: Array<String> = Array();
    var loadingSuccess:Bool = false
    //搜索设备
    var mString:String = ""{
        willSet{
            if newValue == "" {
                showArray.removeAllObjects();
                showArray.addObjects(from: EquipFileControl.sharedInstance().getFileSystemFromFile()!.attrKey.subject.subarray(with: NSRange(location: 0, length: EquipFileControl.sharedInstance().count)) as! [String]);
            }else{
                showArray.removeAllObjects();
                for i in stride(from: 0, to: EquipFileControl.sharedInstance().count, by: 1){
                    let key:String = EquipFileControl.sharedInstance().getFileSystemFromFile()!.attrKey.subject.object(at: i) as! String;
                    let equip: EquipInfo = EquipInfo(key: key);
                    let name: String = equip.xmlInfo.equipAttr.object(forKey: EquipmentAttrKey.nameKey.rawValue) as! String;
                    let code: String = equip.xmlInfo.equipAttr.object(forKey: EquipmentAttrKey.codeKey.rawValue) as! String;
                    let location: String = equip.xmlInfo.equipAttr.object(forKey: EquipmentAttrKey.locationKey.rawValue) as! String;
                    let manager: String = equip.xmlInfo.equipAttr.object(forKey: EquipmentAttrKey.managerKey.rawValue) as! String;
                    let searchSource: String = name+code+location+manager;
                    if searchSource.contains(newValue) {
                        showArray.add(key);
                    }
                }
            }
        }
        didSet{
            
            
        }
    }
    let selArray: NSMutableArray = NSMutableArray();
    let showArray: NSMutableArray = NSMutableArray();
    var selected:Bool = false{
        didSet{
            if(!selected){
                selArray.removeAllObjects();
            }
        }
    }
    
    //toolbar的menuItems
    var actionMenuItems = [menuItem]()
    //其他
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mString = "";
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationController?.setToolbarHidden(false, animated: true)
        tableView.estimatedRowHeight = tableView.rowHeight
        //tableView.rowHeight = CurrentInfo.sharedInstance.rowHeight
        tableView.separatorStyle = .singleLine
        //下面的toolbar
        menuToolbar()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "操作", style: .done, target: self, action: #selector(EquipListTableViewController.editEquipList))
        self.pleaseWait()
        
        GCDThread(global: .utility).async {
            EquipManager.sharedInstance().update()
            GCDThread().async {
                self.tableView.reloadData()
                self.clearAllNotice()
            }
        }
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mString = "";
        self.tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        
    }
    
    //长按
    func longPressed(_ sender:UILongPressGestureRecognizer){
        
    }
    
    //下拉刷新
    
    @IBAction func refresh(_ sender: UIRefreshControl?){
        
        GCDThread(global: .utility).async{
            
            GCDThread().async{
                let searchString = self.mString;
                self.mString = searchString;
                self.tableView.reloadData()
                sender!.endRefreshing()
            }
        }
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
        return showArray.count
    }
    
    
    //有问题
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //这里写cell的数据设置
        //        if(!loadingSuccess){
        //            let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "loading");
        //            cell.textLabel?.text = "正在加载中..."
        //            return cell
        //        }
        let equipListCellIdentifier = "EquipListCell"
        var cell:EquipListTableViewCell! = tableView.dequeueReusableCell(withIdentifier: equipListCellIdentifier) as? EquipListTableViewCell
        if(cell == nil){
            cell = EquipListTableViewCell(style: .default, reuseIdentifier: equipListCellIdentifier)
        }
        //cell数据设置
        cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        let equip = EquipInfo(key: showArray.object(at: (indexPath as NSIndexPath).row) as! String)
        cell.equipName.text = equip.xmlInfo.equipAttr.value(forKey: EquipmentAttrKey.nameKey.rawValue as String) as? String
        cell.equipNumber.text = equip.xmlInfo.equipAttr.value(forKey: EquipmentAttrKey.codeKey.rawValue as String) as? String;
        cell.thumbnail?.image = equip.imageInfo.getMainImage()
        return cell
        
    }
    
    //Select
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(selected){
            selArray.add(showArray.object(at: (indexPath as NSIndexPath).row) as! String);
            return ;
        }
        let detailEquipView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailEquip") as! DetailEquipViewController;
        DetailEquipViewController.data_source = EquipInfo(key: showArray.object(at: (indexPath as NSIndexPath).row) as! String);
        self.navigationController?.pushViewController(detailEquipView, animated: true);
    }
    
    //Deselect
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if(selected){
            selArray.remove(showArray.object(at: (indexPath as NSIndexPath).row) as! String);
            return ;
        }//to do
    }
    
    //允许编辑cell
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    //列表多选，变成这种模式，没能再左划拉出删除按钮了
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.init(rawValue: UITableViewCellEditingStyle.insert.rawValue | UITableViewCellEditingStyle.delete.rawValue)!;
    }
    
    //搜索bar的delegate
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.showsCancelButton = true;
        return true;
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false;
        searchBar.returnKeyType = .done;
        searchBar.resignFirstResponder();
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        mString = "";
        searchBar.showsCancelButton = false;
        searchBar.text = "";
        searchBar.resignFirstResponder();
        self.tableView.reloadData();
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        mString = searchText;
        self.tableView.reloadData();
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
        _ = self.navigationController?.popViewController(animated: true)
        
    }
    
    func homePressed(){
        
        self.navigationController?.setToolbarHidden(true, animated: true)
        _ = self.navigationController?.popToRootViewController(animated: true)
        //        CurrentInfo.sharedInstance.backToHome()
    }
    
    //Modify by gua 10.5
    func menuPressed(){
        let menuAlertController:UIAlertController = UIAlertController(title:"设备管理",message:"选择一项操作",preferredStyle:UIAlertControllerStyle.alert)
        
        menuAlertController.addAction(UIAlertAction(title: "添加设备", style: UIAlertActionStyle.default, handler: { (UIAlertAction) -> Void in
            self.newEquip()
        }))
        menuAlertController.addAction(UIAlertAction(title: "扫一扫", style: UIAlertActionStyle.default, handler: { (UIAlertAction) -> Void in
            self.qrCodeScan()
        }))
        //menuAlertController.addAction(UIAlertAction(title: "打印标签", style: UIAlertActionStyle.default, handler: { (UIAlertAction) -> Void in
            //self.printTag()
        //}))
        
        //menuAlertController.addAction(UIAlertAction(title: "设备转移", style: UIAlertActionStyle.default, handler: { (UIAlertAction) -> Void in
            //self.transferSelect()
        //}))
        
        menuAlertController.addAction(UIAlertAction(title: "选择系统Logo", style: UIAlertActionStyle.default, handler: { (UIAlertAction)->Void in
            self.chooseLogo()
        }))
        
//        menuAlertController.addAction(UIAlertAction(title: "设备删除", style: UIAlertActionStyle.default, handler: { (UIAlertAction) -> Void in
//            self.deleteEuipSelect()
//        }))
        
        menuAlertController.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel, handler: { (UIAlertAction) -> Void in
            NSLog("cancel")
        }))
        
        self.present(menuAlertController, animated: true, completion: nil)
        
    }
    
    
    //以下actionSheet里面的函数最后可写成闭包加入到上面的hander里面
    //添加设备
    func newEquip(){
        let newEquipView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "newEquip");
        self.navigationController?.pushViewController(newEquipView, animated: true);
        //出现newEquip的VC
    }
    //扫描二维码
    func qrCodeScan(){
//        let scan = QRCodeScanViewController()
//        scan.scan(sender: self)
        let vc = codeScanner()
        
        self.navigationController?.pushViewController(vc, animated: true)
//11.15看这里
//        let barCode = NSArray(array: [AVMetadataObjectTypeEAN8Code,AVMetadataObjectTypeEAN13Code,AVMetadataObjectTypeCode128Code, AVMetadataObjectTypeCode39Code]);
//        let qrCode = NSArray(array: [AVMetadataObjectTypeQRCode]);
//        let CSV = codeScanner();
//        let type = self.barCode;
//        CSV.setWithType(type as [AnyObject]);
//        let scanComplete:((AnyObject?)->Void) = {(metaObj:AnyObject?)->Void in
//            let alert:ButtonSelectedAlert = ButtonSelectedAlert(title: "消息", message: "", delegate: nil, cancelButtonTitle: "取消", otherButtonTitles: "确定");//error???
//            let alertButtonsolution:((Int)->Void) = {(buttonIndex:Int)->Void in
//                if(buttonIndex == 1){
//                    equip.setStringAttr((metaObj as! AVMetadataMachineReadableCodeObject).stringValue, key: equipmentAttrKey.codeKey);
//                }
//                CSV.navigationController?.popToViewController(self, animated: false);
//            };
//            alert.setWithButtonSolution(alertButtonsolution);
//            alert.delegate = alert;
//            alert.show();
//        };
//        CSV.setWithComplete(scanComplete);
//        self.navigationController?.pushViewController(CSV, animated: false);
    }
    
    func chooseLogo(){
        let chooseLogoView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Logo") as! LogoTableViewController
        self.navigationController?.pushViewController(chooseLogoView, animated: true);
        
    }
    
    //打印标签
    func printTag(){
        printSelect();
    }
    
    func printSelect() {
        /**/
        //打印信息
        //11.5
//        self.tableView.setEditing(true, animated: true);
//        selected = true
//        if selArray.count == 0 {
//            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "取消", style: .done, target: self, action: #selector(EquipListTableViewController.cancel))
//            
//        }
//            self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(EquipListTableViewController.printStart))
//        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self , action: #selector(EquipListTableViewController.cancel))
        //self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(EquipListTableViewController.printStart))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "打印", style: .done, target: self, action: #selector(EquipListTableViewController.printStart))
//        if(selected){
//            self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(EquipListTableViewController.printStart))
//        }

    }
    
    func cancel(){
        selected = false
        self.tableView.setEditing(false, animated: true)
        self.navigationItem.leftBarButtonItem = nil
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "操作", style: .done, target: self, action: #selector(EquipListTableViewController.editEquipList))
    }
    
    func printStart() {
        
        self.pleaseWait();
        
        GCDThread().async{
            var key: Array<String> = Array();
            key.append(EquipmentAttrKey.managerKey.rawValue)
            key.append(EquipmentAttrKey.nameKey.rawValue)
            key.append(EquipmentAttrKey.codeKey.rawValue)
            key.append(EquipmentAttrKey.locationKey.rawValue)
            var imageArray: Array<UIImage> = Array();
            
            for i in stride(from: 0, to: self.selArray.count, by: 1){
                let equip: EquipInfo = EquipInfo(key: self.selArray.object(at: i) as! String);
                let dict = equip.xmlInfo.equipAttr.dictionaryWithValues(forKeys: key);
                
                let qrImage = (equip.xmlInfo.equipAttr.value(forKey: EquipmentAttrKey.codeKey.rawValue as String) as! String).qrImageWithImage(equip.imageInfo.getMainImage());
                let barImage = (equip.xmlInfo.equipAttr.value(forKey: EquipmentAttrKey.codeKey.rawValue as String) as! String).barCode;
                let logoImage = EquipLogo.sharedInstance().getLogo();
                
                let printImage = SwiftPrint.sharedInstance().labelCard(dict: dict as! [String : String], key: key, qrImage: qrImage, logoImage: logoImage, barImage: barImage);
                imageArray.append(printImage);
                imageArray.append(printImage);
            }
            let image = SwiftPrint.sharedInstance().drawVisitingCardSet(imageArray);
            self.clearAllNotice();
            self.selected = false;
            self.tableView.setEditing(false, animated: true);
            self.navigationItem.leftBarButtonItem = nil;
            self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "操作", style: .done, target: self, action: #selector(EquipListTableViewController.editEquipList))
            self.printImage(image: image[0]);
        }
    }
    
    func transferSelect(){
//        self.tableView.setEditing(true, animated: true);
//        selected = true;
        //self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self , action: #selector(EquipListTableViewController.cancel))
        //self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(EquipListTableViewController.transferStart));
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "选择转移人", style: .done, target: self, action:  #selector(EquipListTableViewController.transferStart))
    }
    
    //设备转移
    func transferStart(){
        transferEquip(equipKey: self.selArray.subarray(with: NSRange(location: 0, length: self.selArray.count)) as! [String]);
        self.selected = false;
        self.tableView.setEditing(false, animated: true);
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "操作", style: .done, target: self, action: #selector(EquipListTableViewController.editEquipList))
    }
    
    func transferEquip(equipKey:[String]){
        //12.30
        self.pleaseWait()
        GCDThread(global:.default).async{ () -> Void in
            ContactVC.shareInstance().equipKey = equipKey;
            ContactVC.shareInstance().LoadContactView();
            GCDThread().async {
                self.clearAllNotice();
                self.navigationController?.pushViewController(ContactVC.shareInstance(), animated: true)
            }
        }
        //reason.xml
        //出现设备list多选列表
        //从联系人列表选择
    }
    
    //设备排序
    func sortEquipList(){
        let sortAlertController:UIAlertController = UIAlertController(title: "排序", message: nil, preferredStyle: .alert)
        sortAlertController.addAction(UIAlertAction(title: "按添加时间排序", style: .default, handler: { (UIAlertAction) -> Void in self.sortByAddTime()}))
        sortAlertController.addAction(UIAlertAction(title: "按设备名排序", style: .default, handler: { (UIAlertAction) -> Void in self.sortByEquipName()}))
        sortAlertController.addAction(UIAlertAction(title: "按领用人排序", style: .default, handler: { (UIAlertAction) -> Void in self.sortByManager()}))
        sortAlertController.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel, handler: { (UIAlertAction) -> Void in
            NSLog("cancel")
        }))
        
        self.present(sortAlertController, animated: true, completion: nil)
    }
    //按添加时间排序
    func sortByAddTime(){
        //to do
    }
    //按设备名排序
    func sortByEquipName(){
        //to do
    }
    //按领用人排序
    func sortByManager(){
        //to do
    }
    
    //设备删除
    func deleteEuipSelect(){
//        self.tableView.setEditing(true, animated: true)
//        selected = true
//        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self , action: #selector(EquipListTableViewController.cancel))
        //self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "删除", style: UIBarButtonItemStyle.done, target: self, action: #selector(EquipListTableViewController.deleteStart))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "确定删除", style: .done, target: self, action: #selector(EquipListTableViewController.deleteStart))
        //self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(EquipListTableViewController.deleteHelper))
        //移动到删除文件夹中
        //cell列表出现可多选按钮
    }
    
    func deleteStart(){
        deleteHelper(equipKey: self.selArray.subarray(with: NSRange(location: 0, length: self.selArray.count)) as! [String])
        self.selected = false;
        self.tableView.setEditing(false, animated: true);
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "操作", style: .done, target: self, action: #selector(EquipListTableViewController.editEquipList))
    }
    
    func deleteHelper(equipKey:[String]){
        //12.30
        self.pleaseWait()
        GCDThread(global: .default).async { ()->Void in
            for equipK in equipKey{
                let oldParentID = (equipK as NSString).integerValue
                
                let reasonData = XmlParser();
                //reasonData.doc.
                _ = reasonData.setRootElement(GDataXMLElement.element(withName: "reason"));
                _ = reasonData.addElementToRoot("code", value: "0")
                _ = reasonData.addElementToRoot("detail", value: "删除")
                _ = reasonData.addElementToRoot("transferToName", value: "nil")
                
                _ = NetworkOperation.sharedInstance().uploadResource(EquipManager.sharedInstance().defaultGroupId, parentID: oldParentID, fileData: reasonData.doc.xmlData(), fileName: "reason.xml") { (AnyObject) in }
                _ = NetworkOperation.sharedInstance().moveResource(EquipManager.sharedInstance().defaultGroupId, parentID: EquipManager.sharedInstance().defaultTrashId, id: oldParentID, handler: { (AnyObject) in })
                
                _ = EquipFileControl.sharedInstance().deleteEquipFromFile(equipK)
                //UI线程 main
                GCDThread().async {
                    self.tableView.reloadData()
                }
                
                self.clearAllNotice()
                
            }
    
        }
    }
    
    func editEquipList(){
       
        self.tableView.setEditing(true, animated: true);
        selected = true
        //右上角的编辑按钮
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self , action: #selector(EquipListTableViewController.cancel))
        //menuPressed需要改成done
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "设备处理", style: .done, target: self, action: #selector(EquipListTableViewController.done))
    }
    
    func done(){
        doneItem = ["打印标签","设备转移","设备删除"];
        self.zz_presentSheetController(doneItem,clickItemHandler: {(index) in
            switch index{
            case 0:
                self.printStart()
            case 1:
                self.transferStart()
            case 2:
                self.deleteStart()
            default:
                print(index);
            
            }});
    }
    
    
    
    
     // Override to support editing the table view.
    
    
    
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
