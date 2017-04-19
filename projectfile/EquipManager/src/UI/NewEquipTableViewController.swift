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
                    //EquipmentAttrKey.managerPhoneKey.rawValue,
                    EquipmentAttrKey.locationKey.rawValue];
    
    //10.6
    var valueArray:[String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
    
        valueArray = ["",
                      "\(getRandomCode())",
            "",
            ""]
        
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
        func getRandomName() -> String {
            let time = Date();
            let timeFormatter = DateFormatter();
            timeFormatter.dateFormat = "yyyyMMddHHmmss";
            return "\(timeFormatter.string(from: time))";
        }
        let dict:NSMutableDictionary = NSMutableDictionary();
        for i in 0..<keyArray.count {
            let cell = tableView.cellForRow(at: IndexPath(row: i, section: 0))! as! NewEquipTableViewCell;
            
            dict.setValue(cell.textValue.text!, forKey: cell.labelKey.text!);
        }
        let equip = EquipXmlInfo(equipAttr: dict);
        //_ = equip.updateToFile(); online
        let rootId = EquipManager.sharedInstance().rootId;
        let groupId = EquipManager.sharedInstance().defaultGroupId;
        let foldName = getRandomName();
        let xmlName = "equip.xml"
        let uploadData = equip.xmlParser.doc.xmlData()!;
        self.pleaseWait();
        _ = NetworkOperation.sharedInstance().createDir(groupId, name: foldName, parentID: rootId){
            (any) in
            print(any);
            let response = any as! NSDictionary
            let parentId = response.value(forKey: NetworkOperation.NetConstant.DictKey.CreateDir.Response.id) as! Int
            
            _ = NetworkOperation.sharedInstance().uploadResourceReturnId(groupId, parentID: parentId, fileData: uploadData, fileName: xmlName){
                (any) in
                let response = any as! NSDictionary;
                let file = (response.value(forKey: NetworkOperation.NetConstant.DictKey.UploadResourceReturnId.Response.file) as! NSArray).object(at: 0) as! NSDictionary;
                let xmlId = file.value(forKey: NetworkOperation.NetConstant.DictKey.UploadResourceReturnId.Response.FileKey.id) as! Int;
                _ = EquipFileControl.sharedInstance().addEquipInfoToFile(parentId, XMLID: xmlId, XMLName: xmlName, imageSet: NSMutableArray(), path: "\(parentId)", groupID: groupId, status: FileSystem.Status.download.rawValue);
                equip.equipkey = "\(parentId)"
                _ = equip.updateToFile();
                GCDThread().async {
                    self.clearAllNotice();
                    self.backPressed();
                }
                
            }
        }
        
        
        print("saveEquip");
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
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! NewEquipTableViewCell;
        cell.labelKey.text = keyArray[(indexPath as NSIndexPath).row] as String
        cell.textValue.clearButtonMode = UITextFieldViewMode.whileEditing
        cell.textValue.text = valueArray[(indexPath as NSIndexPath).row] as String
        
        // Configure the cell...

        return cell
    }

    func getRandomCode()->String{
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyyMMddHHmmss"
        let date = Date()
        return dateFormat.string(from: date)
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
