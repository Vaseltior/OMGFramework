//
//  OMCoreHeader.h
//  OMGFramework
//
//  Created by Samuel Grau on 10/20/12.
//  Copyright (c) 2012 Samuel Grau. All rights reserved.
//

#ifndef OMGFramework_OMCoreHeader_h
#define OMGFramework_OMCoreHeader_h

#import "OMObjectSingleton.h"

#define OM_LocStr(key) [[NSBundle mainBundle] localizedStringForKey:(key) value:@"" table:nil]
#define OM_RGB(r, g, b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define OM_RGBA(r, g, b, a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

#define OM_RGB_UNI(rgb) OM_RGB((rgb), (rgb), (rgb))
#define OM_RGBA_UNI(rgb, a) OM_RGBA((rgb), (rgb), (rgb), (a))

#define OM_UIViewWidthHeightResizing() (UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth)

#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0) \
\


#endif
