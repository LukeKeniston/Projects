//
//  Model.m
//  PracticingPiano
//
//  Created by Luke Keniston on 12/2/13.
//  Copyright (c) 2013 Luke Keniston. All rights reserved.
//

#import "Model.h"
#import "UIImageViewForNote.h"



@interface Model ()
@property (nonatomic,strong) NSArray *noteDictionary;    // holds all of the note definitions

@property NSInteger currentImageTag;

@end

@implementation Model


- (id)init
{
    self = [super init];
    if (self) {
      _noteDictionary = [self createNotes];
    }
    return self;
}

// create a list of musical notes from a plist.
// stores list so view controller is identify pieces by name instead of storing entire infomration in view controller class
-(NSArray*) createNotes
{
    NSString *sourcePath = [[NSBundle mainBundle] pathForResource:@"MusicalNotes" ofType:@"plist"];
    NSArray *allNotes = [NSArray arrayWithContentsOfFile:sourcePath];
    
    NSMutableArray *temporaryNoteImageArray = [NSMutableArray array];
    for(NSDictionary *note in allNotes)
    {
        [temporaryNoteImageArray addObject:note];
    }
    NSArray* noteArray = [NSMutableArray arrayWithArray:temporaryNoteImageArray];
    return noteArray;
    
}
// retreives one of the note's information based on the notes name
-(NSDictionary*)retreiveNoteData:(NSString*)noteName
{
    for(NSDictionary *note in self.noteDictionary)
    {
        NSString *name = [note objectForKey:@"ImageName"];
        if([noteName isEqualToString:name])
        {
            return note;
        }
    }
    return NULL;
}


@end
