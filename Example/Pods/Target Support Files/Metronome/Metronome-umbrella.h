#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "MTRMetronome.h"
#import "MTRMetronomeButton.h"
#import "MTRMetronomeViewController.h"

FOUNDATION_EXPORT double MetronomeVersionNumber;
FOUNDATION_EXPORT const unsigned char MetronomeVersionString[];

