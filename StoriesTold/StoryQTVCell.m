//
//  StoryQTVCell.m
//  StoriesTold
//
//  Created by Niko Zarzani on 12/2/15.
//  Copyright © 2015 IndieZiOS. All rights reserved.
//

#import "StoryQTVCell.h"
#import "Constants.h"
#import "Story.h"
#import "UIImageView+Utils.h"

#import "AppDelegate.h"
#import "TheAmazingAudioEngine.h"
#import "AERecorder.h"
#import "TPOscilloscopeLayer.h"
#import "AEReverbFilter.h"
#import "AELowPassFilter.h"
#import "AEDistortionFilter.h"
#import "AENewTimePitchFilter.h"

#import "PFUser+StoriesTold.h"

#import <pop/POP.h>

@interface StoryQTVCell ()

@property (weak, nonatomic) IBOutlet UILabel *storyTitleLabel;
@property (weak, nonatomic) IBOutlet PFImageView *storyImageView;
@property (weak, nonatomic) IBOutlet UILabel *storyImageLabel;
@property (weak, nonatomic) IBOutlet UIView *storyBackgroundView;
@property (weak, nonatomic) IBOutlet UIView *storyImageContainerView;
@property (weak, nonatomic) IBOutlet UIButton *playStopButton;
@property (weak, nonatomic) IBOutlet UIButton *loveButton;
@property (weak, nonatomic) IBOutlet UILabel *loveCountLabel;

@property (strong, nonatomic) Story *story;
@property (nonatomic, strong) AEAudioController *audioController;
@property (nonatomic, strong) AEAudioFilePlayer *player;

@end

@implementation StoryQTVCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    UIView *bgColorView = [[UIView alloc] initWithFrame:self.storyBackgroundView.frame];
    bgColorView.backgroundColor = kWallnutColor;
    self.selectedBackgroundView = bgColorView;
}

- (void)updateFromObject:(nullable PFObject *)object
{
    [self.loveButton.imageView setImageRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    if ([object isKindOfClass:[Story class]]) {
        Story *story = (Story *)object;
        self.story = story;
        self.backgroundColor = kBeigeColor;
        self.storyBackgroundView.layer.cornerRadius = 2.0f;
        self.storyBackgroundView.layer.borderColor = kDarkBeigeColor.CGColor;
        self.storyBackgroundView.layer.borderWidth = 1.0f;
        self.storyImageContainerView.layer.cornerRadius = 2.0f;
        self.storyImageLabel.text = @"";
        self.storyImageView.file = nil; // remote image
        self.playStopButton.layer.cornerRadius =  self.playStopButton.frame.size.width/2;
        self.playStopButton.hidden = !story.abstract;
        
        [self refreshLoveButton];

        // Set vertical effect
        UIInterpolatingMotionEffect *verticalMotionEffect =
        [[UIInterpolatingMotionEffect alloc]
         initWithKeyPath:@"center.y"
         type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
        verticalMotionEffect.minimumRelativeValue = @(-1);
        verticalMotionEffect.maximumRelativeValue = @(1);
        
        // Set horizontal effect
        UIInterpolatingMotionEffect *horizontalMotionEffect =
        [[UIInterpolatingMotionEffect alloc]
         initWithKeyPath:@"center.x"
         type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
        horizontalMotionEffect.minimumRelativeValue = @(-1);
        horizontalMotionEffect.maximumRelativeValue = @(1);
        
        // Create group to combine both
        UIMotionEffectGroup *group = [UIMotionEffectGroup new];
        group.motionEffects = @[horizontalMotionEffect, verticalMotionEffect];
        // Add both effects to your view
        [self.storyImageView addMotionEffect:group];
        self.storyTitleLabel.text = [story.title capitalizedString];

        self.storyImageView.image = [UIImage imageNamed:@""]; // placeholder image
        [story.dimension fetchIfNeededInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
            self.storyImageLabel.text = [story.dimension.name capitalizedString];
            self.storyImageView.file = story.dimension.image; // remote image
            
            [self.storyImageView loadInBackground];
        }];
        
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
        [self.story.abstract getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
            NSArray *documentsFolders = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *path = [documentsFolders[0] stringByAppendingPathComponent:@"Audio.m4a"];
            [[NSFileManager defaultManager] createFileAtPath:path contents:data attributes:nil];
            
            self.player = [AEAudioFilePlayer audioFilePlayerWithURL:[NSURL fileURLWithPath:path] error:&error];
            
            if ( !self.player ) {
                NSLog(@"player not set");
            }
            
            self.player.removeUponFinish = YES;
            
            __weak StoryQTVCell *weakSelf = self;
            self.player.completionBlock = ^{
                StoryQTVCell *strongSelf = weakSelf;
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

#pragma mark - Love Story

- (IBAction)toggleLoveStory:(id)sender {
    self.loveButton.enabled = NO;
    [PFCloud callFunctionInBackground:@"toggleUserLovesStory"
                       withParameters:@{@"storyId":self.story.objectId}
                                block:^(id  _Nullable object, NSError * _Nullable error) {
                                    self.loveButton.enabled = YES;
                                    if(!error){
                                        [self refreshLoveButton];
                                    }
                                }];
}

- (void)refreshLoveButton
{
    self.loveButton.enabled = YES;
    [[PFUser currentUser] likesStory:self.story inBackgroundWithBlock:^(BOOL lovesStory, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (lovesStory) {
                POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
                scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.05, 1.05)];
                scaleAnimation.springBounciness = 30.f;
                [self.loveButton.layer pop_addAnimation:scaleAnimation forKey:@"scaleAnim"];
                
                self.loveButton.tintColor = [UIColor blackColor];
                self.loveCountLabel.textColor = [UIColor whiteColor];
                
            }
            else {
                POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
                scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.0, 1.0)];
                scaleAnimation.springBounciness = 10.f;
                [self.loveButton.layer pop_addAnimation:scaleAnimation forKey:@"scaleAnim"];
                
                self.loveButton.tintColor = kDarkBeigeColor;
                self.loveCountLabel.textColor = [UIColor blackColor];
            };
        });
        
        [self.story fetchInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.loveCountLabel.text = [NSString stringWithFormat:@"%@", self.story.loveCount ? self.story.loveCount : @0];
            });
        }];
    }];
}

@end
