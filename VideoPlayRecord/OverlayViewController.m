//
//  OverlayViewController.m
//  VideoPlayRecord
//
//  Created by Mac on 8/24/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import "OverlayViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <MediaPlayer/MediaPlayer.h>


@interface OverlayViewController ()

@property (nonatomic, strong) AVAsset *asset1;

@property (nonatomic, strong) UISlider *sizeBorderSlider;
@property (nonatomic, strong) UIButton *loadAssetButton;
@property (nonatomic, strong) UIButton *saveButton;

@end

@implementation OverlayViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Set navigation item text
    self.title = @"Overlay";
    
    //set background color
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    //Slider
    self.sizeBorderSlider = [[UISlider alloc] initWithFrame:CGRectMake(5,
                                                                 self.view.frame.size.height - 130,
                                                                 self.view.frame.size.width - 10,
                                                                 25)];
    
    [self.sizeBorderSlider setMaximumValue:100];
    
    
    //load button
    self.loadAssetButton = [[UIButton alloc] initWithFrame:CGRectMake(5,
                                                                       self.view.frame.size.height - 80,
                                                                       self.view.frame.size.width - 10,
                                                                       35)];
    [self.loadAssetButton setTitle:@"Load Asset" forState:UIControlStateNormal];
    [self.loadAssetButton addTarget:self action:@selector(loadAsset) forControlEvents:UIControlEventTouchUpInside];
    [self.loadAssetButton setBackgroundColor:[UIColor grayColor]];
    
    //save button
    self.saveButton = [[UIButton alloc] initWithFrame:CGRectMake(5,
                                                                         self.view.frame.size.height - 40,
                                                                         self.view.frame.size.width - 10,
                                                                         35)];
    [self.saveButton setTitle:@"Save video" forState:UIControlStateNormal];
    [self.saveButton addTarget:self action:@selector(saveVideo) forControlEvents:UIControlEventTouchUpInside];
    [self.saveButton setBackgroundColor:[UIColor grayColor]];
    
    
    [self.view addSubview:self.sizeBorderSlider];
    [self.view addSubview:self.loadAssetButton];
    [self.view addSubview:self.saveButton];

}


-(void)loadAsset
{
    
}

-(void)saveVideo
{
    
}







- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

    
}



@end
