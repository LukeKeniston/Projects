//
//  LSKCompositionOptionsListViewController.m
//  PracticingPiano
//
//  Created by Luke Keniston on 12/16/13.
//  Copyright (c) 2013 Luke Keniston. All rights reserved.
//

#import "LSKCompositionOptionsListViewController.h"
#import "LSKSaveNotesViewController.h"
#import "MyDataManager.h"
#import "UIImageViewForNote.h"

@interface LSKCompositionOptionsListViewController () <SaveDelegate>
@property (nonatomic,strong) MyDataManager *myDataManager;
@property NSArray *placedNotes;

@end

@implementation LSKCompositionOptionsListViewController


-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
       _myDataManager = [[MyDataManager alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)saveEnteredData:(NSDictionary *)dictionary
{
    // save each of the individual notes for that composition
    for(NSDictionary *noteDictionary in self.placedNotes)
    {
        UIImageViewForNote *note = [noteDictionary objectForKey:@"note"];
        NSNumber *x = [NSNumber numberWithInt:note.frame.origin.x];
        NSNumber *y = [NSNumber numberWithInt:note.frame.origin.y];
        
        NSDictionary * newDictionary = @{@"pieceName":[dictionary objectForKey:@"name"], @"composer":[dictionary objectForKey:@"composer"], @"noteType":note.name, @"xPosition":x, @"yPosition":y};
        [self.myDataManager addScaleNote:newDictionary];
    }
    // save that given composition
    [self.myDataManager addComposition:dictionary];
    
}

-(void)dismissMe{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"SaveComposition"])
    {
        LSKSaveNotesViewController *saveNotesViewController = segue.destinationViewController;
        
        saveNotesViewController.delegate = self;
        saveNotesViewController.tempo = self.tempo;
    }
}
-(void)updatePlaceNotes:(NSArray *)notes
{
    _placedNotes = notes;
}
@end
