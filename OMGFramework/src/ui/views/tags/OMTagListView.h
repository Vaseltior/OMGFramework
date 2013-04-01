//
//  OMTagListView.h
//  OMGFramework
//
//  Created by Samuel Grau on 10/5/12.
//  Copyright (c) 2012 Samuel Grau. All rights reserved.
//

#import <UIKit/UIKit.h>

/*!
 @brief This class will present tags as UIControl View
 */
@class OMTagView;

@interface OMTagListView : UIView

- (void)addTag:(OMTagView *)tagView;
- (void)removeTagAtIndex:(NSInteger)index;

@end
