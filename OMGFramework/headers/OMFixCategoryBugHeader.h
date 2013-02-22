//
//  OMFixCategoryBugHeader.h
//  OMGFramework
//
//  Created by Samuel Grau on 10/7/12.
//  Copyright (c) 2012 Samuel Grau. All rights reserved.
//

#ifndef OMGFramework_OMFixCategoryBugHeader_h
#define OMGFramework_OMFixCategoryBugHeader_h

/*
 Add this macro before each category implementation, so we don't have to use
 -all_load or -force_load to load object files from static libraries that only contain
 categories and no classes.
 See http://developer.apple.com/library/mac/#qa/qa2006/qa1490.html for more info.
 
 Shamelessly borrowed from Three20
 */
#define OM_FIX_CATEGORY_BUG(name) @interface OM_FIX_CATEGORY_BUG##name @end \
@implementation OM_FIX_CATEGORY_BUG##name @end


#endif
