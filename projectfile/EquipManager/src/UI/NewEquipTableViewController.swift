//
//  NewEquipTableViewController.swift
//  Crabfans_2016
//
//  Created by 李呱呱 on 16/9/4.
//  Copyright © 2016年 liguagua. All rights reserved.
//

import UIKit

class NewEquipTableViewController: UITableViewController {
    
    let keyArray = [EquipmentAttrKey.nameKey.rawValue,
                    EquipmentAttrKey.codeKey.rawValue,
                    EquipmentAttrKey.managerKey.rawValue,
                    EquipmentAttrKey.managerPhoneKey.rawValue,
                    EquipmentAttrKey.locationKey.rawValue];

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.setHidesBackButton(true, animated: false);
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "保存", style: .plain, target: self, action: #selector(NewEquipTableViewController.saveEquip(_:)));
        menuToolbar()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func saveEquip(_ sender:AnyObject) {
        let dict:NSMutableDictionary = NSMutableDictionary();
        for i in 0..<keyArray.count {
            let cell = tableView.cellForRow(at: IndexPath(row: i, section: 0))!;
            let contentView = cell.subviews[0];
            var labelKey:UILabel?;
            var textValue:UITextField?;
            for s in contentView.subviews {
                if s.isKind(of: UILabel.self){
                    labelKey = s as? UILabel;
                }
                if s.isKind(of: UITextField.self) {
                    textValue = s as? UITextField;
                }
            }
            dict.setValue(textValue!.text!, forKey: labelKey!.text!);
        }
        let equip = EquipXmlInfo(equipAttr: dict);
        let _ = equip.updateToFile();
        let _ = EquipFileControl.sharedInstance().addEquipInfoToFile(0, XMLID: equip.xmlFile.id, XMLName: equip.xmlFile.name as String, imageSet: NSMutableArray(), path: "\(equip.xmlFile.id)", groupID: EquipManager.sharedInstance().defaultGroupId, status: FileSystem.Status.new.rawValue);
        print("saveEquip");
        self.backPressed();
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return keyArray.count;
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
    

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "newEquip";
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier);
        let contentView = cell!.subviews[0];
        for label in contentView.subviews {
            if(label.isKind(of: UILabel.self)){
                (label as! UILabel).text = keyArray[(indexPath as NSIndexPath).row] as String;
                break;
            }
        }
        // Configure the cell...

        return cell!
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

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
