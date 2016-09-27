//
//  ViewController.swift
//  Crabfans_2016
//
//  Created by 李呱呱 on 16/8/5.
//  Copyright © 2016年 liguagua. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var userName: UITextField!;
    @IBOutlet weak var passwd: UITextField!;
    //let userName = "lifh";
    //let passwd = "lifh";
    let equipName = "我的设备";
    override func viewDidLoad() {
        super.viewDidLoad()
        userName.text = "lifh";
        passwd.text = "lifh";
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //点击设备助手button
    @IBAction func equipInitView(_ sender: UIButton) {
        self.pleaseWait();
        NetworkOperation.sharedInstance().Login(userName.text!, passwd: passwd.text!) { (any) in
            _ = NetworkOperation.sharedInstance().Status(){(any) in
                EquipManager.sharedInstance().defaultGroupId = any.object(forKey: NetworkOperation.NetConstant.DictKey.Status.Response.personGroupId) as! Int;
                _ = NetworkOperation.sharedInstance().getResources(-EquipManager.sharedInstance().defaultGroupId){ (any) in
                    let res = any.object(forKey: NetworkOperation.NetConstant.DictKey.GetResources.Response.resources) as! NSArray;
                    for tmp in res{
                        let name = (tmp as AnyObject).object(forKey: NetworkOperation.NetConstant.DictKey.GetResources.Response.ResourcesKey.displayName) as! String;
                        if(name.hasPrefix(self.equipName)){
                            let id = (tmp as AnyObject).object(forKey: NetworkOperation.NetConstant.DictKey.GetResources.Response.ResourcesKey.id) as! Int;
                            _ = EquipManager.sharedInstance(id);
                            GCDThread().async {
                                let equipListView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EquipList") as! EquipListTableViewController;
                                self.clearAllNotice();
                                self.navigationController!.pushViewController(equipListView, animated: true);
                            }
                            break;
                        }
                    }
                }
            }
        }
    }
    
}

