//
//  DocumentExporter.m
//  DocumentExporter
//
//  Created by Yan Li on 23/07/2016.
//  Copyright © 2016 Codezerker. All rights reserved.
//

#import "DocumentExporter.h"

@implementation DocumentExporter

// This implements the example protocol. Replace the body of this class with the implementation of this service's protocol.
- (void)upperCaseString:(NSString *)aString withReply:(void (^)(NSString *))reply {
    NSString *response = [aString uppercaseString];
    reply(response);
}

@end
