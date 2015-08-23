//
//  ViewController.m
//  VideoPlayRecord
//
//  Created by Mac on 8/20/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import "MenuViewController.h"
#import "PlayVideoViewController.h"
#import "PlayVideoWithAVViewController.h"
#import "RecordVideoViewController.h"
#import "MergeVideosViewController.h"
#import "AnimationsViewController.h"

@interface MenuViewController () <UIImagePickerControllerDelegate>


@property (nonatomic, strong) UIButton *loadVideostoCameraRollButton;
@property (nonatomic, strong) UIButton *playfromRollButton;
@property (nonatomic, strong) UIButton *playwithAVButton;
@property (nonatomic, strong) UIButton *recordVideoButton;
@property (nonatomic, strong) UIButton *mergeVideosButton;
@property (nonatomic, strong) UIButton *overlayandAnimationsButton;


@end



@implementation MenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Set navigation item text
    self.title = @"Menu";
    
    //set Background
    self.view.backgroundColor = [UIColor whiteColor];
    
    //Add Menu Items
    [self addMenuItems];
    
    
}



#pragma mark - menu
- (void) addMenuItems
{
    int bWidth  = self.view.frame.size.width - 10;
    int bHeight = self.view.frame.size.height/14;
    int centerX = (self.view.frame.size.width/2) - (bWidth/2);
    int yOffset = 35;
    int centerY = self.navigationController.navigationBar.frame.size.height + yOffset;
    
    
    //Load Some videos to camera Roll - (needed if using simulator)
    self.loadVideostoCameraRollButton = [[UIButton alloc] initWithFrame:CGRectMake(centerX,
                                                                 centerY,
                                                                 bWidth,
                                                                 bHeight)];
    [self.loadVideostoCameraRollButton setTitle:@"Save example videos to camera roll" forState:UIControlStateNormal];
    [self.loadVideostoCameraRollButton addTarget:self action:@selector(saveVideostoCameraRoll) forControlEvents:UIControlEventTouchUpInside];
    [self.loadVideostoCameraRollButton setBackgroundColor:[UIColor grayColor]];
    

    //Play button
    self.playfromRollButton = [[UIButton alloc] initWithFrame:CGRectMake(centerX,
                                                                 centerY * 2,
                                                                 bWidth,
                                                                 bHeight)];
    [self.playfromRollButton setTitle:@"Play video from camera roll" forState:UIControlStateNormal];
    [self.playfromRollButton addTarget:self action:@selector(playVideo) forControlEvents:UIControlEventTouchUpInside];
    [self.playfromRollButton setBackgroundColor:[UIColor grayColor]];
    
    //Play button
    self.playwithAVButton = [[UIButton alloc] initWithFrame:CGRectMake(centerX,
                                                                         centerY * 3,
                                                                         bWidth,
                                                                         bHeight)];
    [self.playwithAVButton setTitle:@"Play video with AV" forState:UIControlStateNormal];
    [self.playwithAVButton addTarget:self action:@selector(playVideoAV) forControlEvents:UIControlEventTouchUpInside];
    [self.playwithAVButton setBackgroundColor:[UIColor grayColor]];
    
    //Record button
    self.recordVideoButton = [[UIButton alloc] initWithFrame:CGRectMake(centerX,
                                                                        centerY * 4,
                                                                        bWidth,
                                                                        bHeight)];
    [self.recordVideoButton setTitle:@"Record video with AV" forState:UIControlStateNormal];
    [self.recordVideoButton addTarget:self action:@selector(recordVideo) forControlEvents:UIControlEventTouchUpInside];
    [self.recordVideoButton setBackgroundColor:[UIColor grayColor]];
    
    
    //Merge button
    self.mergeVideosButton = [[UIButton alloc] initWithFrame:CGRectMake(centerX,
                                                                         centerY * 5,
                                                                         bWidth,
                                                                         bHeight)];
    [self.mergeVideosButton setTitle:@"Merge videos with AV" forState:UIControlStateNormal];
    [self.mergeVideosButton addTarget:self action:@selector(mergeVideos) forControlEvents:UIControlEventTouchUpInside];
    [self.mergeVideosButton setBackgroundColor:[UIColor grayColor]];
    
    
    //Overlay and Animation button
    self.overlayandAnimationsButton = [[UIButton alloc] initWithFrame:CGRectMake(centerX,
                                                                        centerY * 6,
                                                                        bWidth,
                                                                        bHeight)];
    [self.overlayandAnimationsButton setTitle:@"Animations with AV" forState:UIControlStateNormal];
    [self.overlayandAnimationsButton addTarget:self action:@selector(animations) forControlEvents:UIControlEventTouchUpInside];
    [self.overlayandAnimationsButton setBackgroundColor:[UIColor grayColor]];
    
    
    [self.view addSubview:self.loadVideostoCameraRollButton];
    [self.view addSubview:self.playfromRollButton];
    [self.view addSubview:self.playwithAVButton];
    [self.view addSubview:self.recordVideoButton];
    [self.view addSubview:self.mergeVideosButton];
    [self.view addSubview:self.overlayandAnimationsButton];
    
}


#pragma mark - helpers
- (void) saveVideostoCameraRoll
{

    NSLog(@"save example videos to camera roll");
    //If using the simulator you will need to load some videos to the camera roll this simplifies de process
    
    NSString *vid1 = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Clara.mp4"];
    NSString *vid2 = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Clara2256.m4v"];
    UISaveVideoAtPathToSavedPhotosAlbum(vid1, nil, nil, nil);
    UISaveVideoAtPathToSavedPhotosAlbum(vid2, nil, nil, nil);
    
    [self.loadVideostoCameraRollButton setEnabled:NO];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Videos Loaded" message:@"Two example videos where saved in the camera roll for testing purposes" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];

}



#pragma mark - Play,Stop,Rec,Edit
- (void) playVideo
{
    NSLog(@"go to play video");
    
    //alloc init play video view
    PlayVideoViewController *pvvc = [[PlayVideoViewController alloc] init];
    [self.navigationController pushViewController:pvvc animated:YES];
    
}

- (void) playVideoAV
{
    NSLog(@"go to play video AV");
    
    //alloc init play video view
    PlayVideoWithAVViewController *pvavvc = [[PlayVideoWithAVViewController alloc] init];
    [self.navigationController pushViewController:pvavvc animated:YES];
    
}

- (void) recordVideo
{
    NSLog(@"go to rec video");
    
    //alloc init play video view
    RecordVideoViewController *rvvc = [[RecordVideoViewController alloc] init];
    [self.navigationController pushViewController:rvvc animated:YES];
    
}

- (void) mergeVideos
{
    NSLog(@"go to merge videos");
    
    //alloc init play video view
    MergeVideosViewController *mvvc = [[MergeVideosViewController alloc] init];
    [self.navigationController pushViewController:mvvc animated:YES];
    
}

- (void) animations
{
    NSLog(@"go to animations");
    
    //alloc init play video view
    AnimationsViewController *avvc = [[AnimationsViewController alloc] init];
    [self.navigationController pushViewController:avvc animated:YES];
    
}










#pragma mark - Memory
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
