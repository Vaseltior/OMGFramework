//
//  OMTagView.m
//  OMGFramework
//
//  Created by Samuel Grau on 10/5/12.
//  Copyright (c) 2012 Samuel Grau. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <objc/message.h>

#import "OMTagView.h"
#import "OMGFramework.h"

@interface OMTagView ()
@property (nonatomic, strong) UILabel *label;
@end

@implementation OMTagView

@synthesize label = _label;
@synthesize font = _font;

///-----------------------------------------------------------------------------
#pragma mark -
#pragma mark Initialization
///-----------------------------------------------------------------------------

// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self omRegisterKeyPathsForKVO];
        
        [self addObserver:self forKeyPath:@"font" options:NSKeyValueObservingOptionNew context:nil];
        [self addObserver:self forKeyPath:@"highlighted" options:NSKeyValueObservingOptionNew context:nil];
        
        self.font = [UIFont systemFontOfSize:14.0f];
        
        UILabel * l = [[UILabel alloc] initWithFrame:CGRectZero];
        l.font = [self font];
        l.backgroundColor = [UIColor clearColor];
        l.textColor = [UIColor whiteColor];
        l.shadowColor = OM_RGBA_UNI(0, 0.3f);
        l.shadowOffset = CGSizeMake(0, -1);
        l.textAlignment = NSTextAlignmentCenter;
        l.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        self.label = l;
        
        [self addSubview:[self label]];
        
        [self setSelected:NO];
    }
    return self;
}

///-----------------------------------------------------------------------------
#pragma mark -
#pragma mark Memory management
///-----------------------------------------------------------------------------


// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (void)dealloc {
    [self omUnregisterKeyPathsFromKVO];
    
#if ! __has_feature(objc_arc)
#error "ARC is off"
#endif
    
    // [super dealloc]; << provided by the compiler
}


///-----------------------------------------------------------------------------
#pragma mark -
#pragma mark Observations
///-----------------------------------------------------------------------------

// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (context == nil) {
        if (object == self) {
            [self performUpdateForKeyPath:keyPath withObject:[change objectForKey:NSKeyValueChangeNewKey]];
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (NSArray *)omObservableKeyPaths {
    return @[@"font", @"highlighted", @"selected"];
}

///-----------------------------------------------------------------------------
#pragma mark -
#pragma mark Layout
///-----------------------------------------------------------------------------


// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (void)layoutSubviews {
    [super layoutSubviews];
    self.label.frame = self.bounds;
    //self.label.frame = CGRectOffset(self.label.frame, 0, -2.0f);
    
    CGFloat cornerRadius = CGRectGetHeight(self.bounds)/2.0f;
    self.layer.cornerRadius = cornerRadius;
    self.layer.borderWidth = 2.0f;
    self.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.layer.masksToBounds = NO;
    self.clipsToBounds = NO;
    self.layer.shadowColor = OM_RGBA_UNI(0, 1.0f).CGColor;
    self.layer.shadowOffset = CGSizeMake(0, 1);
    self.layer.shadowRadius = 1.0f;
    self.layer.shadowOpacity = 0.7f;
    self.layer.shadowPath = [[UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:cornerRadius] CGPath];
    //self.layer.shouldRasterize = YES;
}


///-----------------------------------------------------------------------------
#pragma mark -
#pragma mark Public
///-----------------------------------------------------------------------------

// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (void)setText:(NSString *)text {
    self.label.text = text;
}

// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (NSString *)text {
    return [[self label] text];
}

///-----------------------------------------------------------------------------
#pragma mark -
#pragma mark Data updates
///-----------------------------------------------------------------------------


// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
/*- (void)performUpdateForKeyPath:(NSString *)keyPath withObject:(id)object {
 Class class = [object class];
 while (class && class != [NSObject class]) {
 NSString *methodName = [NSString stringWithFormat:@"perform%@Tasks:", class];
 SEL selector = NSSelectorFromString(methodName);
 if ([self respondsToSelector:selector]) {
 objc_msgSend(self, selector, object);
 return;
 }
 class = [class superclass];
 }
 [NSException raiseGenericException:@"Visitor %@ doesn't have a performTasks method for %@", [self class], [object class]];
 }*/

// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (void)performUpdateForKeyPath:(NSString *)keyPath withObject:(id)object {
    
    // Building the method name following the pattern
    NSString *methodName = [NSString stringWithFormat:@"performUpdateForKeyPath%@WithNewValue:", [keyPath capitalizedString]];
    SEL selector = NSSelectorFromString(methodName);
    if ([self respondsToSelector:selector]) {
        objc_msgSend(self, selector, object);
        return;
    }
    
    // Raising the error
    [NSException raiseGenericException:@"Visitor %@ doesn't have a performUpdateForKeyPath%@WithNewValue method for %@",
     [self class],
     keyPath,
     [object class]];
}

// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (void)performUpdateForKeyPathFontWithNewValue:(UIFont *)value {
    UIFont * newValue = value;
    self.label.font = newValue;
}

// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (void)performUpdateForKeyPathHighlightedWithNewValue:(id)value {
    BOOL newValue = [value boolValue];
    self.backgroundColor = newValue ? OM_RGB(245,169,117): OM_RGB(189,103,112);
}

// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (void)performUpdateForKeyPathSelectedWithNewValue:(id)value {
    BOOL newValue = [value boolValue];
    self.backgroundColor = newValue ? [UIColor yellowColor] : OM_RGB(189,103,112);
}


///-----------------------------------------------------------------------------
#pragma mark -
#pragma mark Static methods
///-----------------------------------------------------------------------------

// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ (CGSize)sizeOfButtonWithString:(NSString *)string font:(UIFont *)font {
    return [string sizeWithFont:font constrainedToSize:CGSizeMake(MAXFLOAT, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
}

// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (CGSize)sizeThatFits:(CGSize)size {
    // Find the size of the button, turn it into a rect
    NSString *text = [self text];
    UIFont *font = [self font];
    
    CGFloat vPadding = 3.0f;
    
    CGSize bSize = [OMTagView sizeOfButtonWithString:text font:font];
    
    return CGSizeMake(bSize.height + bSize.width, bSize.height + 2.0f*vPadding);
}

@end
