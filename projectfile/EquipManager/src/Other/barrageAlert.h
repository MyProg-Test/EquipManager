//
//  barrageAlert.h
//  WebLibrary_iPod
//
//  Created by Lifanhuan on 15/7/23.
//
//
#ifndef BARRAGEALERT_H
#define BARRAGEALERT_H
#import <UIKit/UIKit.h>

@interface barrageAlert : UIAlertView

-(id)initWithTitle:(NSString *)title message:(NSString *)message;
-(void)setWithTime:(NSTimeInterval)second;
-(void)show;

@end
#endif
