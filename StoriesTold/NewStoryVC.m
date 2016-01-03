//
//  NewStoryVC.m
//  StoriesTold
//
//  Created by Niko Zarzani on 12/31/15.
//  Copyright © 2015 IndieZiOS. All rights reserved.
//

#import "NewStoryVC.h"
#import "Constants.h"

#import "AppDelegate.h"
#import <Parse/Parse.h>
#import "TheAmazingAudioEngine.h"
#import "AERecorder.h"
#import "TPOscilloscopeLayer.h"
#import "AEReverbFilter.h"
#import "AELowPassFilter.h"
#import "AEDistortionFilter.h"
#import "AENewTimePitchFilter.h"

@interface NewStoryVC()

@property (nonatomic, strong) AEAudioController *audioController;
@property (nonatomic, strong) AERecorder *recorder;
@property (nonatomic, strong) AEAudioFilePlayer *player;

@property (weak, nonatomic) IBOutlet UIButton *dimensionButton;
@property (weak, nonatomic) IBOutlet UITextField *storyNameTextField;
@property (weak, nonatomic) IBOutlet UIButton *playStopButton;
@property (weak, nonatomic) IBOutlet UIButton *recordButton;
@property (strong, nonatomic) PFFile *abstract;

@property (strong, nonatomic) UIBarButtonItem *doneBarButton;

@end

@implementation NewStoryVC

- (void)viewDidLoad{
    [super viewDidLoad];

    [self setupNavBar];

    [self setupLeftBarButtonItems];
    [self setupRightBarButtonItems];
    
    [self.dimensionButton setTitle:self.dimension.name forState:UIControlStateNormal];
    
    self.recordButton.layer.cornerRadius = self.recordButton.frame.size.width/2;
    self.recordButton.imageView.image = [self.recordButton.imageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    self.playStopButton.layer.cornerRadius = self.recordButton.frame.size.width/2;
    self.playStopButton.imageView.image = [self.recordButton.imageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    [self.storyNameTextField becomeFirstResponder];
    
    self.storyNameTextField.text = self.story.title;
    
    self.abstract = self.story.abstract;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
}

- (void)setupNavBar
{
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.barTintColor = kDarkBeigeColor;
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.navigationItem.title = self.story.title ? self.story.title : @"New Story";
}

- (void)setupLeftBarButtonItems
{
    UIBarButtonItem *cancelBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelTapped)];
    cancelBarButton.tintColor = [UIColor blackColor];
    
    self.navigationItem.leftBarButtonItems = @[cancelBarButton];
}

- (void)setupRightBarButtonItems
{
    self.doneBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(doneTapped)];
    self.doneBarButton.tintColor = [UIColor blackColor];
    
    self.navigationItem.rightBarButtonItems = @[self.doneBarButton];
}

- (void)cancelTapped
{
    [self.createStoryDelegate cancelTapped];
}

- (void)doneTapped
{
    self.doneBarButton.enabled = NO;
    [self stopAudio];
    
    Story * story = self.story;
    if(!story){
        story = [Story object];
        story.createdBy = [PFUser currentUser];
    }
    story.title = self.storyNameTextField.text;
    story.dimension = self.dimension;
    story.abstract = self.abstract;
    
    [story saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (!error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.createStoryDelegate doneTapped];
            });
        }
    }];
}

#pragma mark - Audio Handling

- (void)viewWillDisappear:(BOOL)animated
{
    [self stopAudio];
    [super viewWillDisappear:animated];
}

- (void)stopAudio
{
    [self stop];
    [self stopRecord];
}

#pragma mark - Play Abstract

- (AEAudioController *)audioController
{
    if(!_audioController){
        AppDelegate * appDelegate = [[UIApplication sharedApplication] delegate];
        _audioController = appDelegate.audioController;
    }
    return _audioController;
}

- (void)play
{
    if(!self.player){
        [self.abstract getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
            NSArray *documentsFolders = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *path = [documentsFolders[0] stringByAppendingPathComponent:@"Audio.m4a"];
            [[NSFileManager defaultManager] createFileAtPath:path contents:data attributes:nil];
            
            self.player = [AEAudioFilePlayer audioFilePlayerWithURL:[NSURL fileURLWithPath:path] error:&error];
            
            if ( !self.player ) {
                NSLog(@"player not set");
            }
            
            self.player.removeUponFinish = YES;
            
            __weak NewStoryVC *weakSelf = self;
            self.player.completionBlock = ^{
                NewStoryVC *strongSelf = weakSelf;
                weakSelf.player = nil;
                dispatch_async(dispatch_get_main_queue(), ^{
                    strongSelf.playStopButton.selected = NO;
                });
            };
            
            [self.audioController addChannels:@[self.player]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.playStopButton.selected = YES;
            });
        }];
    }
}

- (void)stop
{
    if(self.player){
        [self.audioController removeChannels:@[self.player]];
        self.player = nil;
        self.playStopButton.selected = NO;
    }
}

- (IBAction)playStopTapped:(id)sender {
    if (self.player) {
        [self stop];
    } else {
        [self play];
    }
}

#pragma mark - Record Abstract

-(void)setAbstract:(PFFile *)abstract
{
    self.playStopButton.enabled = abstract != nil;
    _abstract = abstract;
}

- (void)record
{
    self.recorder = [[AERecorder alloc] initWithAudioController:self.audioController];
    NSArray *documentsFolders = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [documentsFolders[0] stringByAppendingPathComponent:@"Recording.m4a"];
    NSError *error = nil;
    if ( ![self.recorder beginRecordingToFileAtPath:path fileType:kAudioFileM4AType error:&error] ) {
        NSLog(@"Couldn't start recording: %@", [error localizedDescription]);
        self.recorder = nil;
        return;
    }
    
    self.recordButton.selected = YES;
    self.recordButton.backgroundColor = kRedColor;
    
    [self.audioController addOutputReceiver:self.recorder];
    [self.audioController addInputReceiver:self.recorder];
}

- (void)stopRecord
{
    if (self.recorder) {
        [self.recorder finishRecording];
        [self.audioController removeOutputReceiver:self.recorder];
        [self.audioController removeInputReceiver:self.recorder];
        self.recorder = nil;
        
        self.recordButton.selected = NO;
        self.recordButton.backgroundColor = [UIColor whiteColor];
        
        NSArray *documentsFolders = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *path = [documentsFolders[0] stringByAppendingPathComponent:@"Recording.m4a"];
        
        if ( [[NSFileManager defaultManager] fileExistsAtPath:path] ) {
            self.abstract = [PFFile fileWithData:[[NSFileManager defaultManager] contentsAtPath:path]];
        }
    }
}

- (IBAction)recordButtonDidTapped:(id)sender {
    if (self.recorder) {
        [self stopRecord];
    } else {
        [self record];
    }
}

@end
