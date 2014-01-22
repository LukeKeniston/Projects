//
//  MyDataManager.m
//  PennStateSearch
//
//  Created by LUKE SHANE KENISTON on 10/24/13.
//  Copyright (c) 2013 LUKE SHANE KENISTON. All rights reserved.
//

#import "MyDataManager.h"
#import "DataManager.h"
#import "Note.h"
#import "ScaleNote.h"
#import "Composition.h"

@implementation MyDataManager

-(NSString*)xcDataModelName {
    return @"MusicNotes";
}

-(void)createDatabaseFor:(DataManager *)dataManager {
    [dataManager saveContext];
}

-(void)addScaleNote:(NSDictionary*)dictionary {
    DataManager *dataManager = [DataManager sharedInstance];
    NSManagedObjectContext *managedObjectContext = dataManager.managedObjectContext;
    
    ScaleNote *scaleNote = [NSEntityDescription insertNewObjectForEntityForName:@"ScaleNote" inManagedObjectContext:managedObjectContext];

    scaleNote.pieceName = [dictionary objectForKey:@"pieceName"];
    scaleNote.composer =[dictionary objectForKey:@"composer"];
    scaleNote.noteType = [dictionary objectForKey:@"noteType"];
    scaleNote.xPosition = [dictionary objectForKey:@"xPosition"];
    scaleNote.yPosition = [dictionary objectForKey:@"yPosition"];
}

-(void)addComposition:(NSDictionary*)dictionary {
    DataManager *dataManager = [DataManager sharedInstance];
    NSManagedObjectContext *managedObjectContext = dataManager.managedObjectContext;
    
    Composition *addComposition = [NSEntityDescription insertNewObjectForEntityForName:@"Composition" inManagedObjectContext:managedObjectContext];
    addComposition.composer = [dictionary objectForKey:@"composer"];
    addComposition.pieceName = [dictionary objectForKey:@"name"];
    addComposition.tempo = [dictionary objectForKey:@"tempo"];
}



@end
