//
//  AnimationsViewController.m
//  VideoPlayRecord
//
//  Created by Mac on 8/23/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import "AnimationsViewController.h"
#import "BorderViewController.h"

@interface AnimationsViewController ()


@property (nonatomic,strong) UIButton *bordersButton;
@property (nonatomic,strong) UIButton *overlayButton;
@property (nonatomic,strong) UIButton *subtitleButton;
@property (nonatomic,strong) UIButton *tiltButton;
@property (nonatomic,strong) UIButton *animationButton;


@end



@implementation AnimationsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Set navigation item text
    self.title = @"Animations";
    
    //set background color
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    //Menu
    [self addMenuItems];
    
    
}

-(void) addMenuItems
{
    int bWidth  = self.view.frame.size.width - 10;
    int bHeight = self.view.frame.size.height/14;
    int centerX = (self.view.frame.size.width/2) - (bWidth/2);
    int yOffset = 35;
    int centerY = self.navigationController.navigationBar.frame.size.height + yOffset;
    
    
    //Border
    self.bordersButton = [[UIButton alloc] initWithFrame:CGRectMake(centerX,
                                                                    centerY,
                                                                    bWidth,
                                                                    bHeight)];
    [self.bordersButton setTitle:@"Add Border" forState:UIControlStateNormal];
    [self.bordersButton addTarget:self action:@selector(addBordertoVideo) forControlEvents:UIControlEventTouchUpInside];
    [self.bordersButton setBackgroundColor:[UIColor grayColor]];
    
    
    //Overlay
    self.overlayButton = [[UIButton alloc] initWithFrame:CGRectMake(centerX,
                                                                    centerY * 2,
                                                                    bWidth,
                                                                    bHeight)];
    [self.overlayButton setTitle:@"Add Overlay" forState:UIControlStateNormal];
    [self.overlayButton addTarget:self action:@selector(addOverlaytoVideo) forControlEvents:UIControlEventTouchUpInside];
    [self.overlayButton setBackgroundColor:[UIColor grayColor]];
    
    //Subtitle
    self.subtitleButton = [[UIButton alloc] initWithFrame:CGRectMake(centerX,
                                                                    centerY * 3,
                                                                    bWidth,
                                                                    bHeight)];
    [self.subtitleButton setTitle:@"Add Subtitle" forState:UIControlStateNormal];
    [self.subtitleButton addTarget:self action:@selector(addSubtitletoVideo) forControlEvents:UIControlEventTouchUpInside];
    [self.subtitleButton setBackgroundColor:[UIColor grayColor]];
    
    //Tilt
    self.tiltButton = [[UIButton alloc] initWithFrame:CGRectMake(centerX,
                                                                     centerY * 4,
                                                                     bWidth,
                                                                     bHeight)];
    [self.tiltButton setTitle:@"Tilt video" forState:UIControlStateNormal];
    [self.tiltButton addTarget:self action:@selector(tiltVideo) forControlEvents:UIControlEventTouchUpInside];
    [self.tiltButton setBackgroundColor:[UIColor grayColor]];
   
    
    //Animation
    self.animationButton = [[UIButton alloc] initWithFrame:CGRectMake(centerX,
                                                                 centerY * 5,
                                                                 bWidth,
                                                                 bHeight)];
    [self.animationButton setTitle:@"Add animation" forState:UIControlStateNormal];
    [self.animationButton addTarget:self action:@selector(addAnimationtoVideo) forControlEvents:UIControlEventTouchUpInside];
    [self.animationButton setBackgroundColor:[UIColor grayColor]];
    
    
    
    
    [self.view addSubview:self.bordersButton];
    [self.view addSubview:self.overlayButton];
    [self.view addSubview:self.subtitleButton];
    [self.view addSubview:self.tiltButton];
    [self.view addSubview:self.animationButton];
}


-(void)addBordertoVideo
{
    BorderViewController *bvc = [[BorderViewController alloc]init];
    [self.navigationController pushViewController:bvc animated:YES];
    
}


-(void)addOverlaytoVideo
{
    
}


-(void)addSubtitletoVideo
{
    
}


-(void)tiltVideo
{
    
}


-(void)addAnimationtoVideo
{
    
}










- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}



@end
