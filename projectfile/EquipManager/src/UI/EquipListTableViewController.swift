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


class EquipListTableViewController: UITableViewController,UIGestureRecognizerDelegate {
    
    let searchSource:NSMutableArray = NSMutableArray()
    
    var loadingSuccess:Bool = false
    var mString:NSString = ""
    
    var updateDone:Bool = true
    
    
    //显示“正在加载中”
    var isLoading = true
    //toolbar的menuItems
    var actionMenuItems = [menuItem]()
    //其他
    var dataSource:NSMutableArray = NSMutableArray()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationController?.setToolbarHidden(false, animated: true)
        tableView.estimatedRowHeight = tableView.rowHeight
        //tableView.rowHeight = CurrentInfo.sharedInstance.rowHeight
        tableView.separatorStyle = .SingleLine
        //下面的toolbar
        menuToolbar()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "编辑", style: .Done, target: self, action: #selector(EquipListTableViewController.editEquipList))
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        DetailEquipViewController.data_source = nil;
        self.pleaseWait();
        dispatch_async(dispatch_get_main_queue()){
            self.tableView.reloadData();
            self.clearAllNotice();
        }
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        
        super.viewWillDisappear(animated);
        
    }
    
    //长按
    func longPressed(sender:UILongPressGestureRecognizer){
        
    }
    
    //下拉刷新
    @IBAction func refresh(sender: UIRefreshControl?){
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0)){
            while(!NetworkOperation.sharedInstance().downloadComplete){
                sleep(1);
            }
            dispatch_async(dispatch_get_main_queue()){
                self.tableView.reloadData();
                sender!.endRefreshing();
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1;
    }
    
    
    //有问题
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        //这里写cell的数据设置
        //        if(!loadingSuccess){
        //            let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "loading");
        //            cell.textLabel?.text = "正在加载中..."
        //            return cell
        //        }
        let equipListCellIdentifier = "EquipListCell"
        var cell:EquipListTableViewCell! = tableView.dequeueReusableCellWithIdentifier(equipListCellIdentifier) as? EquipListTableViewCell
        if(cell == nil){
            cell = EquipListTableViewCell(style: .Default, reuseIdentifier: equipListCellIdentifier);
        }
        return cell
        
    }
    
    //Select
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let detailEquipView = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("DetailEquip") as! DetailEquipViewController;
        
    }
    
    //Deselect
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        //to do
    }
    
    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    //水平滑动cell，出现删除键
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        return nil
    }
    
    func menuToolbar(){
        let backButton = UIBarButtonItem(image: UIImage.init(named:"back"), style: .Plain, target: self, action: #selector(EquipListTableViewController.backPressed))
        let flexItem = UIBarButtonItem.init(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
        let homeItem = UIBarButtonItem(image: UIImage.init(named: "home"), style: .Plain, target: self, action: #selector(EquipListTableViewController.homePressed))
        let menuItem = UIBarButtonItem(image: UIImage.init(named: "new"), style: .Plain, target: self, action: #selector(EquipListTableViewController.menuPressed))
        let items = [backButton, flexItem, homeItem, flexItem, flexItem, flexItem, menuItem]
        self.setToolbarItems(items, animated: true)
    }
    
    func backPressed(){
        self.navigationController?.popViewControllerAnimated(true)
        
    }
    
    func homePressed(){
        
        self.navigationController?.setToolbarHidden(true, animated: true)
        self.navigationController?.popToRootViewControllerAnimated(true)
        //        CurrentInfo.sharedInstance.backToHome()
    }
    
    func menuPressed(){
        let menuAlertController:UIAlertController = UIAlertController(title:"设备管理",message:"选择一项操作",preferredStyle:UIAlertControllerStyle.ActionSheet)
        
        menuAlertController.addAction(UIAlertAction(title: "添加设备", style: UIAlertActionStyle.Default, handler: { (UIAlertAction) -> Void in
            self.newEquip()
        }))
        menuAlertController.addAction(UIAlertAction(title: "扫一扫", style: UIAlertActionStyle.Default, handler: { (UIAlertAction) -> Void in
            self.qrCodeScan()
        }))
        menuAlertController.addAction(UIAlertAction(title: "打印标签", style: UIAlertActionStyle.Default, handler: { (UIAlertAction) -> Void in
            self.printTag()
        }))
        menuAlertController.addAction(UIAlertAction(title: "设备转移", style: UIAlertActionStyle.Default, handler: { (UIAlertAction) -> Void in
            self.transferEquip()
        }))
        menuAlertController.addAction(UIAlertAction(title: "设备排序", style: UIAlertActionStyle.Default, handler: { (UIAlertAction) -> Void in
            self.sortEquipList()
        }))
        menuAlertController.addAction(UIAlertAction(title: "设备删除", style: UIAlertActionStyle.Default, handler: { (UIAlertAction) -> Void in
            self.deleteEuip()
        }))
        menuAlertController.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: { (UIAlertAction) -> Void in
            NSLog("cancel")
        }))
        
        self.presentViewController(menuAlertController, animated: true, completion: nil)
        
    }
    
    //入口
    //    class func initializeWithFileDict(fileDict:NSDictionary){
    //        EquipFileConfig.sharedInstance().equipFileRoot = FileStruct(rId: NSMutableDictionary(dictionary: fileDict))
    //        EquipFileConfig.sharedInstance().flag = true
    //    }
    
    
    //以下actionSheet里面的函数最后可写成闭包加入到上面的hander里面
    //添加设备
    func newEquip(){
        //出现newEquip的VC
    }
    //扫描二维码
    func qrCodeScan(){
        //扫描到信息之后，有两个选择：1是查看该设备信息，2是将该设备信息添加到自己的设备列表。
        //扫描ing
        //扫描后的信息和两个选择的button，需要新建一个vc，在查看信息的时候，需要Nav的返回键
        
    }
    //打印标签
    func printTag(){
        //AirPrint API
        //整个cell列表变成可多选
        //确定打印后，选择纸张打印类型，将选定的所有设备的tag组合放在在一页纸上
        //选择打印机，打印
    }
    //设备转移
    func transferEquip(){
        //reason.xml
        //出现设备list多选列表
        //从联系人列表选择
    }
    //设备排序
    func sortEquipList(){
        let sortAlertController:UIAlertController = UIAlertController(title: "排序", message: nil, preferredStyle: .ActionSheet)
        sortAlertController.addAction(UIAlertAction(title: "按添加时间排序", style: .Default, handler: { (UIAlertAction) -> Void in self.sortByAddTime()}))
        sortAlertController.addAction(UIAlertAction(title: "按设备名排序", style: .Default, handler: { (UIAlertAction) -> Void in self.sortByEquipName()}))
        sortAlertController.addAction(UIAlertAction(title: "按领用人排序", style: .Default, handler: { (UIAlertAction) -> Void in self.sortByManager()}))
        sortAlertController.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: { (UIAlertAction) -> Void in
            NSLog("cancel")
        }))
        
        self.presentViewController(sortAlertController, animated: true, completion: nil)
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
    func deleteEuip(){
        //移动到删除文件夹中
        //cell列表出现可多选按钮
    }
    
    func editEquipList(){
        //右上角的编辑按钮
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