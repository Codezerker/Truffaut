//
//  TFPluginLoader.h
//  Truffaut
//
//  Created by Yan Li on 4/16/16.
//  Copyright © 2016 Codezerker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TFTemplate.h"

@interface TFPlugInLoader : NSObject

+ (nonnull NSDictionary<NSString *, id<TFTemplate>> *)loadSlidesTempatesWithSearchURL:(nonnull NSURL *)searchURL;

@end
