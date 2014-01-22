//
//  UIImageViewForNote.m
//  PracticingPiano
//
//  Created by Luke Keniston on 12/2/13.
//  Copyright (c) 2013 Luke Keniston. All rights reserved.
//

#import "UIImageViewForNote.h"
@interface UIImageViewForNote ()

@property CGPoint placeOnGrid;
@property NSString *name;
@property double noteLength;
@property NSInteger placedInGrid;
@end

@implementation UIImageViewForNote


- (id)initWithImage:(UIImage *)image andName:(NSString*)name andLength:(double)length
{
    self = [super initWithImage:image];
    if (self) {
        self.placeOnGrid = CGPointMake(-1.0, -1.0);  // the note is currently not on the grid
        self.name = name;
        self.placedInGrid = 0;
        self.noteLength = length;
    }
    return self;
}
-(void)noteIsOnGrid
{
    self.placedInGrid = 1;  // note is placed on the grid
}
-(void)valueOfPlaceOnGrid:(CGPoint)piecePoint {
    self.placeOnGrid = piecePoint;   // updates the notes location on the grid
}

@end
