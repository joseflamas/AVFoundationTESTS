//
//  RecordVideoViewController.m
//  VideoPlayRecord
//
//  Created by Mac on 8/20/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import "RecordVideoViewController.h"
#import <CoreMedia/CoreMedia.h>
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>


@interface RecordVideoViewController () <AVCaptureFileOutputRecordingDelegate>
{
    BOOL isRecording;
    
    AVCaptureSession         *captureSession;
    AVCaptureMovieFileOutput *movieFileOutput;
    AVCaptureDevice          *videoDevice;
    AVCaptureDevice          *audioDevice;
    AVCaptureDeviceInput     *videoDeviceInput;
    AVCaptureDeviceInput     *audioDeviceInput;
}

@property (strong) AVCaptureVideoPreviewLayer *previewLayer;
@property (nonatomic, strong) UIButton *recButton;
@property (nonatomic, strong) UIButton *toggleButton;

@end

@implementation RecordVideoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    //Set navigation item text
    self.title = @"Record Video";
    
    //set background color
    self.view.backgroundColor = [UIColor whiteColor];
    
    //Play button
    self.recButton = [[UIButton alloc] initWithFrame:CGRectMake(5,
                                                                 self.view.frame.size.height - 80,
                                                                 self.view.frame.size.width - 10,
                                                                 35)];
    [self.recButton setTitle:@"Record Video" forState:UIControlStateNormal];
    [self.recButton addTarget:self action:@selector(recordVideo) forControlEvents:UIControlEventTouchUpInside];
    [self.recButton setBackgroundColor:[UIColor grayColor]];
    
    //pause button
    self.toggleButton = [[UIButton alloc] initWithFrame:CGRectMake(5,
                                                                  self.view.frame.size.height - 40,
                                                                  self.view.frame.size.width - 10,
                                                                  35)];
    [self.toggleButton setTitle:@"Toggle Camera" forState:UIControlStateNormal];
    [self.toggleButton addTarget:self action:@selector(toggleCamera) forControlEvents:UIControlEventTouchUpInside];
    [self.toggleButton setBackgroundColor:[UIColor grayColor]];
    
    [self.view addSubview:self.recButton];
    [self.view addSubview:self.toggleButton];
    
    //Setting capture Session
    captureSession = [[AVCaptureSession alloc] init];
    
    //Video capture device Input
    NSArray *cameras = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    videoDevice = [cameras firstObject];
    
    if (videoDevice)
    {
        NSError *deviceError;
        videoDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:&deviceError];
        
        if(!deviceError)
        {
            if([captureSession canAddInput:videoDeviceInput])
            {
                [captureSession addInput:videoDeviceInput];
            
            } else {
                
                NSLog(@"Input device error");
            }
            
        } else {
            
            NSLog(@"Could't create video input");
        }
    }
    
    //Audio capture device Input
    NSArray *microPhones = [AVCaptureDevice devicesWithMediaType:AVMediaTypeAudio];
    audioDevice = [microPhones firstObject];
    
    NSError *deviceError;
    audioDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:audioDevice error:&deviceError];
    if (audioDeviceInput)
    {
        [captureSession addInput:audioDeviceInput];
    }
    
    //OUTPUTS
    
    //Preview layer
    [self setPreviewLayer:[[AVCaptureVideoPreviewLayer alloc] initWithSession:captureSession]];
    [[self previewLayer] setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    
    //File output
    movieFileOutput = [[AVCaptureMovieFileOutput alloc] init];
    
    Float64 totalVideoDuration = 60;
    int32_t frameRate          = 30;
    CMTime  maxDuration        = CMTimeMakeWithSeconds(totalVideoDuration, frameRate);
    movieFileOutput.maxRecordedDuration   = maxDuration;
    //movieFileOutput.minFreeDiskSpaceLimit = 1024*1024;
    
    if ([captureSession canAddOutput:movieFileOutput]) { [captureSession addOutput:movieFileOutput]; }
    
    //Camera Output Properties;
    AVCaptureConnection *captureConnection = [movieFileOutput connectionWithMediaType:AVMediaTypeVideo];
    if([captureConnection isVideoOrientationSupported])
    {
        AVCaptureVideoOrientation orientation = AVCaptureVideoOrientationLandscapeRight;        [captureConnection setVideoOrientation:orientation];
    }
    
    //Quality
    [captureSession setSessionPreset:AVCaptureSessionPresetMedium];
    if ([captureSession canSetSessionPreset:AVCaptureSessionPreset1920x1080]) { [captureSession setSessionPreset:AVCaptureSessionPreset1920x1080]; }
    
    CGRect previewLayerRect = [[[self view] layer] bounds];
    [self.previewLayer setBounds:previewLayerRect];
    [self.previewLayer setPosition:CGPointMake(CGRectGetMidX(previewLayerRect),
                                               CGRectGetMidY(previewLayerRect))];
    UIView *cameraView = [[UIView alloc] init];
    [self.view addSubview:cameraView];
    [self.view sendSubviewToBack:cameraView];
    [cameraView.layer addSublayer:self.previewLayer];
    
    //start session
    [captureSession startRunning];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    isRecording = NO;
}


