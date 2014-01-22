//
//  UIImageViewForNote.h
//  PracticingPiano
//
//  Created by Luke Keniston on 12/2/13.
//  Copyright (c) 2013 Luke Keniston. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageViewForNote: UIImageView
@property (readonly,nonatomic) NSString *name;          // name of the type of note
@property (readonly, nonatomic) double noteLength;      // note length
@property (readonly, nonatomic) CGPoint placeOnGrid;    // where note is on the gird
@property (readonly, nonatomic) NSInteger placedInGrid; // whether or note the note is currently on the grid

// sets the location on the grid for that piece
-(void)valueOfPlaceOnGrid:(CGPoint)piecePoint;
// identifies that the piece is on the grid
-(void)noteIsOnGrid;
// creates an instant of the piece with its name and musical length
- (id)initWithImage:(UIImage *)image andName:(NSString*)name andLength:(double)length;
@end
