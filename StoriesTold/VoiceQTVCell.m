//
//  VoiceQTVCell.m
//  StoriesTold
//
//  Created by Niko Zarzani on 12/28/15.
//  Copyright © 2015 IndieZiOS. All rights reserved.
//

#import "VoiceQTVCell.h"
#import "Voice.h"
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

@interface VoiceQTVCell()

@property (weak, nonatomic) IBOutlet UILabel *createdAtLabel;
@property (weak, nonatomic) IBOutlet UILabel *createdByLabel;

@property (weak, nonatomic) IBOutlet UIButton *playStopButton;

@property (strong, nonatomic) Voice *voice;

@property (nonatomic, strong) AEAudioController *audioController;

@property (nonatomic, strong) AEAudioFilePlayer *player;

@end

@implementation VoiceQTVCell

- (void)updateFromObject:(nullable PFObject *)object
{
    self.createdAtLabel.text = @"";
    self.createdByLabel.text = @"";
    
    if ([object isKindOfClass:[Voice class]]) {
        
        Voice *voice = (Voice *)object;
        self.voice = voice;
        
        self.createdAtLabel.text = [NSDateFormatter localizedStringFromDate:self.voice.createdAt dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterMediumStyle];
        
        [voice.createdBy fetchIfNeededInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.createdByLabel.text = [voice.createdBy objectForKey:@"name"];
            });
        }];
        
        self.backgroundColor = kBeigeColor;
        self.playStopButton.layer.cornerRadius =  self.playStopButton.frame.size.width/2;
    }
}

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
    if(!_player){
        [self.voice.audio getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
            NSArray *documentsFolders = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *path = [documentsFolders[0] stringByAppendingPathComponent:@"Audio.m4a"];
            [[NSFileManager defaultManager] createFileAtPath:path contents:data attributes:nil];
            
            _player = [AEAudioFilePlayer audioFilePlayerWithURL:[NSURL fileURLWithPath:path] error:&error];
            
            if ( !_player ) {
                NSLog(@"player not set");
            }
            
            _player.removeUponFinish = YES;
            
            __weak VoiceQTVCell *weakSelf = self;
            _player.completionBlock = ^{
                VoiceQTVCell *strongSelf = weakSelf;
                weakSelf.player = nil;
                dispatch_async(dispatch_get_main_queue(), ^{
                    strongSelf.playStopButton.selected = NO;
                });
            };
            
            [self.audioController addChannels:@[_player]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.playStopButton.selected = YES;
            });
        }];
    }
}

- (void)stop
{
    [self.audioController removeChannels:@[_player]];
    self.player = nil;
    self.playStopButton.selected = NO;
}

- (IBAction)playStopTapped:(id)sender {
    if (self.player) {
        [self stop];
    } else {
        [self play];
    }
}

@end
