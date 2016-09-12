//
//  ViewController.swift
//  Crabfans_2016
//
//  Created by 李呱呱 on 16/8/5.
//  Copyright © 2016年 liguagua. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let userName = "lifh";
    let passwd = "lifh";
    let equipName = "我的设备";
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //点击设备助手button
    @IBAction func equipInitView(sender: UIButton) {
        self.pleaseWait();
        NetworkOperation.sharedInstance().Login(userName, passwd: passwd) { (any) in
            NetworkOperation.sharedInstance().Status(){(any) in
                EquipManager.sharedInstance().defaultGroupId = any.objectForKey(NetworkOperation.NetConstant.DictKey.Status.Response.personGroupId) as! Int;
                NetworkOperation.sharedInstance().getResources(-EquipManager.sharedInstance().defaultGroupId){ (any) in
                    let res = any.objectForKey(NetworkOperation.NetConstant.DictKey.GetResources.Response.resources) as! NSArray;
                    for tmp in res{
                        let name = tmp.objectForKey(NetworkOperation.NetConstant.DictKey.GetResources.Response.ResourcesKey.displayName) as! String;
                        if(name.hasPrefix(self.equipName)){
                            let id = tmp.objectForKey(NetworkOperation.NetConstant.DictKey.GetResources.Response.ResourcesKey.id) as! Int;
                            EquipManager.sharedInstance(id);
                            let equipListView = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("EquipList") as! EquipListTableViewController;
                            self.navigationController?.pushViewController(equipListView, animated: true);
                            break;
                        }
                    }
                }
            }
        }
    }
    
}

