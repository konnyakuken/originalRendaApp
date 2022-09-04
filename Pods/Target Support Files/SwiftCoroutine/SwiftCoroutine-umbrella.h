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

#import "CCoroutine.h"
#import "SwiftCoroutine.h"

FOUNDATION_EXPORT double SwiftCoroutineVersionNumber;
FOUNDATION_EXPORT const unsigned char SwiftCoroutineVersionString[];

