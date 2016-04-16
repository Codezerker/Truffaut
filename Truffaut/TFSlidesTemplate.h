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

+ (nonnull NSViewController<TFSlidesPageViewController> *)pageViewControllerFromTemplateWithTitle:(nonnull NSString *)title
                                                                                     bulletPoints:(nonnull NSArray<NSString *> *)bulletPoints;

@end


@protocol TFSlidesPageViewController <NSObject>

@property (nonatomic, nonnull, copy, readonly) NSString *title;
@property (nonatomic, nonnull, copy, readonly) NSArray<NSString *> *bulletPoints;

@end

#endif /* TFSlidesTemplate_h */
