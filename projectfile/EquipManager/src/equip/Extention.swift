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
        let stringData = self.dataUsingEncoding(NSUTF8StringEncoding,
                                                allowLossyConversion: false)
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
        let codeImage = UIImage(CIImage: colorFilter.outputImage!
            .imageByApplyingTransform(CGAffineTransformMakeScale(5, 5)))
        return codeImage
    }
}


