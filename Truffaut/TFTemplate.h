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

NS_ASSUME_NONNULL_BEGIN

@protocol TFTemplate <NSObject>

- (NSString *)typeIdentifier;
- (NSViewController *)createPageViewControllerWithPageTitle:(NSString *)title
                                               bulletPoints:(nullable NSArray<NSString *> *)bulletPoints;

@end

NS_ASSUME_NONNULL_END

#endif /* TFSlidesTemplate_h */
