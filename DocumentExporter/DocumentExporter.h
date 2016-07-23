//
//  DocumentExporter.h
//  DocumentExporter
//
//  Created by Yan Li on 23/07/2016.
//  Copyright © 2016 Codezerker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DocumentExporterProtocol.h"

// This object implements the protocol which we have defined. It provides the actual behavior for the service. It is 'exported' by the service to make it available to the process hosting the service over an NSXPCConnection.
@interface DocumentExporter : NSObject <DocumentExporterProtocol>
@end
