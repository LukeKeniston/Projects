//
//  LSKPianoController.m
//  PracticingPiano
//
//  Created by Luke Keniston on 11/14/13.
//  Copyright (c) 2013 Luke Keniston. All rights reserved.
//

#import "LSKPianoController.h"
#import "Constants.h"

#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

#define kArbitraryPianoIndex 10

AVAudioPlayer *sound;

@interface LSKPianoController () <AVAudioPlayerDelegate>
- (IBAction)releaseButton:(id)sender;
- (IBAction)pressButton:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *KeyLabel;
@property (weak, nonatomic) IBOutlet UILabel *blackKeyLabel;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *showKeysButton;

- (IBAction)showKeys:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *keyNames;


@end

@implementation LSKPianoController


- (void)viewDidLoad
{
    [super viewDidLoad];
// This is the only fix I found would work. The problem I was running into was that is would freeze for a second and won't play sound until it was unfrozen.
    NSString* boardName = [NSString stringWithFormat:@"PianoNote%i", kArbitraryPianoIndex]; // arbitary recording
    NSString *pathsoundFile = [[NSBundle mainBundle] pathForResource:boardName ofType:@"mp3"];
    sound = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:pathsoundFile] error:NULL];
    [sound play];
    [sound stop];
}

-(void) viewWillAppear:(BOOL)animated
{
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    NSNumber *boolNumber = [preferences objectForKey:kShowNotes];
    // based on the preferences, the app shows the key names or note
    if([boolNumber boolValue] == 1)
    {
        [self.keyNames setHidden:NO];
        [self.blackKeyLabel setHidden:NO];
        [self.showKeysButton setTitle:@"Hide Key Names"];
    }
    else
    {
        [self.keyNames setHidden:YES];
        [self.blackKeyLabel setHidden:YES];
        [self.showKeysButton setTitle:@"Show Key Names"];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// one of the keys have been pressed down
- (IBAction)pressButton:(id)sender {
    // plays the keys in which the user selected
    // keys are identified by tag id number for each of the buttons
    NSInteger keyNumber = [sender tag];
    NSString* keyName = [NSString stringWithFormat:@"PianoNote%i",keyNumber];
    NSString *pathsoundFile = [[NSBundle mainBundle] pathForResource:keyName ofType:@"mp3"];
    sound = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:pathsoundFile] error:NULL];
    [sound play];
}

// the keys stops playing sound if the user releases the keys or drags off of the key like a real piano
- (IBAction)releaseButton:(id)sender {
    [sound stop];
}

// shows or hides the keys based on clicking a button
- (IBAction)showKeys:(id)sender{
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    NSNumber *boolShowNotes = [preferences objectForKey:kShowNotes];
    if([boolShowNotes boolValue] == 0)
    {
        [self.keyNames setHidden:NO];
        [self.blackKeyLabel setHidden:NO];
        [self.showKeysButton setTitle:@"Hide Key Names"];
    }
    else
    {
        [self.keyNames setHidden:YES];
        [self.blackKeyLabel setHidden:YES];
        [self.showKeysButton setTitle:@"Show Key Names"];
    }
    [preferences setBool:![boolShowNotes boolValue] forKey:kShowNotes];
    // saves the user choice
    [preferences synchronize];
    
}

@end

