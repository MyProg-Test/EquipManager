//
//  codeScanner.m
//  WebLibrary_iPod
//
//  Created by Lifanhuan on 15/7/23.
//
//

#import "codeScanner.h"
#import "barrageAlert.h"

@implementation codeScanner
@synthesize captureInput;
@synthesize captureDevice;
@synthesize captureOutput;
@synthesize captureSession;
@synthesize type;
@synthesize videoPreviewLayer;
@synthesize complete;

-(void) viewDidLoad{
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    //[self menuToolBar];
    self.title = @"Scanner";
    self.view.backgroundColor = [UIColor grayColor];
    UILabel *labIntroduction = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 290, 50)];
    labIntroduction.backgroundColor = [UIColor clearColor];
    labIntroduction.numberOfLines = 2;
    labIntroduction.textColor = [UIColor whiteColor];
    labIntroduction.text = @"将二维码图像置于矩形方框内，离手机摄像头10CM左右，系统会自动识别。";
    [self.view addSubview:labIntroduction];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width-300)/2, ([UIScreen mainScreen].bounds.size.height-self.navigationController.navigationBar.bounds.size.height-300)/2, 300, 300)];
    imageView.layer.borderColor = [UIColor greenColor].CGColor;
    imageView.layer.borderWidth = 1;
    [self.view addSubview:imageView];
}

-(void) back{
    [self.navigationController popViewControllerAnimated:NO];
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setupCamera];
    [self.captureSession startRunning];
}

-(void)setupCamera{
    NSError *error = nil;
    self.captureInput = [[AVCaptureDeviceInput alloc] initWithDevice:[AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo] error:&error];
    if(error){
        barrageAlert * alert = [[barrageAlert alloc] initWithTitle:@"❌错误消息" message: error.description];
        [alert setWithTime:2.0f];
        [alert show];
        return;
    }
    self.captureSession = [[AVCaptureSession alloc] init];
    self.captureSession.sessionPreset = AVCaptureSessionPresetHigh;
    if([self.captureSession canAddInput:self.captureInput]){
        [self.captureSession addInput:self.captureInput];
    }
    self.videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.captureSession];
    self.videoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    self.videoPreviewLayer.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width-300)/2, ([UIScreen mainScreen].bounds.size.height-self.navigationController.navigationBar.bounds.size.height-300)/2, 300, 300);
    [self.view.layer insertSublayer:self.videoPreviewLayer atIndex:0];
    self.captureOutput = [[AVCaptureMetadataOutput alloc] init];
    [self.captureOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    if([self.captureSession canAddOutput:self.captureOutput]){
        [self.captureSession addOutput:self.captureOutput];
        self.captureOutput.metadataObjectTypes = self.type;
    }
    [self.captureSession startRunning];
}

-(void) setWithType:(NSArray*)type{
    self.type = type;
}

-(void) setWithComplete:(void (^)(id))complete{
    self.complete = complete;
}

-(void) captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{

    if(metadataObjects != nil && [metadataObjects count] > 0){
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        if(self.complete != nil){
            self.complete(metadataObj);
        }
        [self.captureSession stopRunning];
    }
}

//-(void) menuToolBar{
//    UIImage* img1 = [UIImage imageNamed:@"back"];
//    UIImage* img2 = [UIImage imageNamed:@"home"];
//    UIBarButtonItem* backButton = [[UIBarButtonItem alloc]initWithImage:img1 style:UIBarButtonItemStylePlain target:self action:@selector(backPressed)];
// 
//    UIBarButtonItem* flexItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
//    UIBarButtonItem* homeItem = [[UIBarButtonItem alloc]initWithImage:img2 style:UIBarButtonItemStylePlain target:self action:@selector(homePressed)];
//    
//    NSArray* items = [[NSArray alloc]initWithObjects:(backButton,flexItem,homeItem,flexItem,flexItem,flexItem,flexItem), nil];
//    self.toolbarItems = items;
//}
//
//-(void) backPressed{
//    
//}
//
//-(void) homePressed{
//    
//}

@end
