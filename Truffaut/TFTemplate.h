//
//  TFSlidesTemplate.h
//  Truffaut
//
//  Created by Yan Li on 4/16/16.
//  Copyright © 2016 Codezerker. All rights reserved.
//

#ifndef TFSlidesTemplate_h
#define TFSlidesTemplate_h

#import <AppKit/AppKit.h>

@protocol TFTemplate <NSObject>

- (nonnull NSString *)typeIdentifier;
- (nonnull NSViewController *)createPageViewControllerWithPageTitle:(nonnull NSString *)title
                                                       bulletPoints:(nullable NSArray<NSString *> *)bulletPoints;

@end

#endif /* TFSlidesTemplate_h */
