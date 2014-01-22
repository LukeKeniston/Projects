//
//  Composition+Name.m
//  PracticingPiano
//
//  Created by Luke Keniston on 12/15/13.
//  Copyright (c) 2013 Luke Keniston. All rights reserved.
//

#import "Composition+Name.h"

@implementation Composition (Name)
-(NSString*)firstLetterOfName {
    NSString *letter = [self.pieceName substringToIndex:1];
    return letter;
}
@end
