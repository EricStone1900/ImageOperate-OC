//
//  ImageCompressViewController.m
//  ImageOperate-OC
//
//  Created by song on 2020/7/1.
//  Copyright © 2020 ericstone. All rights reserved.
//

#import "ImageCompressViewController.h"
#import "UIImage+Compress.h"


@interface ImageCompressViewController ()

@end

@implementation ImageCompressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)compressImage {
    UIImage *image = [UIImage imageNamed:@"horses.jpg"];
    UIImage *compressedImg = [image compressWithCycleQulity:100*1000];
    NSData *data = UIImageJPEGRepresentation(compressedImg, 1.0);
    NSLog(@"compressed length = %ld",data.length);
}

@end
