//
//  barrageAlert.m
//  WebLibrary_iPod
//
//  Created by Lifanhuan on 15/7/23.
//
//

#import "barrageAlert.h"

@implementation barrageAlert
-(id)initWithTitle:(NSString *)title message:(NSString *)message{
    if(self = [super initWithTitle:title message:message delegate:nil cancelButtonTitle:nil otherButtonTitles: nil]){
        return self;
    }
    return nil;
}

-(void) dismissAlert:(NSTimer*)Timer{
    UIAlertView *alert = [Timer userInfo];
    [alert dismissWithClickedButtonIndex:0 animated:YES];
}

-(void)setWithTime:(NSTimeInterval)second{
    [NSTimer scheduledTimerWithTimeInterval:second target:self selector:@selector(dismissAlert:) userInfo:self repeats:NO];
}
-(void)show{
    [super show];
}
@end
