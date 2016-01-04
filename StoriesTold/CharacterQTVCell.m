//
//  CharacterQTVCell.m
//  StoriesTold
//
//  Created by Niko Zarzani on 1/1/16.
//  Copyright © 2016 IndieZiOS. All rights reserved.
//

#import "CharacterQTVCell.h"
#import "Character.h"
#import "Constants.h"

#import "AppDelegate.h"
#import "TheAmazingAudioEngine.h"
#import "AERecorder.h"
#import "TPOscilloscopeLayer.h"
#import "AEReverbFilter.h"
#import "AELowPassFilter.h"
#import "AEDistortionFilter.h"
#import "AENewTimePitchFilter.h"

@interface CharacterQTVCell()

@property (weak, nonatomic) IBOutlet UIButton *playStopButton;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet PFImageView *characterImageView;
@property (weak, nonatomic) IBOutlet UIView *characterBackgroundView;

@property (strong, nonatomic) Character * character;

@property (nonatomic, strong) AEAudioController *audioController;
@property (nonatomic, strong) AEAudioFilePlayer *player;

@end

@implementation CharacterQTVCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    UIView *bgColorView = [[UIView alloc] initWithFrame:self.characterBackgroundView.frame];
    bgColorView.backgroundColor = kWallnutColor;
    self.selectedBackgroundView = bgColorView;
}

- (void)updateFromObject:(nullable PFObject *)object
{
    if ([object isKindOfClass:[Character class]]) {
        Character *character = (Character *)object;
        self.character = character;
        self.backgroundColor = kBeigeColor;
        self.characterBackgroundView.layer.cornerRadius = 2.0f;
        self.characterBackgroundView.layer.borderColor = kDarkBeigeColor.CGColor;
        self.characterBackgroundView.layer.borderWidth = 1.0f;
        
        self.playStopButton.layer.cornerRadius =  self.playStopButton.frame.size.width/2;
        self.playStopButton.hidden = !character.audioDescription;
        
        self.nameLabel.text = [character.name capitalizedString];
        
        self.characterImageView.image = [UIImage imageNamed:@"Male"];
        self.characterImageView.file = character.image; // remote image
        [self.characterImageView loadInBackground];
        self.characterImageView.backgroundColor = kLightGrayColor;
        self.characterImageView.layer.cornerRadius = self.characterImageView.frame.size.width / 2;
        self.characterImageView.layer.borderColor = kDarkBeigeColor.CGColor;
        self.characterImageView.layer.borderWidth = 2.0;

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
    if(!self.player){
        [self.character.audioDescription getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
            NSArray *documentsFolders = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *path = [documentsFolders[0] stringByAppendingPathComponent:@"Audio.m4a"];
            [[NSFileManager defaultManager] createFileAtPath:path contents:data attributes:nil];
            
            self.player = [AEAudioFilePlayer audioFilePlayerWithURL:[NSURL fileURLWithPath:path] error:&error];
            
            if ( !self.player ) {
                NSLog(@"player not set");
            }
            
            self.player.removeUponFinish = YES;
            
            __weak CharacterQTVCell *weakSelf = self;
            self.player.completionBlock = ^{
                CharacterQTVCell *strongSelf = weakSelf;
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
    [self.audioController removeChannels:@[self.player]];
    self.player = nil;
    self.playStopButton.selected = NO;
}

- (IBAction)playStopTapped:(id)sender {
    if (self.playStopButton.selected) {
        [self stop];
    } else {
        [self play];
    }
}

@end
