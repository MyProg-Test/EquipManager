//
//  DrawImage.swift
//  DrawImage
//
//  Created by LY on 16/9/6.
//  Copyright © 2016年 LY. All rights reserved.
// 210 118.4

import UIKit

extension UIView{
    func visitingCardImage() -> UIImage {
        let rect = self.frame;
        UIGraphicsBeginImageContext(rect.size);
        let context = UIGraphicsGetCurrentContext();
        self.layer.renderInContext(context!);
        let resultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext()
        print(self.layer.contents);
        self.layer.contents = nil;
        return resultImage;
    }
}

extension UIViewController{
    func printImages(images:[UIImage]) {
        let pInfo : UIPrintInfo = UIPrintInfo.printInfo()
        pInfo.outputType = UIPrintInfoOutputType.Photo
        pInfo.jobName = "test";
        //pInfo.orientation = UIPrintInfoOrientation.Landscape
        pInfo.duplex = .None;
        
        let printController = UIPrintInteractionController.sharedPrintController()
        
        printController.printInfo = pInfo
        printController.showsPageRange = true
        printController.printingItems = images;
        printController.presentAnimated(true) { (controller, complete, error) in
            if(!complete && error != nil){
                print(error);
                self.noticeError(error!.description, autoClear: true, autoClearTime: 2);
                return ;
            }
            if(!complete){
                self.noticeInfo("取消打印", autoClear: true, autoClearTime: 2);
                return ;
            }
            self.noticeTop("打印任务已启动", autoClear: true, autoClearTime: 2);
        }
    }
}

class SwiftPrint {
    let row = 5;
    let column = 2;
    var errorInfo:Bool = true;
    var debugInfo:Bool = false;
    
    private static var _sharedInstance = SwiftPrint();
    
    class func sharedInstance() -> SwiftPrint {
        return _sharedInstance;
    }
    
    func debugPrint(message: AnyObject) {
        if(debugInfo){
            print(message);
        }
    }
    
    func errorPrint(message: AnyObject) {
        if(errorInfo){
            print(message);
        }
    }
    
    func visitingCardView(dict:NSDictionary, key: [AnyObject], image:[UIImage], viewRect: CGRect, labelRect: [CGRect], imageRect: [CGRect]) -> UIView? {
        if dict.allKeys.count !=  key.count{
            errorPrint("字典数量(\(dict.allKeys))和键数量(\(key.count))不匹配");
            return nil;
        }
        if(labelRect.count != 2){
            errorPrint("标签矩形数量(\(labelRect.count))不是2个");
            return nil;
        }
        if image.count != imageRect.count {
            errorPrint("图片数量(\(image.count))和图片矩形数量(\(imageRect.count))不匹配");
            return nil;
        }
        let font = UIFont(descriptor: UIFontDescriptor(name: UIFontTextStyleFootnote, size: 15), size: 35);
        let rtnView:UIView = UIView(frame: viewRect);
        for i in 0..<key.count {
            let value = dict.objectForKey(key[i]);
            let labelKey:UILabel = UILabel(frame: CGRectMake(labelRect[0].minX, CGFloat(i) * labelRect[0].maxY + labelRect[0].minY, labelRect[0].width, labelRect[0].height));
            let labelValue:UILabel = UILabel(frame: CGRectMake(labelRect[1].minX, CGFloat(i) * labelRect[1].maxY + labelRect[0].minY, labelRect[1].width, labelRect[1].height));
            labelKey.text = key[i] as? String;
            labelValue.text = value as? String;
            labelKey.font = font;
            labelValue.font = font;
            labelKey.textColor = UIColor.blackColor();
            labelValue.textColor = UIColor.blackColor();
            rtnView.addSubview(labelKey);
            rtnView.addSubview(labelValue);
        }
        
        for i in 0..<image.count {
            let imageView = UIImageView(frame: imageRect[i]);
            imageView.layer.shadowOpacity = 0.8
            imageView.layer.shadowColor = UIColor.blackColor().CGColor
            imageView.layer.shadowOffset = CGSize(width: 1, height: 1)
            imageView.image = image[i];
            imageView.contentMode = .ScaleAspectFit;
            rtnView.addSubview(imageView);
        }
        return rtnView;
    }
    
    func drawVisitingCardSet(view: [UIView]) -> [UIImage] {
        let rect = CGRectMake(0, 0, view[0].frame.width * CGFloat(column), view[0].frame.height * CGFloat(row));
        var rtnImage:NSArray = NSArray();
        var breakFlag = false;
        var addFlag = false;
        var viewImage:NSArray = NSArray();
        for v in view {
            viewImage = viewImage.arrayByAddingObject(v.visitingCardImage());
        }
        for i in 0..<1000 {
            if breakFlag {
                break;
            }
            addFlag = false;
            UIGraphicsBeginImageContext(rect.size);
            for r in 0..<row {
                if breakFlag {
                    break;
                }
                for c in 0..<column {
                    let index = i*row*column+r*column+c
                    if(index >= viewImage.count){
                        breakFlag = true;
                        break;
                    }
                    let tmpView = view[index];
                    let tmpImage = viewImage[index];
                    tmpImage.drawInRect(CGRectMake(CGFloat(c) * tmpView.frame.width, CGFloat(r) * tmpView.frame.height, tmpView.frame.width, tmpView.frame.height));
                    addFlag = true;
                    //to draw view[i*row*column+r*column+c]
                }
            }
            
            if addFlag {
                //画上线
                CGContextSetLineCap(UIGraphicsGetCurrentContext(), CGLineCap.Round);
                CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 1.0);
                CGContextSetAllowsAntialiasing(UIGraphicsGetCurrentContext(), true);
                CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 0.0, 0.0, 0.0, 1.0);
                CGContextBeginPath(UIGraphicsGetCurrentContext());
                for k in 1..<row {
                    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), 0, CGFloat(k) * rect.height/CGFloat(row));
                    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), rect.width, CGFloat(k) * rect.height/CGFloat(row));
                }
                for k in 1..<column {
                    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), CGFloat(k) * rect.width/CGFloat(column), 0);
                    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), CGFloat(k) * rect.width/CGFloat(column), rect.height);
                }
                CGContextStrokePath(UIGraphicsGetCurrentContext());
                
                
                rtnImage = rtnImage.arrayByAddingObject(UIGraphicsGetImageFromCurrentImageContext());
            }
            UIGraphicsEndImageContext();
        }
        
        
        return rtnImage as! [UIImage];
    }
    
}
