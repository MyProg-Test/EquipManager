//
//  EquipSimpleInfoTableViewController.swift
//  EquipManager
//
//  Created by 李呱呱 on 16/9/14.
//  Copyright © 2016年 liguagua. All rights reserved.
//

import UIKit

class EquipSimpleInfoTableViewController: UITableViewController {

    @IBOutlet weak var equipNameLabel: UILabel! 
    @IBOutlet weak var equipManagerLabel: UILabel!
    @IBOutlet weak var equipCodeLabel: UILabel!
    @IBOutlet weak var equipLocLabel: UILabel!
    @IBOutlet weak var equipComLabel:UILabel!
    
    
    @IBOutlet weak var equipNameImage:UIImageView!
    @IBOutlet weak var equipManagerImage:UIImageView!
    @IBOutlet weak var equipLocImage:UIImageView!
    
    static var data_source:EquipInfo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.separatorStyle = .singleLine
        
        equipNameImage.image = UIImage(named: "right.png")
        equipManagerImage.image = UIImage(named: "right.png")
        equipLocImage.image = UIImage(named: "right.png")
        
           }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        equipNameLabel.text = DetailEquipViewController.data_source!.xmlInfo.equipAttr.value(forKey: EquipmentAttrKey.nameKey.rawValue as String) as? String
        equipManagerLabel.text = DetailEquipViewController.data_source!.xmlInfo.equipAttr.value(forKey: EquipmentAttrKey.managerKey.rawValue as String) as? String
        equipCodeLabel.text = DetailEquipViewController.data_source!.xmlInfo.equipAttr.value(forKey: EquipmentAttrKey.codeKey.rawValue as String) as? String
        equipLocLabel.text = DetailEquipViewController.data_source!.xmlInfo.equipAttr.value(forKey: EquipmentAttrKey.locationKey.rawValue as String) as? String
        equipComLabel.text = DetailEquipViewController.data_source!.xmlInfo.equipAttr.value(forKey: EquipmentAttrKey.manufacturerKey.rawValue as String) as? String
        
        
        let equipNameImageTap:UITapGestureRecognizer = UITapGestureRecognizer(target: self
            , action: #selector(EquipSimpleInfoTableViewController.equipNameImageTap(_:)))
        equipNameImage.addGestureRecognizer(equipNameImageTap)
        equipNameImage.isUserInteractionEnabled = true
        
        let equipManagerImageTap:UITapGestureRecognizer = UITapGestureRecognizer(target: self
            , action: #selector(EquipSimpleInfoTableViewController.equipManagerImageTap(_:)))
        equipManagerImage.addGestureRecognizer(equipManagerImageTap)
        equipManagerImage.isUserInteractionEnabled = true
        
        let equipLocImageTap:UITapGestureRecognizer = UITapGestureRecognizer(target: self
            , action: #selector(EquipSimpleInfoTableViewController.equipLocImageTap(_:)))
        equipLocImage.addGestureRecognizer(equipLocImageTap)
        equipLocImage.isUserInteractionEnabled = true
        
    }

    func equipNameImageTap(_ sender:UITapGestureRecognizer){
        let detailInfoView = UIStoryboard(name:"Main",bundle: nil).instantiateViewController(withIdentifier: "DetailInfo") as! DetailEquipTableViewController
        
        self.navigationController?.pushViewController(detailInfoView, animated: true)
    }
    
    func equipManagerImageTap(_ sender:UITapGestureRecognizer){
        let managerView = UIStoryboard(name:"Main",bundle: nil).instantiateViewController(withIdentifier: "ManagerInfo") as! ManagerInfoTableViewController
        
        self.navigationController?.pushViewController(managerView, animated: true)
        
    }
    
    func equipLocImageTap(_ sender:UITapGestureRecognizer){
        let locationView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MapInfo") as! MapViewController
        
        self.navigationController?.pushViewController(locationView, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        for i in equipNameImage.gestureRecognizers!{
            equipNameImage.removeGestureRecognizer(i)
        }
        for i in equipManagerImage.gestureRecognizers!{
            equipManagerImage.removeGestureRecognizer(i)
        }
        for i in equipLocImage.gestureRecognizers!{
            equipLocImage.removeGestureRecognizer(i)
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
        return 5
    }

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

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
