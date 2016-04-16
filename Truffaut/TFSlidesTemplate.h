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

@protocol TFSlidesPageViewController;

@protocol TFSlidesTemplate <NSObject>

@property (nonatomic, nonnull, readonly) NSString *typeIdentifier;

- (nonnull NSViewController<TFSlidesPageViewController> *)createPageViewControllerWithTitle:(nonnull NSString *)title
                                                                               bulletPoints:(nonnull NSArray<NSString *> *)bulletPoints;

@end


@protocol TFSlidesPageViewController <NSObject>

@property (nonatomic, nonnull, readonly) NSString *typeIdentifier;
@property (nonatomic, nonnull, readonly) NSString *title;
@property (nonatomic, nonnull, readonly) NSArray<NSString *> *bulletPoints;

@end

#endif /* TFSlidesTemplate_h */
