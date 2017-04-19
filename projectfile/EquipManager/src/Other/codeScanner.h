//
//  codeScanner.h
//  WebLibrary_iPod
//
//  Created by Lifanhuan on 15/7/23.
//
//
#ifndef CODESCANNER_H
#define CODESCANNER_H

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface codeScanner : UIViewController
@property(retain,atomic) AVCaptureSession *captureSession;
@property(retain,atomic) AVCaptureDevice *captureDevice;
@property(retain,atomic) AVCaptureDeviceInput *captureInput;
@property(retain,atomic) AVCaptureMetadataOutput *captureOutput;
@property(retain,atomic) AVCaptureVideoPreviewLayer *videoPreviewLayer;
@property(retain,atomic) NSArray *type;
@property(copy,atomic) void (^complete)(id);


-(void) setWithType:(NSArray*)type;
-(void) setWithComplete:(void (^)(id))complete;
@end
#endif
