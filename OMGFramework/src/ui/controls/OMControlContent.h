//
//  YMControlContent.h
//  OMGFramework
//
//  Created by Samuel Grau on 10/3/11.
//  Copyright 2011 OMGFramework. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OMControl;

@interface OMControlContent : NSObject

@property (nonatomic, copy) NSString * title;

- (id)initWithControl:(OMControl *)control;

@end
