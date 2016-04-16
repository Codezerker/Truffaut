//
//  TFPluginLoader.h
//  Truffaut
//
//  Created by Yan Li on 4/16/16.
//  Copyright © 2016 Codezerker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TFSlidesTemplate.h"

@interface TFPlugInLoader : NSObject

+ (nonnull NSDictionary<NSString *, id<TFSlidesTemplate>> *)loadSlidesTempatesWithSearchURL:(nonnull NSURL *)searchURL;

@end
