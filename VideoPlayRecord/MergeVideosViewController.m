//
//  MergeVideosViewController.m
//  VideoPlayRecord
//
//  Created by Mac on 8/21/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import "MergeVideosViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <MediaPlayer/MediaPlayer.h>


@interface MergeVideosViewController ()
{
    BOOL isSelectingAsset1;
}

@property (nonatomic, strong) AVAsset                  *asset1;
@property (nonatomic, strong) AVAsset                  *asset2;
@property (nonatomic, strong) UIActivityIndicatorView  *indicatorView;

@property (nonatomic, strong) UIButton *loadAsset1Button;
@property (nonatomic, strong) UIButton *loadAsset2Button;
@property (nonatomic, strong) UIButton *mergeandSaveButton;

-(BOOL)startMediaBrowserFromViewController:(UIViewController*)controller usingDelegate:(id)delegate;
-(void)exportDidFinish:(AVAssetExportSession*)session;

@end

@implementation MergeVideosViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Set navigation item text
    self.title = @"Merge Videos";
    
    //set background color
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    //Play button
    self.loadAsset1Button = [[UIButton alloc] initWithFrame:CGRectMake(5,
                                                                self.view.frame.size.height - 120,
                                                                self.view.frame.size.width - 10,
                                                                35)];
    [self.loadAsset1Button setTitle:@"Load Asset 1" forState:UIControlStateNormal];
    [self.loadAsset1Button addTarget:self action:@selector(loadAsset1) forControlEvents:UIControlEventTouchUpInside];
    [self.loadAsset1Button setBackgroundColor:[UIColor grayColor]];
    
    //pause button
    self.loadAsset2Button = [[UIButton alloc] initWithFrame:CGRectMake(5,
                                                                   self.view.frame.size.height - 80,
                                                                   self.view.frame.size.width - 10,
                                                                   35)];
    [self.loadAsset2Button setTitle:@"Load Asset 2" forState:UIControlStateNormal];
    [self.loadAsset2Button addTarget:self action:@selector(loadAsset2) forControlEvents:UIControlEventTouchUpInside];
    [self.loadAsset2Button setBackgroundColor:[UIColor grayColor]];
    
    
    self.mergeandSaveButton = [[UIButton alloc] initWithFrame:CGRectMake(5,
                                                                       self.view.frame.size.height - 40,
                                                                       self.view.frame.size.width - 10,
                                                                       35)];
    [self.mergeandSaveButton setTitle:@"Merge and Save" forState:UIControlStateNormal];
    [self.mergeandSaveButton addTarget:self action:@selector(saveandMerge) forControlEvents:UIControlEventTouchUpInside];
    [self.mergeandSaveButton setBackgroundColor:[UIColor grayColor]];
    
    [self.view addSubview:self.loadAsset1Button];
    [self.view addSubview:self.loadAsset2Button];
    [self.view addSubview:self.mergeandSaveButton];
}



-(void)loadAsset1
{
 
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum] == NO)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ERROR" message:@"No Saved Album found!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        
    } else {
        
        isSelectingAsset1 = TRUE;
        [self startMediaBrowserFromViewController:self usingDelegate:self];
        
    }
    
}


-(void)loadAsset2
{
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum] == NO)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ERROR" message:@"No Saved Album found!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        
    } else {
        
        isSelectingAsset1 = FALSE;
        [self startMediaBrowserFromViewController:self usingDelegate:self];
        
    }
}


-(void)saveandMerge
{
    if (self.asset1 !=nil && self.asset2 != nil)
    {
        [self.indicatorView startAnimating];
        
        AVMutableComposition *mixComposition = [[AVMutableComposition alloc] init];
        //Video 1
        AVMutableCompositionTrack *firstTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo
                                                                            preferredTrackID:kCMPersistentTrackID_Invalid];
        
        [firstTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, self.asset1.duration)
                            ofTrack:[[self.asset1 tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] atTime:kCMTimeZero error:nil];
        
        AVMutableCompositionTrack *AudioTrack1 = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio
                                                                            preferredTrackID:kCMPersistentTrackID_Invalid];
        
        [AudioTrack1 insertTimeRange:CMTimeRangeMake(kCMTimeZero, self.asset1.duration)
                            ofTrack:[[self.asset1 tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0] atTime:kCMTimeZero error:nil];
        
        
        //Video 2
        [firstTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, self.asset2.duration)
                            ofTrack:[[self.asset2 tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] atTime:self.asset1.duration error:nil];
        
        AVMutableCompositionTrack *AudioTrack2 = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio
                                                                            preferredTrackID:kCMPersistentTrackID_Invalid];
        [AudioTrack2 insertTimeRange:CMTimeRangeMake(kCMTimeZero, self.asset2.duration)
                            ofTrack:[[self.asset2 tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0] atTime:self.asset1.duration error:nil];
        
        NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *myPathDocs =  [documentsDirectory stringByAppendingPathComponent:
                                 [NSString stringWithFormat:@"MergedClara-%d.mov",arc4random() % 1000]];
        NSURL *url = [NSURL fileURLWithPath:myPathDocs];

        
        AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:mixComposition
                                                                          presetName:AVAssetExportPresetHighestQuality];
        exporter.outputURL=url;
        exporter.outputFileType = AVFileTypeQuickTimeMovie;
        exporter.shouldOptimizeForNetworkUse = YES;
        [exporter exportAsynchronouslyWithCompletionHandler:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self exportDidFinish:exporter];
            });
        }];
    }
}

-(void)exportDidFinish:(AVAssetExportSession*)session
{
    if (session.status == AVAssetExportSessionStatusCompleted)
    {
        NSURL *outputURL = session.outputURL;
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        if ([library videoAtPathIsCompatibleWithSavedPhotosAlbum:outputURL])
        {
            [library writeVideoAtPathToSavedPhotosAlbum:outputURL completionBlock:^(NSURL *assetURL, NSError *error){
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (error) {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Video Saving Failed"
                                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                        [alert show];
                    } else {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Video Saved" message:@"Saved To Photo Album"
                                                                       delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                        [alert show];
                    }
                });
            }];
        }
    }
    [self.indicatorView stopAnimating];
}


-(BOOL)startMediaBrowserFromViewController:(UIViewController*)controller usingDelegate:(id)delegate
{

    if (([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum] == NO)
        || (delegate == nil)
        || (controller == nil))
    {
        return NO;
    }

    UIImagePickerController *mediaUI = [[UIImagePickerController alloc] init];
    mediaUI.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    mediaUI.mediaTypes = [[NSArray alloc] initWithObjects:(NSString *)kUTTypeMovie, nil];
    mediaUI.allowsEditing = YES;
    mediaUI.delegate = delegate;
    
   [self.navigationController presentViewController:mediaUI animated:YES completion:nil];
    
    return YES;
}




-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {

    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];

    [self.navigationController dismissViewControllerAnimated:NO completion:nil];

    if (CFStringCompare ((__bridge_retained CFStringRef) mediaType, kUTTypeMovie, 0) == kCFCompareEqualTo) {
        if (isSelectingAsset1)
        {
            NSLog(@"Video One  Loaded");
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Asset Loaded" message:@"Video One Loaded"
                                                           delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            self.asset1 = [AVAsset assetWithURL:[info objectForKey:UIImagePickerControllerMediaURL]];
            
        } else {
            NSLog(@"Video two Loaded");
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Asset Loaded" message:@"Video Two Loaded"
                                                           delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            self.asset2 = [AVAsset assetWithURL:[info objectForKey:UIImagePickerControllerMediaURL]];
        }
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}



@end
