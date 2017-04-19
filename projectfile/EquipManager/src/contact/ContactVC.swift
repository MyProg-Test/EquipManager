//
//  ViewControllerTableViewController.swift
//  AddressBook
//
//  Created by 李呱呱 on 2016/10/21.
//  Copyright (c) 2015年 liguagua. All rights reserved.
//

import UIKit

class ContactVC: UITableViewController{
    var data_source:Contact_info_group?
    static let _sharedInstance = ContactVC()
    var equipKey:[String]!
    //
    class func shareInstance()->ContactVC{
        return _sharedInstance
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationController?.setToolbarHidden(false, animated: true)
        
        //LoadContactView()
        self.title = "通讯录"
        
        self.edgesForExtendedLayout = UIRectEdge.all
        tableView.backgroundColor = UIColor.white
        tableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
        menuToolbar()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return data_source!.getGroupNumber()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return data_source!.getNumInGroup(index: section)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellid = "AddressBook"
        let cell:UITableViewCell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: cellid)
        
        let group:NSArray = data_source!.getGroupSection(index: indexPath.section)
        
        cell.textLabel!.text = (group.object(at: indexPath.row) as! Contact_info).getName() as String
        cell.detailTextLabel!.text = (group.object(at: indexPath.row) as! Contact_info).getOther() as String
        
        cell.detailTextLabel!.textColor = UIColor.gray
        cell.backgroundColor = UIColor.clear
        cell.imageView!.image = UIImage(named: "equipTwoCode.png")
        cell.imageView!.layer.masksToBounds = true
        cell.imageView!.layer.cornerRadius = 3
        cell.imageView!.layer.borderWidth = 2
        cell.imageView!.layer.borderColor = UIColor.clear.cgColor
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return data_source!.getGroupName(index: section)
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let transferAction:UITableViewRowAction = UITableViewRowAction(style: UITableViewRowActionStyle.normal, title: "转赠", handler: { (tab:UITableViewRowAction, index:IndexPath) -> Void in
            self.transferTo(index: index)
        })
        transferAction.backgroundColor = UIColor.blue
        
        return [transferAction]
        
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return data_source!.key.subarray(with: NSRange(location: 0, length: data_source!.key.count)) as? [String]
    }
    
    //loadContactHelper
    func LoadContact(page_start:Int, page_limit:Int)->NSMutableArray{
        let Contact_data:NSMutableArray = NSMutableArray()
        
        // getAccounts_blocking
        let dict:NSDictionary = NetworkOperation.sharedInstance().getAccounts_blocking(start: page_start, limit: page_limit) { (any) in }
        let accounts:NSArray = dict.value(forKey:NetworkOperation.NetConstant.DictKey.GetAccounts.Response.accounts) as! NSArray
        
        for i:Int in 0 ..< accounts.count {
            let acc = (accounts.object(at: i) as! NSDictionary).value(forKey: NetworkOperation.NetConstant.DictKey.GetAccounts.Response.AccountsKey.account) as! String
            let depart = (accounts.object(at: i) as! NSDictionary).value(forKey: NetworkOperation.NetConstant.DictKey.GetAccounts.Response.AccountsKey.department) as! String
            let name = (accounts.object(at: i) as! NSDictionary).value(forKey: NetworkOperation.NetConstant.DictKey.GetAccounts.Response.AccountsKey.name) as! String
            let contact:Contact_info = Contact_info(name: "\(name)  \(acc)", other: "\(depart)",acc:acc)
            Contact_data.add(contact)
        }
        return Contact_data
    }
    
    //loadContact
    func LoadContactView(){
        let data_temp = NSMutableArray()
        
        let dict:NSDictionary = NetworkOperation.sharedInstance().getAccounts_blocking(start: 0, limit: 1) { (any) in
            //print(any)
        }
        let count:Int = dict.value(forKey: NetworkOperation.NetConstant.DictKey.GetAccounts.Response.totalCount) as! Int
        //step：每次取200个联系人
        let step = 200
        for i in stride(from: 0, to: count, by: step){
            data_temp.addObjects(from: LoadContact(page_start: i, page_limit: step) as [AnyObject])
        }
        self.data_source = Contact_info_group(contact: data_temp);
        self.tableView.reloadData()
        
    }
    
    //设备转移
    func transferTo(index:IndexPath){
        
        let transferMessageAlert:UIAlertController = UIAlertController(title: "转移留言", message: "", preferredStyle: UIAlertControllerStyle.alert)
        transferMessageAlert.addTextField { (
            textField: UITextField!) -> Void in
            textField.placeholder = "请输入转移留言"
        }
        let okAction = UIAlertAction(title: "好的", style: UIAlertActionStyle.default) { (action: UIAlertAction!) -> Void in
            
            let message = transferMessageAlert.textFields!.first!.text!
            self.transferToHelper(equipKey: self.equipKey, contactInfo: (self.data_source!.getGroupSection(index: index.section) as NSArray).object(at: index.row) as! Contact_info, message: message)
        }
        
        transferMessageAlert.addAction(okAction)
        transferMessageAlert.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel, handler: { (UIAlertAction) -> Void in
            print("cancel")
        }))
        self.present(transferMessageAlert, animated: true, completion: nil);
    }
    
    //设备转移
    func transferToHelper(equipKey:[String],contactInfo:Contact_info, message: String){
        //获取需要转移的设备的id
        for equipK in equipKey{
            let oldParentID = (equipK as NSString).integerValue
            
            let reasonData = XmlParser();
            //reasonData.doc.
            _ = reasonData.setRootElement(GDataXMLElement.element(withName: "reason"));
            _ = reasonData.addElementToRoot("code", value: "1")
            _ = reasonData.addElementToRoot("detail", value: message)
            _ = reasonData.addElementToRoot("transferToName", value: contactInfo.getName())
            
            _ = NetworkOperation.sharedInstance().uploadResource(EquipManager.sharedInstance().defaultGroupId, parentID: oldParentID, fileData: reasonData.doc.xmlData(), fileName: "reason.xml") { (AnyObject) in }
            _ = NetworkOperation.sharedInstance().moveResource(EquipManager.sharedInstance().defaultGroupId, parentID: EquipManager.sharedInstance().defaultTrashId, id: oldParentID, handler: { (AnyObject) in })
            
            _ = EquipFileControl.sharedInstance().deleteEquipFromFile(equipK)
            
        }
        _ = self.navigationController?.popViewController(animated: true);
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
        self.navigationController!.popViewController(animated: true)
        
    }
    
    func homePressed(){
        
        self.navigationController!.setToolbarHidden(true, animated: true)
        self.navigationController!.popToRootViewController(animated: true)
        //        CurrentInfo.sharedInstance.backToHome()
    }
    
    func menuPressed(){
        
    }
    
    // MARK: - Table view data source
    
    
}
