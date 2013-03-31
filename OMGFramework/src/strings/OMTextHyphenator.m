//
//  OMTextHyphenator.m
//  OMGFramework
//
//  Created by Samuel Grau on 2/28/13.
//  Copyright (c) 2013 Samuel Grau. All rights reserved.
//

/**
 * There is a proven algorithm for hyphenation, for TeX-documents by Liang,
 * called Liang's Algorithm.
 *
 * The original algorithm is described here: http://www.tug.org/docs/liang/
 *
 * A shorter explanation is given here:
 * http://xmlgraphics.apache.org/fop/0.95/hyphenation.html
 *
 * Patterns can be generated with a Unix tool called patgen:
 * http://linux.die.net/man/1/patgen
 *
 * But there are some patterns already created here:
 * http://www.ctan.org/tex-archive/language/hyphenation/
 *
 * Nevertheless the german word "Ofen" is not hyphenated as "O-fen" because
 * it is considered to look "ugly".
 *
 */

#import "OMTextHyphenator.h"

@implementation OMTextHyphenator

@end
