//
//  ChooseServerTableViewController.swift
//  EquipManager
//
//  Created by 李呱呱 on 2016/10/17.
//  Copyright © 2016年 liguagua. All rights reserved.
//

import UIKit

class ChooseServerTableViewController: UITableViewController {
    
    var serverArray: [String]{
        get{
            return EquipServer.sharedInstance().getServerList();
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationController?.setToolbarHidden(false, animated: false)
        
        menuToolbar()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let name: String = EquipServer.sharedInstance().key.object(at: indexPath.row) as! String;
        EquipServer.sharedInstance().setServer(name: name);
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:ServerTableViewCell = tableView.dequeueReusableCell(withIdentifier: "serverCell") as! ServerTableViewCell
        cell.serverName?.text = EquipServer.sharedInstance().key.object(at: indexPath.row) as? String
        cell.serverUrl?.text = serverArray[indexPath.row]
        return cell
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
        return serverArray.count
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction: UITableViewRowAction = UITableViewRowAction(style: .destructive, title: "删除") { (action, indexPath) in
            let key = EquipServer.sharedInstance().key.object(at: indexPath.row) as! String;
            EquipServer.sharedInstance().removeServer(name: key);
            self.tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.left);
        }
        return [deleteAction]
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
    
    func menuPressed(){
        let menuAlertController:UIAlertController = UIAlertController(title:"选择Server",message:"",preferredStyle:UIAlertControllerStyle.alert)
        
        menuAlertController.addAction(UIAlertAction(title: "添加服务器", style: UIAlertActionStyle.default, handler: { (UIAlertAction) -> Void in
            self.newServer()
        }))
        
        menuAlertController.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel, handler: { (UIAlertAction) -> Void in
            NSLog("cancel")
        }))
        
        
        self.present(menuAlertController, animated: true, completion: nil)
        
    }
    
    func newServer(){
        let addServerAlertController:UIAlertController = UIAlertController(title: "添加服务器", message: "", preferredStyle: UIAlertControllerStyle.alert)
        
        addServerAlertController.addTextField {
            (textField: UITextField!) -> Void in
            textField.placeholder = "服务器名称"
        }
        
        addServerAlertController.addTextField {
            (textField: UITextField!) -> Void in
            textField.placeholder = "服务器地址"
        }
        let okAction = UIAlertAction(title: "好的", style: UIAlertActionStyle.default) {
            (action: UIAlertAction!) -> Void in
            
            let name:String = addServerAlertController.textFields!.first!.text!;
            
            let url:String = addServerAlertController.textFields!.last!.text!;
            _ = EquipServer.sharedInstance().addServer(server: url, name: name);
            
            self.tableView.reloadData();
            
        }
        
        addServerAlertController.addAction(okAction)
        addServerAlertController.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel, handler: { (UIAlertAction) -> Void in
            print("cancel")
        }))
        
        
        
        self.present(addServerAlertController, animated: true, completion: nil);
    }

}
