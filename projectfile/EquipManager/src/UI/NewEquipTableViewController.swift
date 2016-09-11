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
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "保存", style: .Plain, target: self, action: #selector(NewEquipTableViewController.saveEquip(_:)));
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
    
    func saveEquip(sender:AnyObject) {
        let dict:NSMutableDictionary = NSMutableDictionary();
        for i in 0..<keyArray.count {
            let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: i, inSection: 0))!;
            let contentView = cell.subviews[0];
            var labelKey:UILabel?;
            var textValue:UITextField?;
            for s in contentView.subviews {
                if s.isKindOfClass(UILabel){
                    labelKey = s as? UILabel;
                }
                if s.isKindOfClass(UITextField) {
                    textValue = s as? UITextField;
                }
            }
            dict.setValue(textValue!.text!, forKey: labelKey!.text!);
        }
        let equip = EquipXmlInfo(equipAttr: dict);
        equip.updateToFile();
        EquipFileControl.sharedInstance().addEquipInfoToFile(0, XMLID: equip.xmlFile.id, XMLName: equip.xmlFile.name, imageSet: NSMutableArray(), path: "\(equip.xmlFile.id)", groupID: EquipManager.sharedInstance().defaultGroupId, status: FileSystem.Status.New.rawValue);
        print("saveEquip");
        self.backPressed();
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return keyArray.count;
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
        
    }
    

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "newEquip\(indexPath.row)";
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier);
        let contentView = cell!.subviews[0];
        for label in contentView.subviews {
            if(label.isKindOfClass(UILabel)){
                (label as! UILabel).text = keyArray[indexPath.row] as String;
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
