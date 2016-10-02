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
    };
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationController?.setToolbarHidden(false, animated: true)
        array = DetailEquipViewController.data_source!.xmlInfo.attrKey.mutableCopy() as! NSMutableArray;
        array.remove(EquipmentAttrKey.managerKey.rawValue)
        array.remove(EquipmentAttrKey.nameKey.rawValue)
        array.remove(EquipmentAttrKey.codeKey.rawValue)
        array.remove(EquipmentAttrKey.locationKey.rawValue)
        
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.separatorStyle = .singleLine

        menuToolbar()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "打印标签", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.printSelect))
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
        self.navigationController?.popViewController(animated: true)
        
    }
    
    func homePressed(){
        
        self.navigationController?.setToolbarHidden(true, animated: true)
        self.navigationController?.popToRootViewController(animated: true)
        //        CurrentInfo.sharedInstance.backToHome()
    }
    
    func printSelect() {
        /**/
        //打印信息
        self.tableView.setEditing(true, animated: true);
        selected = true;
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(DetailEquipTableViewController.printStart));
    }
    
    func printStart() {
        self.pleaseWait();
        
        DispatchQueue.main.async{
            let viewRect = CGRect(x: 0, y: 0, width: 840, height: 475.2);
            let headerRect = CGRect(x: 0, y: 0, width: 60, height: 40)
            let keyRect = CGRect(x: 0, y: 0, width: 280, height: 55);
            let valueRect = CGRect(x: 200, y: 0, width: 280, height: 55);
            let qrImageRect = CGRect(x: 520, y: 30, width: 270, height: 270);
            let barImageRect = CGRect(x: 300, y: 310, width: 510, height: 160);
            let logoImageRect = CGRect(x: 90, y: 310, width: 150, height: 150);
            
            
            var key: Array<String> = Array();
            key.append(EquipmentAttrKey.managerKey.rawValue)
            key.append(EquipmentAttrKey.nameKey.rawValue)
            key.append(EquipmentAttrKey.codeKey.rawValue)
            key.append(EquipmentAttrKey.locationKey.rawValue)
            key.append(contentsOf: self.selArray.copy() as! [String]);
            self.setEditing(false, animated: true);
            self.selected = false;
            let dict = DetailEquipViewController.data_source!.xmlInfo.equipAttr.dictionaryWithValues(forKeys: key);
            
            let detailEquipViewController = self.navigationController!.viewControllers[self.navigationController!.viewControllers.count - 2] as! DetailEquipViewController
            
            //二维码中心图片无效
            let qrImage = (DetailEquipViewController.data_source!.xmlInfo.equipAttr.value(forKey: EquipmentAttrKey.codeKey.rawValue as String) as! String).qrImageWithImage(detailEquipViewController.getEquipImage());
            
            let barImage = (DetailEquipViewController.data_source!.xmlInfo.equipAttr.value(forKey: EquipmentAttrKey.codeKey.rawValue as String) as! String).barCode;
            
            let logoImage = SwiftPrint.sharedInstance().getLogo()
            
            
            let view = SwiftPrint.sharedInstance().visitingCardView(dict as NSDictionary, key: key as [AnyObject], image: [qrImage, barImage,logoImage], viewRect: viewRect, labelRect: [keyRect, valueRect, headerRect], imageRect: [qrImageRect, barImageRect,logoImageRect])!
            view.backgroundColor = UIColor.white;
            let printImageData = UIImagePNGRepresentation(view.visitingCardImage())!;
            (printImageData as NSData).write(toFile: DetailEquipViewController.data_source!.xmlInfo.xmlFile.path.deletingLastPathComponent().appendingPathComponent("设备标签.png").path, atomically: true);
            //let _ = NetworkOperation.sharedInstance().uploadResource(EquipManager.sharedInstance().defaultGroupId, parentID: DetailEquipViewController.data_source!.xmlInfo.xmlFile.parentId, fileData: printImageData, fileName: "设备标签.png", handler: {(any) in});
            let image = SwiftPrint.sharedInstance().drawVisitingCardSet([view.visitingCardImage(),view.visitingCardImage()]);
            print(image[0].ciImage);
            self.clearAllNotice();
            self.printImages(image);
        }
        self.navigationItem.rightBarButtonItem = nil;
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
        // 9.20
        return array.count;
    }
    
    //显示DetailEquipViewController.data_source(EquipInfo?)
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let DetailEquipCellIdentifier = "DetailEquipCell"
        var cell:DetailEquipTableViewCell! = tableView.dequeueReusableCell(withIdentifier: DetailEquipCellIdentifier) as? DetailEquipTableViewCell;
        if(cell == nil){
            cell = DetailEquipTableViewCell(style: .default, reuseIdentifier: DetailEquipCellIdentifier);
        }
        cell.attrKey.text = array.object(at: indexPath.row) as? String
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
        }
    }
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if(selected){
            selArray.remove(array.object(at: indexPath.row) as! String);
        }
    }
    
}
