//
//  NSObject+OMKVOConvenience.m
//  OMGFramework
//
//  Created by Samuel Grau on 3/30/13.
//  Copyright (c) 2013 Samuel Grau. All rights reserved.
//

#import "NSObject+OMKVOConvenience.h"

@implementation NSObject (OMKVOConvenience)

- (void)omRegisterKeyPathsForKVO {
	for (NSString *keyPath in [self omObservableKeyPaths]) {
		[self addObserver:self forKeyPath:keyPath options:NSKeyValueObservingOptionNew context:NULL];
	}
}

- (void)omUnregisterKeyPathsFromKVO {
	for (NSString *keyPath in [self omObservableKeyPaths]) {
		[self removeObserver:self forKeyPath:keyPath];
	}
}

- (NSArray *)omObservableKeyPaths {
    return @[];
}

@end
