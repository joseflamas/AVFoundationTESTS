//
//  BorderViewController.m
//  VideoPlayRecord
//
//  Created by Mac on 8/24/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import "BorderViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <MediaPlayer/MediaPlayer.h>

@interface BorderViewController ()

@property (nonatomic, strong) AVAsset *asset;

@property (nonatomic, strong) UISlider *sizeBorderSlider;
@property (nonatomic, strong) UIButton *loadAssetButton;
@property (nonatomic, strong) UIButton *saveButton;
@property (nonatomic, strong) UIActivityIndicatorView  *indicatorView;

@end

@implementation BorderViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Set navigation item text
    self.title = @"Border";
    
    //set background color
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    //Slider
    self.sizeBorderSlider = [[UISlider alloc] initWithFrame:CGRectMake(5,
                                                                       self.view.frame.size.height - 130,
                                                                       self.view.frame.size.width - 10,
                                                                       25)];
    
    [self.sizeBorderSlider setMaximumValue:100];
    [self.sizeBorderSlider setValue:10 animated:YES];
    
    
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
    [self startMediaBrowserFromViewController:self usingDelegate:self];
}

-(void)applyVideoEffectsToComposition:(AVMutableVideoComposition *)composition size:(CGSize)size
{

    
        
        //Image
        CGRect rect = CGRectMake(0, 0, size.width, size.height);
        UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
        [[UIColor grayColor] setFill];
        UIRectFill(rect);
        UIImage *borderImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        CALayer *backgroundLayer = [CALayer layer];
        [backgroundLayer setContents:(id)[borderImage CGImage]];
        backgroundLayer.frame = CGRectMake(0, 0, size.width, size.height);
        [backgroundLayer setMasksToBounds:YES];
        
        CALayer *videoLayer = [CALayer layer];
        videoLayer.frame = CGRectMake(self.sizeBorderSlider.value, self.sizeBorderSlider.value,
                                      size.width-(self.sizeBorderSlider.value*2), size.height-(self.sizeBorderSlider.value*2));
        CALayer *parentLayer = [CALayer layer];
        parentLayer.frame = CGRectMake(0, 0, size.width, size.height);
        [parentLayer addSublayer:backgroundLayer];
        [parentLayer addSublayer:videoLayer];
    
    
        composition.animationTool = [AVVideoCompositionCoreAnimationTool
                                     videoCompositionCoreAnimationToolWithPostProcessingAsVideoLayer:videoLayer inLayer:parentLayer];

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
    
    if (CFStringCompare ((__bridge_retained CFStringRef) mediaType, kUTTypeMovie, 0) == kCFCompareEqualTo)
    {

        NSLog(@"Video Loaded");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Asset Loaded" message:@"Video One Loaded"
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        self.asset = [AVAsset assetWithURL:[info objectForKey:UIImagePickerControllerMediaURL]];
        
    }
}




