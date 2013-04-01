//
//  OMTagView.h
//  OMGFramework
//
//  Created by Samuel Grau on 10/5/12.
//  Copyright (c) 2012 Samuel Grau. All rights reserved.
//

#import "OMControl.h"

/*!
 * @brief The DRTagView is a simple class that display a tag like element
 */
@interface OMTagView : OMControl

/*! @brief The font the will be used to display the tag */
@property (nonatomic, strong) UIFont *font;

///-----------------------------------------------------------------------------
/// @name Properties
///-----------------------------------------------------------------------------

/*!
 * @brief Set the value of the text to display on the tag view
 * @param the value of the text to display on the tag view
 */
- (void)setText:(NSString *)text;

/*!
 * @brief Return the current text value of the tag
 * @return the current text value of the tag
 */
- (NSString *)text;

///-----------------------------------------------------------------------------
/// @name Static
///-----------------------------------------------------------------------------

+ (CGSize)sizeOfButtonWithString:(NSString *)string font:(UIFont *)font;

@end
