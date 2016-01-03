//
//  ViewController.m
//  StoriesTold
//
//  Created by Niko Zarzani on 11/10/15.
//  Copyright © 2015 IndieZiOS. All rights reserved.
//

#import "ViewController.h"

#import "AppDelegate.h"
#import <Parse/Parse.h>
#import "TheAmazingAudioEngine.h"
#import "AERecorder.h"
#import "TPOscilloscopeLayer.h"
#import "AEReverbFilter.h"
#import "AELowPassFilter.h"
#import "AEDistortionFilter.h"
#import "AENewTimePitchFilter.h"

@interface ViewController ()

@property (nonatomic, strong) AEAudioController *audioController;

@property (nonatomic, strong) AEAudioFilePlayer *player;
@property (nonatomic, strong) AERecorder *recorder;


@property (nonatomic, strong) IBOutlet UIView *headerView;


@property (nonatomic, strong) IBOutlet UIButton *playButton;
@property (nonatomic, strong) IBOutlet UIButton *recordButton;

@property (nonatomic, strong) TPOscilloscopeLayer *outputOscilloscope;
@property (nonatomic, strong) TPOscilloscopeLayer *inputOscilloscope;
@property (weak, nonatomic) IBOutlet UIImageView *logoView;

@property (nonatomic, strong) AEReverbFilter *reverb;
@property (nonatomic, strong) AELowPassFilter *lowPass;
@property (nonatomic, strong) AEDistortionFilter *distortion;
@property (nonatomic, strong) AENewTimePitchFilter *highPitchFilter;
@property (nonatomic, strong) AENewTimePitchFilter *lowPitchFilter;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AppDelegate * appDelegate = [[UIApplication sharedApplication] delegate];
    self.audioController = appDelegate.audioController;

    
    self.outputOscilloscope = [[TPOscilloscopeLayer alloc] initWithAudioDescription:_audioController.audioDescription];
    _outputOscilloscope.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 80);
    [self.headerView.layer addSublayer:_outputOscilloscope];
    [_audioController addOutputReceiver:_outputOscilloscope];
    [_outputOscilloscope start];
    
    self.inputOscilloscope = [[TPOscilloscopeLayer alloc] initWithAudioDescription:_audioController.audioDescription];
    _inputOscilloscope.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 80);
    _inputOscilloscope.lineColor = [UIColor colorWithWhite:0.0 alpha:0.3];
    [self.headerView.layer addSublayer:_inputOscilloscope];
    [_audioController addInputReceiver:_inputOscilloscope];
    [_inputOscilloscope start];
    
    [self.headerView bringSubviewToFront:self.logoView];
}

- (void)resetFilters
{
    if ( _reverb ) {
        [_audioController removeFilter:_reverb];
        self.reverb = nil;
    }
    
    if ( _lowPitchFilter ) {
        [_audioController removeFilter:_lowPitchFilter];
        self.lowPitchFilter = nil;
    }
    
    if ( _highPitchFilter ) {
        [_audioController removeFilter:_highPitchFilter];
        self.highPitchFilter = nil;
    }
}

- (IBAction)record:(id)sender {
    if ( _recorder ) {
        [_recorder finishRecording];
        [_audioController removeOutputReceiver:_recorder];
        [_audioController removeInputReceiver:_recorder];
        self.recorder = nil;
        _recordButton.selected = NO;
        
        NSArray *documentsFolders = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *path = [documentsFolders[0] stringByAppendingPathComponent:@"Recording.m4a"];
        
        if ( [[NSFileManager defaultManager] fileExistsAtPath:path] ) {
            PFObject *voice = [PFObject objectWithClassName:@"Voice"];
            voice[@"audio"] = [PFFile fileWithData:[[NSFileManager defaultManager] contentsAtPath:path]];
            [voice saveInBackground];
        }
        

        
    } else {
        
        [self resetFilters];
        
        self.recorder = [[AERecorder alloc] initWithAudioController:_audioController];
        NSArray *documentsFolders = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *path = [documentsFolders[0] stringByAppendingPathComponent:@"Recording.m4a"];
        NSError *error = nil;
        if ( ![_recorder beginRecordingToFileAtPath:path fileType:kAudioFileM4AType error:&error] ) {
            NSLog(@"Couldn't start recording: %@", [error localizedDescription]);
            self.recorder = nil;
            return;
        }
        
        _recordButton.selected = YES;
        
        [_audioController addOutputReceiver:_recorder];
        [_audioController addInputReceiver:_recorder];
    }
}

- (IBAction)play:(id)sender {
    if ( _player ) {
        [_audioController removeChannels:@[_player]];
        self.player = nil;
        _playButton.selected = NO;
    } else {
        
        NSArray *documentsFolders = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *path = [documentsFolders[0] stringByAppendingPathComponent:@"Recording.m4a"];

        if ( ![[NSFileManager defaultManager] fileExistsAtPath:path] ) return;
        
        NSError *error = nil;
        self.player = [AEAudioFilePlayer audioFilePlayerWithURL:[NSURL fileURLWithPath:path] error:&error];
        
        if ( !_player ) {
            NSLog(@"player not set");
            return;
        }
        
        _player.removeUponFinish = YES;
        __weak ViewController *weakSelf = self;
        _player.completionBlock = ^{
            ViewController *strongSelf = weakSelf;
            strongSelf->_playButton.selected = NO;
            weakSelf.player = nil;
        };
        [_audioController addChannels:@[_player]];
        
        _playButton.selected = YES;
    }
}

- (IBAction)lowPitchSwitchChanged:(id)sender {
    UISwitch* uiswitch = (UISwitch*)sender;
    if ( uiswitch.isOn ) {
        self.lowPitchFilter = [[AENewTimePitchFilter alloc] init];
        self.lowPitchFilter.pitch = -700;
        [_audioController addFilter:_lowPitchFilter];
    } else {
        [_audioController removeFilter:_lowPitchFilter];
        self.lowPitchFilter = nil;
    }
}

- (IBAction)highPitchSwitchChanged:(id)sender {
    UISwitch* uiswitch = (UISwitch*)sender;
    if ( uiswitch.isOn ) {
        self.highPitchFilter = [[AENewTimePitchFilter alloc] init];
        self.highPitchFilter.pitch = 700;
        [_audioController addFilter:_highPitchFilter];
    } else {
        [_audioController removeFilter:_highPitchFilter];
        self.highPitchFilter = nil;
    }
}

- (IBAction)reverbSwitchChanged:(id)sender {
    UISwitch* uiswitch = (UISwitch*)sender;
    if ( uiswitch.isOn ) {
        self.reverb = [[AEReverbFilter alloc] init];
        _reverb.dryWetMix = 80;
        [_audioController addFilter:_reverb];
    } else {
        [_audioController removeFilter:_reverb];
        self.reverb = nil;
    }
}

@end
