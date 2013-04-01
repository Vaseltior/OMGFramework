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
    
    tagView.tag = ++self.tagsCount;
    
    // Start observing
    [tagView addObserver:self forKeyPath:@"selected" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld|NSKeyValueObservingOptionPrior context:nil];
    [tagView addObserver:self forKeyPath:@"highlighted" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld|NSKeyValueObservingOptionPrior context:nil];
    
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
    
    NSInteger i = 1;
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
            NSNumber * isPriorNumber = (NSNumber *)[change objectForKey:NSKeyValueChangeNotificationIsPriorKey];
            if (nil == isPriorNumber) {
                BOOL newValue = [(NSNumber*)[change objectForKey:NSKeyValueChangeNewKey] boolValue];
                BOOL oldValue = [(NSNumber*)[change objectForKey:NSKeyValueChangeOldKey] boolValue];
                if (newValue && (newValue != oldValue)) {
                    UIView * v = (UIView *)object;
                    NSLog(@"View with tag %i touched", [v tag]);
                }
            }
        }
        
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (void)layoutSubviews {
    [super layoutSubviews];
    NSInteger tagsCount = [self tagsCount];
    
    CGFloat hPadding = 6.0f;
    CGFloat vPadding = 6.0f;
    CGFloat lineSpace = CGRectGetWidth(self.bounds) - 2.0f * hPadding;
    CGFloat remainingSpace = lineSpace;
    CGFloat xOffset = hPadding;
    CGFloat yOffset = vPadding;
    
    for (NSInteger i=1; i<=tagsCount; i++) {
        UIView * v = [self viewWithTag:i];
        if ((nil == v) || ![v isKindOfClass:[OMTagView class]]) {
            continue;
        }
        OMTagView * tv = (OMTagView *)v;
        CGSize tagSize = [tv sizeThatFits:self.bounds.size];
        
        // if new tag will fit on screen, in row:
        //   - place it
        if (tagSize.width <= remainingSpace) {
            tv.frame = CGRectMake(xOffset, yOffset, tagSize.width, tagSize.height);
            remainingSpace -= tagSize.width + hPadding;
            xOffset += tagSize.width + hPadding;
            
        }
        // else:
        //   - put on next row at beginning
        else {
            
            // Go to next line
            yOffset += tagSize.height + vPadding;
            
            // Reset horizontal
            xOffset = hPadding;
            remainingSpace = lineSpace;
            
            tv.frame = CGRectMake(xOffset, yOffset, tagSize.width, tagSize.height);
            remainingSpace -= tagSize.width + hPadding;
            xOffset += tagSize.width + hPadding;
        }
    }
}

@end