- (void)saveVideo
{
    
    // 1 - Early exit if there's no video file selected
    if (!self.asset) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please Load a Video Asset First"
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    // 2 - Create AVMutableComposition object. This object will hold your AVMutableCompositionTrack instances.
    AVMutableComposition *mixComposition = [[AVMutableComposition alloc] init];
    
    // 3 - Video track
    AVMutableCompositionTrack *videoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo
                                                                        preferredTrackID:kCMPersistentTrackID_Invalid];
    [videoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, self.asset.duration)
                        ofTrack:[[self.asset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0]
                         atTime:kCMTimeZero error:nil];
    
    // 3 - Video track
    AVMutableCompositionTrack *audioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio
                                                                        preferredTrackID:kCMPersistentTrackID_Invalid];
    [audioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, self.asset.duration)
                        ofTrack:[[self.asset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0]
                         atTime:kCMTimeZero error:nil];
    
    // 3.1 - Create AVMutableVideoCompositionInstruction
    AVMutableVideoCompositionInstruction *mainInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    mainInstruction.timeRange = CMTimeRangeMake(kCMTimeZero, self.asset.duration);
    
    // 3.2 - Create an AVMutableVideoCompositionLayerInstruction for the video track and fix the orientation.
    AVMutableVideoCompositionLayerInstruction *videolayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoTrack];
    AVAssetTrack *videoAssetTrack = [[self.asset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
    UIImageOrientation videoAssetOrientation_  = UIImageOrientationUp;
    BOOL isVideoAssetPortrait_  = NO;
    CGAffineTransform videoTransform = videoAssetTrack.preferredTransform;
    if (videoTransform.a == 0 && videoTransform.b == 1.0 && videoTransform.c == -1.0 && videoTransform.d == 0) {
        videoAssetOrientation_ = UIImageOrientationRight;
        isVideoAssetPortrait_ = YES;
    }
    if (videoTransform.a == 0 && videoTransform.b == -1.0 && videoTransform.c == 1.0 && videoTransform.d == 0) {
        videoAssetOrientation_ =  UIImageOrientationLeft;
        isVideoAssetPortrait_ = YES;
    }
    if (videoTransform.a == 1.0 && videoTransform.b == 0 && videoTransform.c == 0 && videoTransform.d == 1.0) {
        videoAssetOrientation_ =  UIImageOrientationUp;
    }
    if (videoTransform.a == -1.0 && videoTransform.b == 0 && videoTransform.c == 0 && videoTransform.d == -1.0) {
        videoAssetOrientation_ = UIImageOrientationDown;
    }
    [videolayerInstruction setTransform:videoAssetTrack.preferredTransform atTime:kCMTimeZero];
    [videolayerInstruction setOpacity:0.0 atTime:self.asset.duration];
    
    // 3.3 - Add instructions
    mainInstruction.layerInstructions = [NSArray arrayWithObjects:videolayerInstruction,nil];
    
    AVMutableVideoComposition *mainCompositionInst = [AVMutableVideoComposition videoComposition];
    
    CGSize naturalSize;
    if(isVideoAssetPortrait_){
        naturalSize = CGSizeMake(videoAssetTrack.naturalSize.height, videoAssetTrack.naturalSize.width);
    } else {
        naturalSize = videoAssetTrack.naturalSize;
    }
    
    float renderWidth, renderHeight;
    renderWidth = naturalSize.width;
    renderHeight = naturalSize.height;
    mainCompositionInst.renderSize = CGSizeMake(renderWidth, renderHeight);
    mainCompositionInst.instructions = [NSArray arrayWithObject:mainInstruction];
    mainCompositionInst.frameDuration = CMTimeMake(1, 30);
    
    
    ////////////////////////////////////////////////////////////////////////////
    [self applyVideoEffectsToComposition:mainCompositionInst size:naturalSize];
    
    
    
    // 4 - Get path
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *myPathDocs =  [documentsDirectory stringByAppendingPathComponent:
                             [NSString stringWithFormat:@"FinalVideo-%d.mov",arc4random() % 1000]];
    NSURL *url = [NSURL fileURLWithPath:myPathDocs];
    
    // 5 - Create exporter
    AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:mixComposition
                                                                      presetName:AVAssetExportPresetHighestQuality];
    exporter.outputURL=url;
    exporter.outputFileType = AVFileTypeQuickTimeMovie;
    exporter.shouldOptimizeForNetworkUse = YES;
    exporter.videoComposition = mainCompositionInst;
    [exporter exportAsynchronouslyWithCompletionHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self exportDidFinish:exporter];
        });
    }];
}

- (void)exportDidFinish:(AVAssetExportSession*)session
{
    
    if (session.status == AVAssetExportSessionStatusCompleted) {
        NSURL *outputURL = session.outputURL;
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        if ([library videoAtPathIsCompatibleWithSavedPhotosAlbum:outputURL]) {
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

    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}



@end
