//
//  MyDataManager.h
//  PennStateSearch
//
//  Created by LUKE SHANE KENISTON on 10/24/13.
//  Copyright (c) 2013 LUKE SHANE KENISTON. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataManagerDelegate.h"

@interface MyDataManager : NSObject <DataManagerDelegate>
-(void)addScaleNote:(NSDictionary*)dictionary;
-(void)addComposition:(NSDictionary*)dictionary;
@end
