//
//  TFPluginLoader.h
//  Truffaut
//
//  Created by Yan Li on 4/16/16.
//  Copyright © 2016 Codezerker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TFTemplate.h"

NS_ASSUME_NONNULL_BEGIN

@interface TFPlugInLoader : NSObject

+ (NSDictionary<NSString *, id<TFTemplate>> *)loadSlidesTempatesWithSearchURL:(NSURL *)searchURL;

@end

NS_ASSUME_NONNULL_END
