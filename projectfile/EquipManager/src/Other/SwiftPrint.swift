//
//  DrawImage.swift
//  DrawImage
//
//  Created by 李呱呱 on 16/9/6.
//  Copyright © 2016年 liguagua. All rights reserved.
// 210 118.4

import UIKit

extension UIView{
    func visitingCardImage() -> UIImage {
        let rect = self.frame;
        UIGraphicsBeginImageContext(rect.size);
        let context = UIGraphicsGetCurrentContext();
        self.layer.render(in: context!);
        let resultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext()
        print(self.layer.contents);
        self.layer.contents = nil;
        return resultImage!;
    }
}

extension UIViewController{
    func printImages(_ images:[UIImage]) {
        let pInfo : UIPrintInfo = UIPrintInfo.printInfo()
        pInfo.outputType = UIPrintInfoOutputType.photo
        pInfo.jobName = "test";
        //pInfo.orientation = UIPrintInfoOrientation.Landscape
        pInfo.duplex = .none;
        
        let printController = UIPrintInteractionController.shared
        printController.showsPaperSelectionForLoadedPapers = true;
        printController.showsNumberOfCopies = true;
        printController.printInfo = pInfo
        printController.printingItems = images;
        printController.present(animated: true) { (controller, complete, error) in
            if(!complete && error != nil){
                print(error);
                self.noticeError(error.debugDescription, autoClear: true, autoClearTime: 2);
                return ;
            }
            if(!complete){
                self.navigationItem.leftBarButtonItem = nil
                self.noticeInfo("取消打印", autoClear: true, autoClearTime: 2);
                
                return ;
            }
            self.navigationItem.leftBarButtonItem = nil
            self.noticeTop("打印任务已启动", autoClear: true, autoClearTime: 2);
        }
    }
    
    func printImage(image: UIImage) {
        let pInfo : UIPrintInfo = UIPrintInfo.printInfo()
        pInfo.outputType = UIPrintInfoOutputType.general
        pInfo.jobName = "test";
        //pInfo.orientation = UIPrintInfoOrientation.Landscape
        pInfo.duplex = .none;
        
        
        let printController = UIPrintInteractionController.shared
        printController.showsPaperSelectionForLoadedPapers = true;
        printController.showsNumberOfCopies = true;
        printController.printInfo = pInfo
        let imageView:UIImageView = UIImageView(image: image);
        imageView.frame = CGRect(x: 0, y: 0, width: 570, height: 803);
        imageView.contentMode = .scaleToFill
        printController.printFormatter = imageView.viewPrintFormatter();
        printController.printFormatter?.perPageContentInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        printController.present(animated: true) { (controller, complete, error) in
            if(!complete && error != nil){
                print(error);
                self.noticeError(error.debugDescription, autoClear: true, autoClearTime: 2);
                return ;
            }
            if(!complete){
                self.noticeInfo("取消打印", autoClear: true, autoClearTime: 2);
                return ;
            }
            print(printController.printPaper!.paperSize);
            self.noticeTop("打印任务已启动", autoClear: true, autoClearTime: 2);
        }
    }
}

class SwiftPrint {
    let row = 6;
    let column = 2;
    var errorInfo:Bool = true;
    var debugInfo:Bool = false;
//    var edgeOfPage:UIEdgeInsets{
//        
//    }
//    
    fileprivate static var _sharedInstance = SwiftPrint();
    //单例模式
    class func sharedInstance() -> SwiftPrint {
        return _sharedInstance;
    }
    
    func debugPrint(_ message: AnyObject) {
        if(debugInfo){
            print(message);
        }
    }
    
