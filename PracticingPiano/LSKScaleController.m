//
//  LSKScaleController.m
//  PracticingPiano
//
//  Created by Luke Keniston on 11/19/13.
//  Copyright (c) 2013 Luke Keniston. All rights reserved.
//

#import "LSKScaleController.h"
#import "Model.h"
#import "UIImageViewForNote.h"
#import "LSKCompositionOptionsListViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

#define kSlackForGridSnap 18
#define kSlackForUpperGridYSnap 36
#define kSquareSizeX 30
#define kHighestKeyNoteIndex 31
#define kSquareSizeY 9
#define kStaffGridSpace 55
#define kbasePositioninCompostion 44
#define kbeatsPerMinute 60
#define kArbitraryNoteIndex 10

AVAudioPlayer *sound;   // using to play audio for the each notes


@interface LSKScaleController () 
@property (weak, nonatomic) IBOutlet UIImageView *musicalScaleImageView;
- (IBAction)playComposition:(id)sender;
@property (weak, nonatomic) IBOutlet UISlider *beatsPerMinuteSlider;

@property (strong, nonatomic) NSArray *musicalNotes;
@property (strong, nonatomic) NSMutableArray *placedNotes;

@property (strong, nonatomic) Model *model;
@property NSInteger preCreatedNotes;
@property NSInteger sliderValue;
@end


@implementation LSKScaleController
-(void)viewDidAppear:(BOOL)animated
{
    [self createImageViewsAndPlaceOnGrid];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
// This is the only fix I found would work. The problem I was running into was that is would freeze for a second and won't play sound until it was unfrozen.
    NSString* boardName = [NSString stringWithFormat:@"PianoNote%i",kArbitraryNoteIndex]; // arbitary recording
    NSString *pathsoundFile = [[NSBundle mainBundle] pathForResource:boardName ofType:@"mp3"];
    sound = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:pathsoundFile] error:NULL];
    [sound play];
    [sound stop];
    // updates the slide to the correct position based on standard or save composition
    [self.beatsPerMinuteSlider setValue:self.sliderValue animated:YES];

}

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        _model = [[Model alloc] init];
        _placedNotes = [NSMutableArray array];
        self.preCreatedNotes = 0;
        self.sliderValue = 60;
    }
    return self;
}

-(void)createImageViewsAndPlaceOnGrid {
    // adds each of the notes to the view
    for(NSDictionary *noteInformation in [self.model noteDictionary])
    {
        [self addNoteToGrid:noteInformation];
    }
    
}
// takes each of the notes information and adds that note as a note to choose from
-(void)addNoteToGrid:(NSDictionary*)noteInformation
{
    NSString *imageName = [noteInformation objectForKey:@"ImageName"];
    UIImage *noteImage = [UIImage imageNamed:imageName];
    NSNumber *noteLength = [noteInformation objectForKey:@"Length"];
    // creates a new custom UIImageView for the note
    UIImageViewForNote *note = [[UIImageViewForNote alloc] initWithImage:noteImage andName:imageName andLength:[noteLength doubleValue]];
    // collects all of the information for that note
    NSInteger x = [[noteInformation objectForKey:@"FrameLocationX"] integerValue];
    NSInteger y = [[noteInformation objectForKey:@"FrameLocationY"] integerValue];
    NSInteger height = [[noteInformation objectForKey:@"Height"] integerValue];
    NSInteger width = [[noteInformation objectForKey:@"Width"] integerValue];
    CGRect noteSize = CGRectMake(x, y, width, height);
    // adds handlers for the notes movement across the screen
    [self createNoteHandlers: note];
    note.frame = noteSize;
    // adds the note to the subview
    [self.view addSubview:note];
    if(self.preCreatedNotes == 1)
    {
        NSNumber* noteXValue = [NSNumber numberWithInteger:x];
        NSNumber* noteYValue = [NSNumber numberWithInteger:y];
        NSDictionary *noteEntity = @{@"note": note, @"xPosition":noteXValue, @"yPosition":noteYValue};
        // adds thte note the placed note list
        [self.placedNotes addObject:noteEntity];
    }
}
// alls the note to be dragged across the screen onto the muscial scale
-(void)createNoteHandlers:(UIImageView*)note {
    note.userInteractionEnabled = YES;
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanRecognized:)];
    [note addGestureRecognizer:panGesture];
}


