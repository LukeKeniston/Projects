//
//  Model.h
//  PracticingPiano
//
//  Created by Luke Keniston on 12/2/13.
//  Copyright (c) 2013 Luke Keniston. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Model : NSObject
@property (readonly,strong) NSArray *noteDictionary;      
-(NSDictionary*)retreiveNoteData:(NSString*)noteName; // retrives informations about the note wanted
@end