    func errorPrint(_ message: AnyObject) {
        if(errorInfo){
            print(message);
        }
    }
    //产生名片view
    func visitingCardView(_ dict:NSDictionary, key: [AnyObject], image:[UIImage], viewRect: CGRect, labelRect: [CGRect], imageRect: [CGRect]) -> UIView? {
        if dict.allKeys.count !=  key.count{
            errorPrint("字典数量(\(dict.allKeys))和键数量(\(key.count))不匹配" as AnyObject);
            return nil;
        }
        if(labelRect.count != 3){
            errorPrint("标签矩形数量(\(labelRect.count))不是3个" as AnyObject);
            return nil;
        }
        if image.count != imageRect.count {
            errorPrint("图片数量(\(image.count))和图片矩形数量(\(imageRect.count))不匹配" as AnyObject);
            return nil;
        }
        //let font = UIFont(descriptor: UIFontDescriptor(name: UIFontTextStyle.footnote.rawValue, size: 15), size: 35);
        let font = UIFont(descriptor: UIFontDescriptor(name: UIFontTextStyle.footnote.rawValue, size: 40), size: 24)
        let rtnView:UIView = UIView(frame: viewRect);
        for i in 0..<key.count {
            let value = dict.object(forKey: key[i]);
            let labelKey:UILabel = UILabel(frame: CGRect(x: labelRect[2].width + labelRect[0].minX, y: labelRect[2].height + CGFloat(i) * labelRect[0].maxY + labelRect[0].minY, width: labelRect[0].width, height: labelRect[0].height*2));
            let labelValue:UILabel = UILabel(frame: CGRect(x: labelRect[2].width + labelRect[1].minX, y: labelRect[2].height + CGFloat(i) * labelRect[1].maxY + labelRect[0].minY, width: labelRect[1].width, height: labelRect[1].height*2));
            labelKey.text = "\(key[i] as! String):";
            labelValue.text = value as? String;
            labelKey.font = font; 
            labelValue.font = font;
            labelKey.textColor = UIColor.brown;
            labelValue.textColor = UIColor.gray;
            //4.14
            labelValue.numberOfLines = 0;
            labelValue.lineBreakMode = .byCharWrapping;
            
            rtnView.addSubview(labelKey);
            rtnView.addSubview(labelValue);
        }
        
        for i in 0..<image.count {
            let imageView = UIImageView(frame: imageRect[i]);
            
            //imageView.layer.borderColor = UIColor.blackColor().CGColor;
            //imageView.layer.borderWidth = 1.0;
            //imageView.layer.masksToBounds = true;
            //imageView.layer.cornerRadius = 2.0;
            
            //imageView.layer.shadowOpacity = 1.0
            //imageView.layer.shadowColor = UIColor.blackColor().CGColor
            //imageView.layer.shadowOffset = CGSize(width: 1, height: 1)
            imageView.image = image[i];
            if i == 2{
                imageView.contentMode = .scaleAspectFit
            }else{
                imageView.contentMode = .scaleToFill
            }
            rtnView.addSubview(imageView);
        }
        return rtnView;
    }
    //根据view数组画名片

    func drawVisitingCardSet(_ viewImage: [UIImage]) -> [UIImage] {
        print(Thread.current);
        let rect = CGRect(x: 0, y: 0, width: viewImage[0].size.width * CGFloat(column), height: viewImage[0].size.height * CGFloat(row));
        var rtnImage:NSArray = NSArray();
        var breakFlag = false;
        var addFlag = false;
        for i in 0..<1000 {
            if breakFlag {
                break;
            }
            addFlag = false;
            UIGraphicsBeginImageContext(rect.size);
            
            var y:CGFloat = -40
           
        
            for r in 0..<row {
            
                if breakFlag {
                    break;
                }
                var x:CGFloat = 0
                for c in 0..<column {
                    let index = i*row*column+r*column+c
                    if(index >= viewImage.count){
                        breakFlag = true;
                        break;
                    }
                    let tmpImage = viewImage[index];
                    //(tmpImage as UIImage).dr
                    tmpImage.draw(in: CGRect(x: x, y: y, width: tmpImage.size.width, height: tmpImage.size.height));
                    addFlag = true;
                    x = x + viewImage[0].size.width + 0
                    //to draw view[i*row*column+r*column+c]
                }
                y = y + viewImage[0].size.height + 10
                
            }
            if addFlag {
                //画上线
//                UIGraphicsGetCurrentContext()!.setLineCap(CGLineCap.round);
//                UIGraphicsGetCurrentContext()!.setLineWidth(1.0);
//                UIGraphicsGetCurrentContext()!.setAllowsAntialiasing(true);
//                UIGraphicsGetCurrentContext()!.setStrokeColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0);
//                UIGraphicsGetCurrentContext()!.beginPath();
//                for k in 1..<row {
//                    UIGraphicsGetCurrentContext()!.move(to: CGPoint(x: 0, y: CGFloat(k) * rect.height/CGFloat(row)));
//                    UIGraphicsGetCurrentContext()!.addLine(to: CGPoint(x: rect.width, y: CGFloat(k) * rect.height/CGFloat(row)));
//                }
//                for k in 1..<column {
//                    UIGraphicsGetCurrentContext()!.move(to: CGPoint(x: CGFloat(k) * rect.width/CGFloat(column), y: 0));
//                    UIGraphicsGetCurrentContext()!.addLine(to: CGPoint(x: CGFloat(k) * rect.width/CGFloat(column), y: rect.height));
//                }
//                UIGraphicsGetCurrentContext()!.strokePath();
                
                rtnImage = rtnImage.adding(UIGraphicsGetImageFromCurrentImageContext()!) as NSArray;
            }
            UIGraphicsEndImageContext();
        }
        
        
        return rtnImage as! [UIImage];
    }
    