// returns the X point in grid otherwise returns -1
-(NSInteger)xPostionWithinGrid:(UIView*)note{
    NSInteger boardFrameX = self.musicalScaleImageView.frame.origin.x;
    NSInteger boardWidth = self.musicalScaleImageView.frame.size.width;
    
    NSInteger noteFrameX = note.frame.origin.x;
    NSInteger noteWidth = note.frame.size.width;
    // checks if the note is within the scale bound and records its new position
    BOOL withinBoardXRange = (noteFrameX >= boardFrameX + kStaffGridSpace && noteFrameX + noteWidth < boardWidth + boardFrameX + kSlackForGridSnap);
    if(withinBoardXRange)
    {
        NSInteger noteAwayLeftPartOfSquare = ((noteFrameX - boardFrameX) % kSquareSizeX);
        NSInteger newXPostion;
        if(noteAwayLeftPartOfSquare <= kSquareSizeX/2)
        {
            newXPostion = noteFrameX - noteAwayLeftPartOfSquare;
        }
        else
        {
            newXPostion = noteFrameX + (kSquareSizeX - noteAwayLeftPartOfSquare);
        }
        return newXPostion;
    }
    return -1;
    
}

// returns the X point in grid otherwise returns -1
-(NSInteger)yPostionWithinGrid:(UIView*)note{
    NSInteger boardFrameY = self.musicalScaleImageView.frame.origin.y;
    NSInteger boardHeight = self.musicalScaleImageView.frame.size.height;
    
    NSInteger noteFrameY = note.frame.origin.y;
    NSInteger noteHeight = note.frame.size.height;
   
    
    // checks if the note is wihin the scale bounds and records its new position
    BOOL withinBoardYRange = (noteFrameY >= boardFrameY - kSlackForUpperGridYSnap && noteFrameY + noteHeight < boardHeight + boardFrameY + kSlackForGridSnap);
    if(withinBoardYRange)
    {
        NSInteger noteAwayTopPartOfSquare = ((noteFrameY - boardFrameY) % kSquareSizeY);
        NSInteger newYPostion;
        
        if(noteAwayTopPartOfSquare <= kSquareSizeY/2)
        {
            newYPostion = noteFrameY - noteAwayTopPartOfSquare;
        }
        else
        {
            newYPostion = noteFrameY + (kSquareSizeY - noteAwayTopPartOfSquare);
        }
        return newYPostion;
    }
    return -1;
}

// returns point within the grid otherwise returns point -1, -1
-(CGPoint)noteGridLocation:(UIView*)note {
    NSInteger yPostion = [self yPostionWithinGrid:note]; // returns -1 if not in grid
    NSInteger xPostion = [self xPostionWithinGrid:note]; // returns -1 if not in grid
    CGPoint noteLocation;
    if(yPostion == -1 || xPostion == -1)
    {
        noteLocation = CGPointMake(-1, -1);
    }
    else
    {
        NSInteger boardFrameX = self.musicalScaleImageView.frame.origin.x;
        NSInteger boardFrameY = self.musicalScaleImageView.frame.origin.y;
        
        NSInteger gridXBoxLocation = (xPostion - boardFrameX);
        NSInteger gridYBoxLocation = (yPostion - boardFrameY);
        noteLocation = CGPointMake(gridXBoxLocation, gridYBoxLocation);
    }
    return noteLocation;
}

