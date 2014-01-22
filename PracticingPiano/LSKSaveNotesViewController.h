//
//  LSKSaveScaleViewController.h
//  PracticingPiano
//
//  Created by Luke Keniston on 12/14/13.
//  Copyright (c) 2013 Luke Keniston. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SaveDelegate <NSObject>

-(void)dismissMe;

// Saves the composition for the user
-(void)saveEnteredData:(NSDictionary*)dictionary;

@end
@interface LSKSaveNotesViewController : UITableViewController
@property (nonatomic, assign) id<SaveDelegate> delegate;
@property (nonatomic, assign) NSNumber *tempo;
@end
