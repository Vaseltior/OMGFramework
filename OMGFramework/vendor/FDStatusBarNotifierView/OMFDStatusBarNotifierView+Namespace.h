//
//  OMGFramework
//
//  Created by Samuel Grau on 10/27/12.
//  Copyright (c) 2012 Samuel Grau. All rights reserved.
//

#ifndef __OMG_NAMESPACE_PREFIX_
    #error You must define __OMG_NAMESPACE_PREFIX_ in your project settings in order to use a OMG namespace.
#else

#ifndef __OMG_NS_SYMBOL
    // We need to have multiple levels of macros here so that __OMG_NAMESPACE_PREFIX_ is
    // properly replaced by the time we concatenate the namespace prefix.
    #define __OMG_NS_REWRITE(ns, symbol) ns ## _ ## symbol
    #define __OMG_NS_BRIDGE(ns, symbol) __OMG_NS_REWRITE(ns, symbol)
    #define __OMG_NS_SYMBOL(symbol) __OMG_NS_BRIDGE(__OMG_NAMESPACE_PREFIX_, symbol)
#endif

// Classes
#ifndef FDStatusBarNotifierView
    #define FDStatusBarNotifierView __OMG_NS_SYMBOL(FDStatusBarNotifierView)
#endif

#endif