// snaps the note into either the line or the space in betwee nthe line otherwise deletes the note
-(void)snapToGrid:(UIImageViewForNote*)note{
    NSInteger boardFrameX = self.musicalScaleImageView.frame.origin.x;
    NSInteger boardFrameY = self.musicalScaleImageView.frame.origin.y;
    CGPoint noteBoardLocation = [self noteGridLocation:note];
    // adds the note or changes its position within the grid
    if(noteBoardLocation.x != -1 && noteBoardLocation.y != -1)
    {
        
        NSInteger noteFrameX = boardFrameX + noteBoardLocation.x;
        NSInteger noteFrameY = boardFrameY + noteBoardLocation.y;
        
        NSInteger noteAwayLeftPartOfSquare = ((NSInteger)(noteBoardLocation.x) % kSquareSizeX);
        NSInteger noteAwayTopPartOfSquare = ((NSInteger)(noteBoardLocation.y) % kSquareSizeY);
        NSInteger newXPostion;
        NSInteger newYPostion;
        // finds nearest location of where the piece should be place based on where user releases it
        if(noteAwayLeftPartOfSquare <= kSquareSizeX/2)
        {
            newXPostion = noteFrameX - noteAwayLeftPartOfSquare;
        }
        else
        {
            newXPostion = noteFrameX + (kSquareSizeX - noteAwayLeftPartOfSquare);
        }
        
        if(noteAwayTopPartOfSquare <= kSquareSizeY/2)
        {
            newYPostion = noteFrameY - noteAwayTopPartOfSquare;
        }
        else
        {
            newYPostion = noteFrameY + (kSquareSizeY - noteAwayTopPartOfSquare);
        }
        
        CGRect newFrame = CGRectMake(newXPostion,newYPostion, note.frame.size.width, note.frame.size.height);
       
        // if the piece has already be on the grid
        if([note placedInGrid] == 0)
        {
            // adds the note to the array of placed notes to play
            [self addNoteToPlacedNotes:note andXLocation:noteFrameX andYLocation:noteFrameY];
        }
        // the piece is moved from on spot of the grid to another
        else
        {
            // first remove the note in placed notes and then later add it back with the new position
            [self removeNoteFromPlacedNotes:note];
            // sets the new frame loction for the frame
            [note setFrame:newFrame];
            [self addNoteToPlacedNotes:note andXLocation:noteFrameX andYLocation:noteFrameY];
        }
        // sets the flag stating the piece is now on the grid
        [note noteIsOnGrid];
        
    }
    // removes the note from the grid
    else
    {
        [self removeNoteFromGrid:note];
        
    }
    
}
// adds the note to a array of notes to play
-(void)addNoteToPlacedNotes:(UIImageViewForNote*)note andXLocation:(NSInteger)x andYLocation:(NSInteger)y
{
    NSString *noteName = [note name];
    NSDictionary *noteInformation = [self.model retreiveNoteData:noteName];
    [self addNoteToGrid:noteInformation];
    
    NSNumber* noteXValue = [NSNumber numberWithInteger:x];
    NSNumber* noteYValue = [NSNumber numberWithInteger:y];
    NSDictionary *noteEntity = @{@"note": note, @"xPosition":noteXValue, @"yPosition":noteYValue};
    // adds thte note the placed note list
    [self.placedNotes addObject:noteEntity];
}
// remove the note form placed notes
-(void) removeNoteFromPlacedNotes:(UIImageViewForNote*)note
{
    NSString *noteName = [note name];
    // gets information of note
    NSDictionary *noteInformation = [self.model retreiveNoteData:noteName];
    [self addNoteToGrid:noteInformation];
    NSInteger noteXValue = note.frame.origin.x;
    NSInteger noteYValue =note.frame.origin.y;
    
    NSMutableIndexSet *discardedItems = [NSMutableIndexSet indexSet];
    NSUInteger index = 0;
    // scans through entire list of placed notes and remove the piece with previous x and y value from the list.
    // As this may cause a problem is two notes have that x and y position, but I think is pretty unlike that this will occur. I couldn't think a better way of safely and effectively remove the pieces
    for (NSDictionary* noteDictionary in self.placedNotes) {
        UIImageView *note = [noteDictionary objectForKey:@"note"];
        NSInteger xPosition = note.frame.origin.x;
        NSInteger yPostion = note.frame.origin.y;
        if (xPosition == noteXValue && yPostion == noteYValue)
            [discardedItems addIndex:index];
        index++;
    }
    // removes all elements at the given location
    [self.placedNotes removeObjectsAtIndexes:discardedItems];
}

-(void)removeNoteFromGrid:(UIImageViewForNote*)note
{
    // removes the note from the list of placed notes
    [self removeNoteFromPlacedNotes:note];
    // removes the note from the view
    [note removeFromSuperview];
}

