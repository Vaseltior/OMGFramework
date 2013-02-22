//
//  OMControl.h
//  OMGFramework
//
//  Created by Samuel Grau on 10/3/11.
//  Copyright 2011 OMGFramework. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OMControlContent;

/*!
 @brief A class that can be used in replacement to a UIButton, and customized
 like any other view.
 */
@interface OMControl : UIControl

/*!
 @brief Return the title for the given state
 
 @param state The UIControlState
 
 @return The title for the given state
 */
- (NSString*)titleForState:(UIControlState)state;

/*!
 @brief Set the title for the given state
 @param title The title to set for the current state
 @param state The UIControlState
 */
- (void)setTitle:(NSString*)title forState:(UIControlState)state;

/*!
 @brief Return _YES_ if the control is currently highlighted or selected, otherwise return _NO_
 @return Return _YES_ if the control is currently highlighted or selected, otherwise return _NO_
 */
- (BOOL)isHighlightedOrSelected;

@end
