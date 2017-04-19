//
//  ModifyTableViewController.swift
//  EquipManager
//
//  Created by 李呱呱 on 2016/10/9.
//  Copyright © 2016年 liguagua. All rights reserved.
//

import UIKit

class ModifyTableViewController: UITableViewController {
    

    var dict: Dictionary<String, String> = Dictionary();
    var key: Array<String> = Array();

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.setHidesBackButton(true, animated: false);
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "保存", style: .plain, target: self, action: #selector(ModifyTableViewController.saveModify(_:)));
        menuToolbar()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    func saveModify(_ sender:AnyObject){
        for i in stride(from: 0, to: key.count, by: 1){
            let k: String = key[i];
            let v: String = dict[k]!;
            DetailEquipViewController.data_source!.modifyEquipXmlInfo(equipmentAttrKey: EquipmentAttrKey(rawValue: k)!, value: v);
        }
        _ = self.navigationController?.popViewController(animated: true)
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
        return key.count;
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ModifyTableViewCell = tableView.dequeueReusableCell(withIdentifier: "modifyEquip", for: indexPath) as! ModifyTableViewCell;
        cell.keyLabel.text = key[indexPath.row];
        cell.valueText.text = dict[cell.keyLabel.text!];
        cell.valueText.tag = indexPath.row
        cell.valueText.addTarget(self, action: #selector(valueChanged(sender:)), for: .editingChanged);

        // Configure the cell...

        return cell
    }
 
    func valueChanged(sender:UITextField){
        let value = sender.text!
        let i = sender.tag
        dict.updateValue(value, forKey: key[i]);
        
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
}