-(void)handlePanRecognized:(UIPanGestureRecognizer*)recognizer {
    UIView *note = recognizer.view;
    UIImageViewForNote *noteWrapper = (UIImageViewForNote*)note;
    CGPoint cursorPoint = [recognizer locationInView:self.view];
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:
            break;
        case UIGestureRecognizerStateChanged:
            note.center = cursorPoint; // moves the note with the curser
            break;
        case UIGestureRecognizerStateEnded:
            // snaps note to the grid once the user stop moving the note
            [self snapToGrid:noteWrapper];
            break;
        case UIGestureRecognizerStateCancelled:
            break;
            
        default:
            break;
    }
}

-(NSArray*)sortnotesWithDictionaryByLocation
{
    // sorts the notes based on the x position as one would want them played in chronological order
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"xPosition"
                                                 ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    return [self.placedNotes sortedArrayUsingDescriptors:sortDescriptors];
    
}
- (void) playAppropriateNote:(UIImageViewForNote*)note
{
    [sound stop]; // stops any previous note that was playing
    NSInteger yposition = note.frame.origin.y;
    // finds the correct note to play
    NSInteger keyNumber = kHighestKeyNoteIndex - ((yposition - kbasePositioninCompostion) / kSquareSizeY);
    NSString* keyName = [NSString stringWithFormat:@"PianoNote%i",keyNumber];
    NSString *pathsoundFile = [[NSBundle mainBundle] pathForResource:keyName ofType:@"mp3"];
    sound = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:pathsoundFile] error:NULL];
    // plays note until next note or stopped
    [sound play];
}
// stops the current audio from playing
-(void) stopAudio
{
    [sound stop];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// plays the composition the the user created
- (IBAction)playComposition:(id)sender {
    // sorts the notes that are on the grid in order from left to right
    NSArray *sortedPlacedNotes = [self sortnotesWithDictionaryByLocation];
    double nextLength = 0;
    int previousXPostion = 0;
    double previousLength = 0;
    // sets the notes up such that after a certain delay they play
    for(NSDictionary* noteDictionary in sortedPlacedNotes)
    {
        UIImageViewForNote *note = [noteDictionary objectForKey:@"note"];
        // checks if they notes are on the save x position
        // if so plays the notes at the same time
        // the notes do note line up exactly but within 1, usually at .5 away from the save x value
        if(abs(note.frame.origin.x - previousXPostion) < 1)
        {
            nextLength -= previousLength;
        }
        // plays the given note after a delay based on the legnth of time of the previous notes in the list
        [self performSelector:@selector(playAppropriateNote:) withObject:note afterDelay:nextLength];
        // finds the length of the next note and adds that to the new time to play
        previousLength = (note.noteLength) * (150 - self.beatsPerMinuteSlider.value)/kbeatsPerMinute;
        nextLength += previousLength;
        previousXPostion = note.frame.origin.x;
    }
    // stops the last note after the length of the note has expired
    [self performSelector:@selector(stopAudio) withObject:nil afterDelay:nextLength];

}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    LSKCompositionOptionsListViewController *optionsViewController = segue.destinationViewController;
    // sends the list of notes so that they can be saved in the composition option menu
   [optionsViewController updatePlaceNotes:self.placedNotes];
    optionsViewController.tempo = [NSNumber numberWithInteger:self.beatsPerMinuteSlider.value];
}
// if uploading a composition this method is called
-(void) intialNotePlacement:(NSArray*)noteInformationArray andTempo:(NSNumber*)tempo
{
    // sets the previous speed
    self.sliderValue = [tempo intValue]; //
    self.preCreatedNotes = 1;   // tells that notes are added to scale
    // creates each of the notes on the musical scale where they were saved
    for(NSDictionary *noteInfo in noteInformationArray)
    {
        NSString *name = [noteInfo objectForKey:@"type"];
        NSDictionary *noteInformation = [self.model retreiveNoteData:name];
        // recreates dictionary that is needed to make the pieces
        NSDictionary *newNoteInformation = @{@"ImageName":[noteInformation objectForKey:@"ImageName"], @"Length":[noteInformation objectForKey:@"Length"], @"FrameLocationX": [noteInfo objectForKey:@"xPosition" ] , @"FrameLocationY": [noteInfo objectForKey:@"yPosition"], @"Height": [noteInformation objectForKey:@"Height"], @"Width": [noteInformation objectForKey:@"Width"]};
        // adds the note
        [self addNoteToGrid:newNoteInformation];
    }
    self.preCreatedNotes = 0;
}
@end

