//
//  PlayVideoViewController.m
//  VideoPlayRecord
//
//  Created by Mac on 8/20/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import "PlayVideoViewController.h"

@interface PlayVideoViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    UIImagePickerController *mediaUI;
}

@property (nonatomic, strong) UIButton *openMediaBrowserButton;

@end




@implementation PlayVideoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    //Set navigation item text
    self.title = @"Play Roll Video";
    
    //set Background
    self.view.backgroundColor = [UIColor whiteColor];
    
    //open Media Browser
    [self startMediaBrowserfromController:self withDelegate:self];
    
    //media browser button
    self.openMediaBrowserButton = [[UIButton alloc] initWithFrame:CGRectMake((self.view.frame.size.width/2) -((self.view.frame.size.width-10)/2),
                                                                             self.view.frame.size.height/2,
                                                                             self.view.frame.size.width-10,
                                                                             self.view.frame.size.height/14)];
    [self.openMediaBrowserButton setTitle:@"Open Media Browser" forState:UIControlStateNormal];
    [self.openMediaBrowserButton addTarget:self action:@selector(openMediaBrowser) forControlEvents:UIControlEventTouchUpInside];
    [self.openMediaBrowserButton setBackgroundColor:[UIColor grayColor]];
    
    
    [self.view addSubview:self.openMediaBrowserButton];
}



#pragma mark - helpers
-(BOOL)startMediaBrowserfromController:(UIViewController *)controller withDelegate:(id)delegate
{

    if (([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum] == NO) || (delegate == nil) || (controller == nil))
    {
        return NO;
    }
    
    mediaUI = [[UIImagePickerController alloc] init];
    mediaUI.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    mediaUI.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie, nil];
    mediaUI.allowsEditing = YES;
    mediaUI.delegate = delegate;
    
    [self.navigationController presentViewController:mediaUI animated:YES completion:nil];
    
    return YES;
}

-(void)openMediaBrowser
{
    [self startMediaBrowserfromController:self withDelegate:self];
}



#pragma mark - Memory
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}



@end