    func labelCard(dict: [String: String], key: [String],qrImage: UIImage, logoImage: UIImage, barImage: UIImage) -> UIImage {
        //let viewRect = CGRect(x: 0, y: 0, width: 840, height: 475.2);
        //11.5
        //如果到顶了，改高度和宽度  
        let topShift = 50+30;
        let viewRect = CGRect(x: 0, y: 0, width: 840, height: 470);
        //let headerRect = CGRect(x: 0, y: 0, width: 60, height: 40)
        let headerRect = CGRect(x: 0, y: 0 , width: 60, height: 20 + topShift)
        //let headerRect = CGRect(x: 0, y: 0, width: 0, height: 0)
        //let keyRect = CGRect(x: 0, y: 0, width: 280, height: 55);
        //height行间距
        let keyRect = CGRect(x: 24, y: 15 , width: 280, height: 32);
        //200--->150
        //let valueRect = CGRect(x: 150, y: 0, width: 280, height: 55);
        
        let valueRect = CGRect(x: 89, y: 15 , width: 280, height: 32);
        //let qrImageRect = CGRect(x: 520, y: 30, width: 270, height: 270);
        let qrImageRect = CGRect(x: 510, y: 18 + topShift, width: 240, height: 270);
        //let barImageRect = CGRect(x: 300, y: 310, width: 510, height: 160);
        let barImageRect = CGRect(x: 280, y: 270 + topShift, width: 490, height: 120);
        //let logoImageRect = CGRect(x: 90, y: 310, width: 150, height: 150);
        let logoImageRect = CGRect(x: 90, y: 270 + topShift, width: 110, height: 110);
        
        
        return visitingCardView(dict as NSDictionary , key: key as [AnyObject], image: [qrImage, barImage,logoImage], viewRect: viewRect, labelRect: [keyRect, valueRect, headerRect], imageRect: [qrImageRect, barImageRect,logoImageRect])!.visitingCardImage();
    }
    
    func singlePrint(image: UIImage, row: Int) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: image.size.width * CGFloat(self.column), height: image.size.height * CGFloat(self.row));
        UIGraphicsBeginImageContext(rect.size);
        for c in stride(from: 0, to: self.column, by: 1){
            image.draw(in: CGRect(x: CGFloat(c) * image.size.width, y: CGFloat(row) * image.size.height, width: image.size.width, height: image.size.height));
            //to draw view[i*row*column+r*column+c]
        }
        UIGraphicsGetCurrentContext()!.setLineCap(CGLineCap.round);
        UIGraphicsGetCurrentContext()!.setLineWidth(1.0);
        UIGraphicsGetCurrentContext()!.setAllowsAntialiasing(true);
        UIGraphicsGetCurrentContext()!.setStrokeColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0);
        UIGraphicsGetCurrentContext()!.beginPath();
        for k in 1..<self.row {
            UIGraphicsGetCurrentContext()!.move(to: CGPoint(x: 0, y: CGFloat(k) * rect.height/CGFloat(self.row)));
            UIGraphicsGetCurrentContext()!.addLine(to: CGPoint(x: rect.width, y: CGFloat(k) * rect.height/CGFloat(self.row)));
        }
        for k in 1..<self.column {
            UIGraphicsGetCurrentContext()!.move(to: CGPoint(x: CGFloat(k) * rect.width/CGFloat(self.column), y: 0));
            UIGraphicsGetCurrentContext()!.addLine(to: CGPoint(x: CGFloat(k) * rect.width/CGFloat(self.column), y: rect.height));
        }
        UIGraphicsGetCurrentContext()!.strokePath();
        
        let rtnImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!;
        UIGraphicsEndImageContext();
        
        
        return rtnImage;
    }

    
}
