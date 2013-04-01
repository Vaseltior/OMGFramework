//
//  OMTagListViewDelegate.h
//  OMGFramework
//
//  Created by Samuel Grau on 4/1/13.
//  Copyright (c) 2013 Samuel Grau. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol OMTagListViewDelegate <NSObject>

- (void)tagTouchedAtIndex:(NSInteger)index;

@end
