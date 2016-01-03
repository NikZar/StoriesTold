//
//  RecordVC.m
//  StoriesTold
//
//  Created by Niko Zarzani on 12/28/15.
//  Copyright © 2015 IndieZiOS. All rights reserved.
//

#import "RecordVC.h"
#import "Voice.h"
#import "Constants.h"
#import "JDStatusBarNotification.h"

#import "AppDelegate.h"
#import <Parse/Parse.h>
#import "TheAmazingAudioEngine.h"
#import "AERecorder.h"
#import "TPOscilloscopeLayer.h"
#import "AEReverbFilter.h"
#import "AELowPassFilter.h"
#import "AEDistortionFilter.h"
#import "AENewTimePitchFilter.h"

#import "UIImageView+Utils.h"

@interface RecordVC()

@property (nonatomic, strong) AEAudioController *audioController;
@property (nonatomic, strong) AERecorder *recorder;

@property (weak, nonatomic) IBOutlet UIButton *recordButton;
@property (weak, nonatomic) IBOutlet UIButton *characterButton;

@end

@implementation RecordVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.recordButton.layer.cornerRadius = self.recordButton.frame.size.width/2;
    [self.recordButton.imageView setImageRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    self.characterButton.layer.cornerRadius = self.characterButton.frame.size.width/2;
    self.characterButton.layer.borderColor = kDarkBeigeColor.CGColor;
    self.characterButton.layer.borderWidth = 2.0;
}

- (AEAudioController *)audioController
{
    if(!_audioController){
        AppDelegate * appDelegate = [[UIApplication sharedApplication] delegate];
        _audioController = appDelegate.audioController;
    }
    return _audioController;
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

- (void)stopRecord:(BOOL)shouldSave
{
    if(self.recorder){
        [self.recorder finishRecording];
        [self.audioController removeOutputReceiver:self.recorder];
        [self.audioController removeInputReceiver:self.recorder];
        self.recorder = nil;
        
        self.recordButton.selected = NO;
        self.recordButton.backgroundColor = [UIColor whiteColor];
        
        NSArray *documentsFolders = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *path = [documentsFolders[0] stringByAppendingPathComponent:@"Recording.m4a"];
        
        if ( [[NSFileManager defaultManager] fileExistsAtPath:path] && shouldSave) {
            Voice *voice = [Voice object];
            voice.audio = [PFFile fileWithData:[[NSFileManager defaultManager] contentsAtPath:path]];
            voice.story = self.story;
            //TODO: move to cloudcode
            voice.createdBy = [PFUser currentUser];
            [voice saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                if(succeeded){
                    [self.recordDelegate recordFinished];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [JDStatusBarNotification showWithStatus:@"Voice saved!" dismissAfter:2.0 styleName:kBlackNotification];
                    });
                }
                else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [JDStatusBarNotification showWithStatus:@"Error saving voice!" dismissAfter:2.0 styleName:KRedNotification];
                    });
                }
            }];
        }
    }
}

- (IBAction)recordButtonDidTapped:(id)sender {
    if (self.recordButton.selected) {
        [self stopRecord:YES];
    } else {
        [self record];
    }
}

- (void)stopAudio
{
    [self stopRecord:NO];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self stopAudio];
    [super viewWillDisappear:animated];
}

@end
