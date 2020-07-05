//
//  ImageGrayViewController.m
//  ImageOperate-OC
//
//  Created by song on 2020/7/1.
//  Copyright © 2020 ericstone. All rights reserved.
//

#import "ImageGrayViewController.h"
#import "UIImage+PixelMix.h"

@interface ImageGrayViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageOriView;
@property (weak, nonatomic) IBOutlet UIImageView *imageGrayView;

@end

@implementation ImageGrayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)turn:(UIButton *)sender {
//    UIImage *image = [UIImage imageNamed:@"panda.jpg"];
//    UIImage *new = [image grayImage:0];
//    _imageGrayView.image = new;
    
    UIImage *new = [_imageOriView.image imageToGray:2];
//    UIImage *image = [UIImage imageNamed:@"panda.jpg"];
//     UIImage *new = [_imageOriView.image convertToGrayscale:image];
    _imageGrayView.image = new;
    NSLog(@"ssss");
}

@end
