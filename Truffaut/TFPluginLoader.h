//
//  TFPluginLoader.h
//  Truffaut
//
//  Created by Yan Li on 4/16/16.
//  Copyright © 2016 Codezerker. All rights reserved.
//

#import "TFSlidesTemplate.h"

@interface TFPluginLoader : NSObject

+ (nonnull NSArray<id<TFSlidesTemplate>> *)loadSlidesTempatesWithSearchURL:(nonnull NSURL *)searchURL;

@end
