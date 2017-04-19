//
//  ViewController.swift
//  Crabfans_2016
//
//  Created by 李呱呱 on 16/8/5.
//  Copyright © 2016年 liguagua. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITextFieldDelegate
{
    
    //用户密码输入框
    var txtUser:UITextField!
    var txtPwd:UITextField!
    var logoImage:UIImageView!

    @IBOutlet weak var serverButton: UIButton!;
    @IBOutlet weak var remember:UISwitch!;
    
    //let userName = "lifh";
    //let passwd = "lifh";
    let equipName = "我的设备";
    let trashName = "device_change";
    let logoName = "系统logo"
    
    let UserNameKey = "name"
    let PwdKey = "pwd"
    let RmbPwdKey = "rmb_pwd"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //获取屏幕尺寸
        let mainSize = UIScreen.main.bounds.size
        //logoImage
        logoImage = UIImageView(frame: CGRect(x: mainSize.width/2-350/2, y: 70, width: 350, height: 120))
        logoImage.image = UIImage(named: "logoImage.png")
        logoImage.layer.masksToBounds = true
        self.view.addSubview(logoImage)

        //登录框背景
        let vLogin =  UIView(frame:CGRect(x: 30, y: 200, width: mainSize.width - 60, height: 160))
        vLogin.layer.borderWidth = 0.5
        vLogin.layer.borderColor = UIColor.lightGray.cgColor
        vLogin.backgroundColor = UIColor.white
        self.view.addSubview(vLogin)
        
        //用户名输入框
        txtUser = UITextField(frame:CGRect(x: 30, y: 30, width: vLogin.frame.size.width - 60, height: 44))
        txtUser.delegate = self
        txtUser.layer.cornerRadius = 5
        txtUser.layer.borderColor = UIColor.lightGray.cgColor
        txtUser.layer.borderWidth = 0.5
        txtUser.leftView = UIView(frame:CGRect(x: 0, y: 0, width: 44, height: 44))
        txtUser.leftViewMode = UITextFieldViewMode.always
        
        //用户名输入框左侧图标
        let imgUser =  UIImageView(frame:CGRect(x: 11, y: 11, width: 22, height: 22))
        imgUser.image = UIImage(named:"iconfont-user")
        txtUser.leftView!.addSubview(imgUser)
        vLogin.addSubview(txtUser)

        //密码输入框
        txtPwd = UITextField(frame:CGRect(x: 30, y: 90, width: vLogin.frame.size.width - 60, height: 44))
        txtPwd.delegate = self
        txtPwd.layer.cornerRadius = 5
        txtPwd.layer.borderColor = UIColor.lightGray.cgColor
        txtPwd.layer.borderWidth = 0.5
        txtPwd.isSecureTextEntry = true
        txtPwd.leftView = UIView(frame:CGRect(x: 0, y: 0, width: 44, height: 44))
        txtPwd.leftViewMode = UITextFieldViewMode.always
        
        //密码输入框左侧图标
        let imgPwd =  UIImageView(frame:CGRect(x: 11, y: 11, width: 22, height: 22))
        imgPwd.image = UIImage(named:"iconfont-password")
        txtPwd.leftView!.addSubview(imgPwd)
        vLogin.addSubview(txtPwd)

        //remember.isOn = false
        self.txtUser.text =
            UserDefaults.standard.value(forKey: "UserNameKey") as! String!
        
        //self.passwd.text = UserDefaults.standard.value(forKey: "PwdKey") as! String!
        self.remember.isOn = UserDefaults.standard.bool(forKey: "RmbPwdKey") as Bool!
        if remember.isOn {
            self.txtPwd.text = UserDefaults.standard.value(forKey: "PwdKey") as! String!
            
        }else{
            
        }
        
        remember.addTarget(self, action: #selector(self.swichChange), for: UIControlEvents.valueChanged)
//        userName.text = "lifh";
//        passwd.text = "lifh";
               // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        let serverName = EquipServer.sharedInstance().getServerName();
        serverButton.setTitle(serverName, for: .normal);
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    //点击选择服务器
    @IBAction func chooseServer(_ sender:UIButton){
        let chooseServerView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "server") as! ChooseServerTableViewController
        self.navigationController?.pushViewController(chooseServerView, animated: true);
    }


    func swichChange(switchState:UISwitch){
        if switchState.isOn{
            print("hh")
//            self.passwd.text = UserDefaults.standard.value(forKey: "PwdKey") as! String!
        }else{
            print("zhazha")
        }
    }
    
    //点击登录button
    @IBAction func equipInitView(_ sender: UIButton) {
        self.pleaseWait();
        //点击登录按钮，记住用户和密码
        //设置存储信息
        UserDefaults.standard.set(self.txtUser.text, forKey: "UserNameKey")
        UserDefaults.standard.set(self.txtPwd.text, forKey: "PwdKey")
        UserDefaults.standard.set(self.remember.isOn, forKey: "RmbPwdKey")
        //设置同步
        UserDefaults.standard.synchronize()
//开始登陆
        NetworkOperation.sharedInstance().Login(txtUser.text!, passwd: txtPwd.text!) { (any) in
            _ = NetworkOperation.sharedInstance().Status(){(any) in
                print(any)
                EquipManager.sharedInstance().defaultGroupId = any.object(forKey: NetworkOperation.NetConstant.DictKey.Status.Response.personGroupId) as! Int;
                _ = NetworkOperation.sharedInstance().getResources(-EquipManager.sharedInstance().defaultGroupId){ (any) in
                    let res = any.object(forKey: NetworkOperation.NetConstant.DictKey.GetResources.Response.resources) as! NSArray;
                    for tmp in res{
                        let name = (tmp as AnyObject).object(forKey: NetworkOperation.NetConstant.DictKey.GetResources.Response.ResourcesKey.displayName) as! String;
                        if(name.hasPrefix(self.equipName)){
                            let id = (tmp as AnyObject).object(forKey: NetworkOperation.NetConstant.DictKey.GetResources.Response.ResourcesKey.id) as! Int;
                            _ = EquipManager.sharedInstance(id);
                            _ = NetworkOperation.sharedInstance().getResources(id){
                                (any) in
                                let res = any.object(forKey: NetworkOperation.NetConstant.DictKey.GetResources.Response.resources) as! NSArray;
                                for tmp in res{
                                    let name = (tmp as AnyObject).object(forKey: NetworkOperation.NetConstant.DictKey.GetResources.Response.ResourcesKey.displayName) as! String;
                                    if(name.hasPrefix(self.trashName)){
                                        EquipManager.sharedInstance().defaultTrashId = (tmp as AnyObject).object(forKey: NetworkOperation.NetConstant.DictKey.GetResources.Response.ResourcesKey.id) as! Int;
                                    }
                                    if (name.hasPrefix(self.logoName)){
                                        EquipManager.sharedInstance().defaultLogoID =
                                        (tmp as AnyObject).object(forKey: NetworkOperation.NetConstant.DictKey.GetResources.Response.ResourcesKey.id) as! Int;
                                    }
                                }
                                if EquipManager.sharedInstance().defaultLogoID == 0 {
                                    _ = NetworkOperation.sharedInstance().createDir(EquipManager.sharedInstance().defaultGroupId, name: self.logoName, parentID: EquipManager.sharedInstance().rootId, handler: { (any) in
                                        let id = (any as! NSDictionary).value(forKey: NetworkOperation.NetConstant.DictKey.CreateDir.Response.id) as! Int
                                        EquipManager.sharedInstance().defaultLogoID = id
                                    })
                                }
                            }
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

