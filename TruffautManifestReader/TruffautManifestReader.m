//
//  TruffautManifestReader.m
//  TruffautManifestReader
//
//  Created by Yan Li on 4/3/17.
//  Copyright © 2017 Codezerker. All rights reserved.
//

#import "TruffautManifestReader.h"
#import "TruffautManifestReader-Swift.h"

@implementation TruffautManifestReader

- (BOOL)readManifestFileAtURL:(NSURL *)url withReply:(void (^)(JSONDictionary *))reply error:(InOutErrorPtr)error {
    NSString *cmd = @"/usr/bin/swiftc";
    NSArray<NSString *> *args = @[]; // FIXME: args
    NSString *jsonString = [Shell callWithCommand:cmd arguments:args currentDirectoryPath:nil error:error];
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    JSONDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:error];
    reply(jsonDictionary);
    return jsonDictionary != nil;
}

@end
