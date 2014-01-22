//
//  Composition.h
//  PracticingPiano
//
//  Created by Luke Keniston on 12/9/13.
//  Copyright (c) 2013 Luke Keniston. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface Composition : NSManagedObject
@property (nonatomic, retain) NSString *pieceName;
@property (nonatomic, retain) NSString *composer;
@property (nonatomic, retain) NSNumber *tempo;
@end
