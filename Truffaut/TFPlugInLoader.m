//
//  TFPluginLoader.m
//  Truffaut
//
//  Created by Yan Li on 4/16/16.
//  Copyright © 2016 Codezerker. All rights reserved.
//

#import "TFPlugInLoader.h"

@implementation TFPlugInLoader

+ (NSDictionary<NSString *, id<TFTemplate>> *)loadSlidesTempatesWithSearchURL:(NSURL *)searchURL {
  NSDirectoryEnumerationOptions options = NSDirectoryEnumerationSkipsPackageDescendants |
                                          NSDirectoryEnumerationSkipsHiddenFiles |
                                          NSDirectoryEnumerationSkipsSubdirectoryDescendants;
  
  NSDirectoryEnumerator *enumerator = [[NSFileManager defaultManager] enumeratorAtURL:searchURL
                                                           includingPropertiesForKeys:nil
                                                                              options:options
                                                                         errorHandler:nil];
  
  NSMutableDictionary<NSString *, id<TFTemplate>> *results = [NSMutableDictionary dictionary];
  
  NSURL *bundleURL = nil;
  while ((bundleURL = enumerator.nextObject)) {
    NSBundle *bundle = [NSBundle bundleWithURL:bundleURL];
    if ([bundle.principalClass conformsToProtocol:@protocol(TFTemplate)]) {
      id<TFTemplate> template = [bundle.principalClass new];
      results[template.typeIdentifier] = template;
    }
  }
  
  return results;
}

@end
