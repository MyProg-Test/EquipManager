//
//  QRCodeScanViewController.swift
//  EquipManager
//
//  Created by 李呱呱 on 2016/11/9.
//  Copyright © 2016年 LY. All rights reserved.
//

import UIKit
import AVFoundation
//好像这是个没用的文件- - by 11.13
class QRCodeScanViewController: UIViewController,AVCaptureMetadataOutputObjectsDelegate,UIAlertViewDelegate {

    var scanRectView:UIView!
    var device:AVCaptureDevice!
    var input:AVCaptureDeviceInput!
    var output:AVCaptureMetadataOutput!
    var session:AVCaptureSession!
    var preview:AVCaptureVideoPreviewLayer!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func scan(sender: AnyObject) {
        do{
            self.device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
            
            self.input = try AVCaptureDeviceInput(device: device)
            
            self.output = AVCaptureMetadataOutput()
            output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            
            self.session = AVCaptureSession()
            if UIScreen.main.bounds.size.height < 500 {
                self.session.sessionPreset = AVCaptureSessionPreset640x480
            }else{
                self.session.sessionPreset = AVCaptureSessionPresetHigh
            }
            
            self.session.addInput(self.input)
            self.session.addOutput(self.output)
            
            self.output.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
            
            //计算中间可探测区域
            let windowSize:CGSize = UIScreen.main.bounds.size
            let scanSize:CGSize = CGSize(width: windowSize.width*3/4, height: windowSize.height*3/4)
            var scanRect:CGRect = CGRect(x: (windowSize.width-scanSize.width)/2, y: (windowSize.height-scanSize.height)/2, width: scanSize.width, height: scanSize.height)
            //计算rectOfInterest 注意x，y交换位置
            scanRect = CGRect(x: scanRect.origin.y/windowSize.height, y: scanRect.origin.x/windowSize.width, width: scanRect.size.height/windowSize.height, height: scanRect.size.width/windowSize.width)
            
            //设置可探测区域
            self.output.rectOfInterest = scanRect
            
            self.preview = AVCaptureVideoPreviewLayer(session: self.session)
            self.preview.videoGravity = AVLayerVideoGravityResizeAspectFill
            self.view.layer.insertSublayer(self.preview, at: 0)
            
            //添加中间的探测区域绿框
            self.scanRectView = UIView()
            self.view.addSubview(self.scanRectView)
            self.scanRectView.frame = CGRect(x: 0, y: 0, width: scanSize.width, height: scanSize.height)
            self.scanRectView.center = CGPoint(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY)
            self.scanRectView.layer.borderColor = UIColor.green.cgColor
            self.scanRectView.layer.borderWidth = 1
            
            //开始捕获
            self.session.startRunning()
            
        }catch _ as NSError{
            let errorAlert = UIAlertController(title: "提醒", message: "请在iPhone的\"设置-隐私-相机\"选项中,允许本程序访问您的相机", preferredStyle: .alert)
            errorAlert.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.cancel, handler: { (UIAlertAction) in
                print("确定")
            }))
            self.present(errorAlert, animated: true, completion: nil)
        }
        
    }
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        var stringValue: String?
        if metadataObjects.count > 0{
            let metadataObject = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
            stringValue = metadataObject.stringValue
            
            if stringValue != nil{
                self.session.stopRunning()
            }
        }
        self.session.stopRunning()
        
        //输出结果
        let alertView = UIAlertController(title: "二维码", message: stringValue, preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title: "查看设备", style: .default, handler: { (UIAlertAction) in
            self.lookEquip()
        }))
        alertView.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { (UIAlertAction) in
            self.session.startRunning()
        }))
        
        self.present(alertView, animated: true, completion: nil)
    }
    
    func lookEquip(){
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
