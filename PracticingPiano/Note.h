//
//  Note.h
//  PracticingPiano
//
//  Created by Luke Keniston on 11/16/13.
//  Copyright (c) 2013 Luke Keniston. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Note : NSManagedObject

@property (nonatomic, retain) NSNumber * startTime;
@property (nonatomic, retain) NSString * noteType;
@property (nonatomic, retain) NSString * endTime;


@end