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
    let rootId = 589181;
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func equipInitView(sender: UIButton) {
        NetworkOperation.sharedInstance().Login(userName, passwd: passwd) { (any) in
            EquipManager.sharedInstance(self.rootId);
            let equipListView = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("EquipList") as! EquipListTableViewController;
            self.navigationController?.pushViewController(equipListView, animated: true);
        }
    }

}

