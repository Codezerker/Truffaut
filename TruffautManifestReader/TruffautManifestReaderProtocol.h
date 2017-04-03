//
//  TruffautManifestReaderProtocol.h
//  TruffautManifestReader
//
//  Created by Yan Li on 4/3/17.
//  Copyright © 2017 Codezerker. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol TruffautManifestReaderProtocol

- (void)readManifestFileAtURL:(NSURL *)url withReply:(void (^)(NSDictionary<NSString *, id> *))reply;

@end

NS_ASSUME_NONNULL_END
