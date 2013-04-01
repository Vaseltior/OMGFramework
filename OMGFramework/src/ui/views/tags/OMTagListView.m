//
//  OMTagListView.m
//  OMGFramework
//
//  Created by Samuel Grau on 10/5/12.
//  Copyright (c) 2012 Samuel Grau. All rights reserved.
//

#import "OMTagListView.h"
#import "OMTagView.h"
#import "OMGFramework.h"

@interface OMTagListView ()

@property (nonatomic, assign) NSInteger tagsCount;

@end

///-----------------------------------------------------------------------------
///-----------------------------------------------------------------------------
///-----------------------------------------------------------------------------
@implementation OMTagListView

@synthesize tagsCount = _tagsCount;

///-----------------------------------------------------------------------------
#pragma mark -
#pragma mark Initialization
///-----------------------------------------------------------------------------

// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.tagsCount = 0;
    }
    return self;
}

// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (void)addTag:(OMTagView *)tagView {
    NSParameterAssert(tagView);
    
    tagView.tag = self.tagsCount++;
    
    // Start observing
    [tagView addObserver:self forKeyPath:@"selected" options:NSKeyValueObservingOptionNew context:nil];
    [tagView addObserver:self forKeyPath:@"highlighted" options:NSKeyValueObservingOptionNew context:nil];
    
    [self addSubview:tagView];
}

// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (void)removeTagAtIndex:(NSInteger)index {
    UIView * v = [self viewWithTag:index];
    if (nil == v) {
        return;
    }
    
    [v removeFromSuperview];
    self.tagsCount--;
    
    [self reaffectTags];
}

// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (void)reaffectTags {
    NSArray * subviews = [self subviews];
    NSArray * sortedTagSubviews = [subviews sortedArrayUsingComparator:^(id o1, id o2){
        return (((UIView *)o1).tag == ((UIView *)o2).tag) ?
        NSOrderedSame : (((UIView *)o1).tag > ((UIView *)o2).tag) ? NSOrderedDescending : NSOrderedAscending;
    }];
    
    NSInteger i = 0;
    for (UIView * v in sortedTagSubviews) {
        v.tag = i++;
    }
    
    NSAssert(i==self.tagsCount, @"We've lost one of our babies");
}

// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (void)willRemoveSubview:(UIView *)subview {
    
    // Stop observing
    [subview removeObserver:self forKeyPath:@"selected"];
    [subview removeObserver:self forKeyPath:@"highlighted"];
    
    // Inform parent
    [super willRemoveSubview:subview];
}


// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (context == nil) {
        if ([keyPath isEqualToString:@"selected"]) {
            
        } else if ([keyPath isEqualToString:@"highlighted"]) {
            
            UIView * v = (UIView *)object;
            NSLog(@"View with tag %i touched", [v tag]);
        }
        
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (void)layoutSubviews {
    [super layoutSubviews];
    NSInteger tagsCount = [self tagsCount];
    for (NSInteger i=0; i<tagsCount; i++) {
        UIView * v = [self viewWithTag:i];
        if (nil == v) {
            continue;
        }
        
        
    }
}

@end
