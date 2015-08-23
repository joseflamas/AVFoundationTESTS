//
//  PlayVideoWithAVViewController.m
//  VideoPlayRecord
//
//  Created by Mac on 8/20/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import "PlayVideoWithAVViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>



@interface PlayVideoWithAVViewController ()

@property (nonatomic, strong) AVAsset       *asset;
@property (nonatomic, strong) AVPlayer      *player;
@property (nonatomic, strong) AVPlayerItem  *playerItem;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;

@property (nonatomic, strong) UIButton *playButton;
@property (nonatomic, strong) UIButton *pauseButton;
@property (nonatomic, strong) UISlider *timeSlider;

@end


@implementation PlayVideoWithAVViewController

NSTimer *timer;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Set navigation item text
    self.title = @"AV Video";
    
    //set background color
    self.view.backgroundColor = [UIColor whiteColor];
    
    //path to file
    //NSString *videoPath = [[NSBundle mainBundle] pathForResource:@"Clara" ofType:@"mp4"];
    NSString *videoPath = [[NSBundle mainBundle] pathForResource:@"Clara2256" ofType:@"m4v"];

    self.asset       = [AVAsset assetWithURL:[NSURL fileURLWithPath:videoPath]];
    self.playerItem  = [AVPlayerItem playerItemWithAsset:self.asset];
    self.player      = [AVPlayer playerWithPlayerItem:self.playerItem];
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    self.playerLayer.frame = CGRectMake(0,self.view.frame.size.height/2 - (self.view.frame.size.height/2)/2, self.view.frame.size.width, self.view.frame.size.height/2);
    [self.view.layer addSublayer:self.playerLayer];
    
    //Slider
    self.timeSlider = [[UISlider alloc] initWithFrame:CGRectMake(5,
                                                                self.view.frame.size.height - 130,
                                                                 self.view.frame.size.width - 10,
                                                                 25)];
    
    [self.timeSlider addTarget:self action:@selector(timeLineSlider) forControlEvents:UIControlEventValueChanged];
    
    //Play button
    self.playButton = [[UIButton alloc] initWithFrame:CGRectMake(5,
                                                            self.view.frame.size.height - 80,
                                                            self.view.frame.size.width - 10,
                                                            35)];
    [self.playButton setTitle:@"Play" forState:UIControlStateNormal];
    [self.playButton addTarget:self action:@selector(playVideo) forControlEvents:UIControlEventTouchUpInside];
    [self.playButton setBackgroundColor:[UIColor grayColor]];

    //pause button
    self.pauseButton = [[UIButton alloc] initWithFrame:CGRectMake(5,
                                                            self.view.frame.size.height - 40,
                                                            self.view.frame.size.width - 10,
                                                            35)];
    [self.pauseButton setTitle:@"Pause" forState:UIControlStateNormal];
    [self.pauseButton addTarget:self action:@selector(pauseVideo) forControlEvents:UIControlEventTouchUpInside];
    [self.pauseButton setBackgroundColor:[UIColor grayColor]];
    
    


    [self.view addSubview:self.timeSlider];
    [self.view addSubview:self.playButton];
    [self.view addSubview:self.pauseButton];
    

    
}

-(void)timeLineSlider
{
    Float64 seconds = CMTimeGetSeconds(self.player.currentItem.asset.duration) * self.timeSlider.value;
    CMTime newTime  = CMTimeMakeWithSeconds(seconds, self.player.currentTime.timescale);
    [self.player seekToTime:newTime];
}

-(void)startTimerForUpdatingSlider
{
    timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(updateSlider) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
}

-(void)updateSlider
{
    self.timeSlider.value = CMTimeGetSeconds(self.player.currentTime)/CMTimeGetSeconds(self.player.currentItem.asset.duration);
}

-(void)playVideo
{
    [self.player play];
    [self startTimerForUpdatingSlider];
}

-(void)pauseVideo
{
    [self.player pause];
    [timer invalidate];
}







- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}



@end
