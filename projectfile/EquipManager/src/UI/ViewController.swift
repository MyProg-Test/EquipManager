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
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //点击设备助手button
    @IBAction func equipInitView(sender: UIButton) {
        
    }
    
}

