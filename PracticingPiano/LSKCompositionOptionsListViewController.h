//
//  LSKCompositionOptionsListViewController.h
//  PracticingPiano
//
//  Created by Luke Keniston on 12/16/13.
//  Copyright (c) 2013 Luke Keniston. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LSKCompositionOptionsListViewController : UIViewController
-(void)updatePlaceNotes:(NSArray*)notes;
@property NSNumber *tempo;  // tempo of composition
@end
