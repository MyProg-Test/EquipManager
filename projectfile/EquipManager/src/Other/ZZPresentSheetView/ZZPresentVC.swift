//
//  SecondViewController.swift
//  TransitionDemo
//
//  Created by duzhe on 16/3/14.
//  Copyright © 2016年 dz. All rights reserved.
//

import UIKit

private let kRowHeight:CGFloat = 52
private let cellIdetiter = "secondCell"
class ZZPresentVC: UIViewController,UITableViewDelegate,UITableViewDataSource{

    fileprivate var items:[String] = []
    
    fileprivate var clickItems:((_ item:Int)->())?
    init(items:[String]){
        self.items = items
//        self.items.append("取消")
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    var tableView:UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.clear
        self.preferredContentSize = CGSize(width: self.view.bounds.size.width, height: CGFloat(items.count+1)*kRowHeight+5)
        tableView = UITableView()
        self.view.addSubview(tableView)
        tableView.frame = self.view.bounds
        self.tableView.separatorInset = UIEdgeInsets(top: 0, left:0, bottom: 0, right: 0)
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.isScrollEnabled = false
        tableView.rowHeight = kRowHeight
        tableView.register(PresentCell.self, forCellReuseIdentifier: cellIdetiter)
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.backgroundColor = UIColor.clear
        let blurView = ZZBlurView()
        tableView.backgroundView = blurView
    }
    
    func clickItemHandle(_ clickItems:((_ itemIndex:Int)->())?){
        self.clickItems = clickItems
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdetiter, for: indexPath) as! PresentCell
        if (indexPath as NSIndexPath).section == 0{
            cell.name = items[(indexPath as NSIndexPath).row]
            cell.isCancel = false
            
        }else{
            cell.name = "取消"
            cell.isCancel = true
        }
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0{
            return nil
        }else{
            
            let v = UIView()
            v.backgroundColor = UIColor(white: 0.5, alpha: 0.25)
            return v
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return items.count
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0{
            return 0
        }else{
            return 5
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        self.dismiss(animated: true){ [weak self] in
            guard let strongSelf = self else { return }
            if (indexPath as NSIndexPath).section == 0{
                strongSelf.clickItems?( (indexPath as NSIndexPath).row )
            }else{
                strongSelf.clickItems?( strongSelf.items.count )
            }
            
        }
    }

}


extension UIViewController{
    
    
    func zz_presentSheetController(_ items:[String],clickItemHandler:((_ index:Int)->())?,completion:(() -> ())? = nil){
        // 这个相当于toViewController
        let svc:ZZPresentVC = ZZPresentVC(items: items)
        svc.clickItemHandle { (itemIndx) -> () in
            clickItemHandler?(itemIndx)
        }
        // 创建PresentationController
        let customPresentationController:CustomPresentationController = CustomPresentationController(presentedViewController: svc, presenting: self)
        
        svc.transitioningDelegate = customPresentationController
        
        self.present(svc, animated: true, completion: completion)
        
    }
    
}