-(void)recordVideo
{
    if(!isRecording)
    {
        [self.recButton setTitle:@"Recording" forState:UIControlStateNormal];
        
        isRecording = YES;
        
        NSString *outputPath = [[NSString alloc] initWithFormat:@"%@%@", NSTemporaryDirectory(), @"salida.mov"];
        NSURL *outputURL = [[NSURL alloc] initFileURLWithPath:outputPath];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if ([fileManager fileExistsAtPath:outputPath])
        {
            NSError *error;
            if ([fileManager removeItemAtPath:outputPath error:&error] == NO)
            {
                //Error - handle if requried
            }
        }
        
        
        //Start recording
        [movieFileOutput startRecordingToOutputFileURL:outputURL recordingDelegate:self];

    } else {
        
        [self.recButton setTitle:@"Record Video" forState:UIControlStateNormal];
        isRecording = NO;
        [movieFileOutput stopRecording];
    }
}


-(void)toggleCamera
{
    if ([[AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo] count] > 1)
    {
        NSError *toggleError;
        AVCaptureDeviceInput *newVideoInput;
        AVCaptureDevicePosition position = [[videoDeviceInput device] position];
        if (position == AVCaptureDevicePositionBack)
        {
            newVideoInput = [[AVCaptureDeviceInput alloc] initWithDevice:[self CameraWithPosition:AVCaptureDevicePositionFront] error:&toggleError];
        }
        else if (position == AVCaptureDevicePositionFront)
        {
            newVideoInput = [[AVCaptureDeviceInput alloc] initWithDevice:[self CameraWithPosition:AVCaptureDevicePositionBack] error:&toggleError];
        }
        
        if (newVideoInput != nil)
        {
            [captureSession beginConfiguration];		//We can now change the inputs and output configuration.  Use commitConfiguration to end
            [captureSession removeInput:videoDeviceInput];
            if ([captureSession canAddInput:newVideoInput])
            {
                [captureSession addInput:newVideoInput];
                videoDeviceInput = newVideoInput;
            }
            else
            {
                [captureSession addInput:videoDeviceInput];
            }
            
            //Set the connection properties again
            //Camera Output Properties;
            AVCaptureConnection *captureConnection = [movieFileOutput connectionWithMediaType:AVMediaTypeVideo];
            if([captureConnection isVideoOrientationSupported])
            {
                AVCaptureVideoOrientation orientation = AVCaptureVideoOrientationLandscapeRight;        [captureConnection setVideoOrientation:orientation];
            }
            
            [captureSession commitConfiguration];

        }
    }
}



#pragma mark - <AVCaptureFileOutputRecordingDelegate>
-(void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error
{
    BOOL RecordedSuccessfully = YES;
    if ([error code] != noErr)
    {
        // A problem occurred: Find out if the recording was successful.
        id value = [[error userInfo] objectForKey:AVErrorRecordingSuccessfullyFinishedKey];
        if (value)
        {
            RecordedSuccessfully = [value boolValue];
        }
    }
    if (RecordedSuccessfully)
    {

        NSLog(@"didFinishRecordingToOutputFileAtURL - success");
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        if ([library videoAtPathIsCompatibleWithSavedPhotosAlbum:outputFileURL])
        {
            [library writeVideoAtPathToSavedPhotosAlbum:outputFileURL
                                        completionBlock:^(NSURL *assetURL, NSError *error)
             {
                 if (error)
                 {
                     
                 }
             }];
        }

    }
}

#pragma mark - Camera position
- (AVCaptureDevice *) CameraWithPosition:(AVCaptureDevicePosition) Position
{
    NSArray *Devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *Device in Devices)
    {
        if ([Device position] == Position)
        {
            return Device;
        }
    }
    return nil;
}

#pragma mark - Memory
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}



@end
