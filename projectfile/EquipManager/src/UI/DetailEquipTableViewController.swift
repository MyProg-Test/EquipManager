//
//  DetailEquipTableViewController.swift
//  Crabfans_2016
//
//  Created by 李呱呱 on 16/8/8.
//  Copyright © 2016年 liguagua. All rights reserved.
//

import UIKit

class DetailEquipTableViewController: UITableViewController {
    
    var array = NSMutableArray();
    let selArray = NSMutableArray();
    var selected:Bool = false{
        didSet{
            if !selected {
                selArray.removeAllObjects();
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //10.6
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationController?.setToolbarHidden(false, animated: true)
        array = DetailEquipViewController.data_source!.xmlInfo.attrKey.mutableCopy() as! NSMutableArray;
//        array.remove(EquipmentAttrKey.managerKey.rawValue)
//        array.remove(EquipmentAttrKey.nameKey.rawValue)
//        array.remove(EquipmentAttrKey.codeKey.rawValue)
//        array.remove(EquipmentAttrKey.locationKey.rawValue)
//        

        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.separatorStyle = .singleLine
        
        menuToolbar()
        
        
    }
    
    //10.6
    override func viewDidAppear(_ animated: Bool) {
        
        self.tableView.reloadData()
    }
//10.6
    
       
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
        return DetailEquipViewController.data_source!.xmlInfo.attrKey.count;
    }
    
   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let DetailEquipCellIdentifier = "DetailEquipCell"
        var cell:DetailEquipTableViewCell! = tableView.dequeueReusableCell(withIdentifier: DetailEquipCellIdentifier) as? DetailEquipTableViewCell;
        if(cell == nil){
            cell = DetailEquipTableViewCell(style: .default, reuseIdentifier: DetailEquipCellIdentifier);
        }
        cell.attrKey.text = array.object(at: indexPath.row) as? String;
        cell.attrValue.text = DetailEquipViewController.data_source!.xmlInfo.equipAttr.value(forKey: cell.attrKey.text!) as? String;
        // Configure the cell...
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.init(rawValue: UITableViewCellEditingStyle.insert.rawValue | UITableViewCellEditingStyle.delete.rawValue)!;
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(selected){
            selArray.add(array.object(at: indexPath.row) as! String);
            return ;
        }
        let modifyController: ModifyTableViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Modify") as! ModifyTableViewController;
        modifyController.key.append(array.object(at: indexPath.row) as! String);
        modifyController.dict.updateValue(DetailEquipViewController.data_source!.xmlInfo.equipAttr.value(forKey: array.object(at: indexPath.row) as! String) as! String, forKey: array.object(at: indexPath.row) as! String)
        self.navigationController?.pushViewController(modifyController, animated: true);
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if(selected){
            selArray.remove(array.object(at: indexPath.row) as! String);
            return ;
        }
    }
    
    func menuToolbar(){
        let backButton = UIBarButtonItem(image: UIImage.init(named:"back"), style: .plain, target: self, action: #selector(EquipListTableViewController.backPressed))
        let flexItem = UIBarButtonItem.init(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let homeItem = UIBarButtonItem(image: UIImage.init(named: "home"), style: .plain, target: self, action: #selector(EquipListTableViewController.homePressed))
        //        let menuItem = UIBarButtonItem(image: UIImage.init(named: "new"), style: .plain, target: self, action: #selector(EquipListTableViewController.menuPressed))
        let items = [backButton, flexItem, homeItem, flexItem, flexItem, flexItem, flexItem]
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
    

}
