//
//  ScaleNote.h
//  PracticingPiano
//
//  Created by Luke Keniston on 12/9/13.
//  Copyright (c) 2013 Luke Keniston. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface ScaleNote : NSManagedObject

@property (nonatomic, retain) NSString *pieceName;
@property (nonatomic, retain) NSString *composer;
@property (nonatomic, retain) NSString *noteType;
@property (nonatomic, retain) NSNumber *xPosition;
@property (nonatomic, retain) NSNumber *yPosition;
@end
