//
//  NSException+OMConvenience.h
//  DicoReves
//
//  Created by Samuel Grau on 3/31/13.
//  Copyright (c) 2013 Samuel Grau. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSException (OMConvenience)

+ (void)raiseGenericException:(NSString *)format, ... ;

@end
