/*
 Copyright (c) 2013, OpenEmu Team

 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:
     * Redistributions of source code must retain the above copyright
       notice, this list of conditions and the following disclaimer.
     * Redistributions in binary form must reproduce the above copyright
       notice, this list of conditions and the following disclaimer in the
       documentation and/or other materials provided with the distribution.
     * Neither the name of the OpenEmu Team nor the
       names of its contributors may be used to endorse or promote products
       derived from this software without specific prior written permission.

 THIS SOFTWARE IS PROVIDED BY OpenEmu Team ''AS IS'' AND ANY
 EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL OpenEmu Team BE LIABLE FOR ANY
 DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import <Foundation/Foundation.h>

@interface OEXPCCAgent : NSObject

+ (BOOL)canParseProcessArgumentsForDefaultAgent;

// Get the agent based on the process arguments or the +[OEXPCCAgentConfiguration sharedConfiguration] if set up.
+ (OEXPCCAgent *)defaultAgentWithServiceName:(nullable NSString *)name;

// Extract the process identifier from the arguments, returns nil if it can't be found.
+ (NSString *)defaultProcessIdentifier;

- (id)initWithServiceName:(NSString *)serviceName;

@property(readonly) NSString *serviceName;

- (void)retrieveClientPidForIdentifier:(nonnull NSString *)identifier completionHandler:(void(^)(int pid))handler;
- (void)retrieveListenerPidForIdentifier:(nonnull NSString *)identifier completionHandler:(void(^)(int pid))handler;
- (void)registerListenerEndpoint:(NSXPCListenerEndpoint *)endpoint ownPid:(int)pid forIdentifier:(NSString *)identifier completionHandler:(void(^)(BOOL success))handler;
- (void)retrieveListenerEndpointForIdentifier:(NSString *)identifier ownPid:(int)pid completionHandler:(void(^)(NSXPCListenerEndpoint *endpoint))handler;

@end
