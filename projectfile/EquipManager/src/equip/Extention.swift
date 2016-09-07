//
//  Extention.swift
//  TestModule
//
//  Created by 李呱呱 on 16/8/29.
//  Copyright © 2016年 liguagua. All rights reserved.
//

import UIKit

extension String{
    var asURLConvertible: String{
        return NetworkOperation.NetConstant.serverProtocol + NetworkOperation.NetConstant.serverURL + self
    }
    var qrImage:UIImage{
        return qrImageWithImage();
    }
    
    var barCode:UIImage{
        let stringData = self.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
        // 创建一个条形码的滤镜
        let barCodeFilter = CIFilter(name: "CICode128BarcodeGenerator")!
        barCodeFilter.setValue(stringData, forKey: "inputMessage");
        let barCodeCIImage = barCodeFilter.outputImage
        // 创建一个颜色滤镜,黑白色
        let colorFilter = CIFilter(name: "CIFalseColor")!
        colorFilter.setDefaults()
        colorFilter.setValue(barCodeCIImage, forKey: "inputImage")
        colorFilter.setValue(CIColor(red: 0, green: 0, blue: 0), forKey: "inputColor0")
        colorFilter.setValue(CIColor(red: 1, green: 1, blue: 1), forKey: "inputColor1")
        //返回条形码image
        let codeImage = UIImage(CIImage: colorFilter.outputImage!.imageByApplyingTransform(CGAffineTransformMakeScale(20, 20)))
        return codeImage;
    }
    
    func qrImageWithImage(image:UIImage? = nil) -> UIImage {
        let stringData = self.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
        // 创建一个二维码的滤镜
        let qrFilter = CIFilter(name: "CIQRCodeGenerator")!
        qrFilter.setValue(stringData, forKey: "inputMessage")
        qrFilter.setValue("H", forKey: "inputCorrectionLevel")
        let qrCIImage = qrFilter.outputImage
        // 创建一个颜色滤镜,黑白色
        let colorFilter = CIFilter(name: "CIFalseColor")!
        colorFilter.setDefaults()
        colorFilter.setValue(qrCIImage, forKey: "inputImage")
        colorFilter.setValue(CIColor(red: 0, green: 0, blue: 0), forKey: "inputColor0")
        colorFilter.setValue(CIColor(red: 1, green: 1, blue: 1), forKey: "inputColor1")
        // 返回二维码image
        let codeImage = UIImage(CIImage: colorFilter.outputImage!.imageByApplyingTransform(CGAffineTransformMakeScale(20, 20)))
        // 通常,二维码都是定制的,中间都会放想要表达意思的图片
        if let iconImage = image {
            let rect = CGRectMake(0, 0, codeImage.size.width, codeImage.size.height)
            UIGraphicsBeginImageContext(rect.size)
            
            codeImage.drawInRect(rect)
            let avatarSize = CGSizeMake(rect.size.width * 0.25, rect.size.height * 0.25)
            let x = (rect.width - avatarSize.width) * 0.5
            let y = (rect.height - avatarSize.height) * 0.5
            iconImage.drawInRect(CGRectMake(x, y, avatarSize.width, avatarSize.height))
            let resultImage = UIGraphicsGetImageFromCurrentImageContext()
            
            UIGraphicsEndImageContext()
            return resultImage
        }
        return codeImage
    }
}


