//
//  GoRewindRunningProcess.swift
//  ProcessCommunicator
//
//  Created by Konstantin Gonikman on 11.04.19.
//  Copyright © 2019 Konstantin Gonikman. All rights reserved.
//

import Foundation
import os.log

public class GoRewindRunningProcess<S: GoRewindProcessProtocol> {
    public var service: S?
    public var onConnect: ((_ contextIdentifier: ContextIdentifier) -> ())?
    public var onHandshake: (() -> ())?
    public var onInterrupt: (() -> ())?
    public var onInvalidate: (() -> ())?
    
    private var processConnection: NSXPCConnection?
    private let remoteContextIdentifier: ContextIdentifier
    private let localProtocol: Protocol
    private let remoteProtocol: Protocol
    private var handler: GoRewindProcessProtocol
    private var connectionIdentifier: String
    
    public init?(localProtocol: Protocol, remoteProtocol: Protocol, handler: GoRewindProcessProtocol, remoteContextIdentifier: ContextIdentifier, connectionIdentifier: String = UUID().uuidString) {
        self.remoteContextIdentifier = remoteContextIdentifier
        self.remoteProtocol = remoteProtocol
        self.localProtocol = localProtocol
        self.handler = handler
        self.connectionIdentifier = connectionIdentifier
    }
    
    public func connect() {
        os_log("Connecting to GoRewindRunningProcess. fullServiceName: %{public}@. Via: %{public}@", 
               log: OSLog.xpc, 
               type: .info, 
               GoRewindProcessConstants.fullServiceName(), remoteContextIdentifier) 
        
        OEXPCCAgent.defaultAgent(withServiceName: GoRewindProcessConstants.fullServiceName())?.retrieveListenerEndpoint(forIdentifier: self.remoteContextIdentifier, completionHandler: { [weak self] endpoint in
            guard let self = self, 
                let theEndpoint = endpoint else {
                    print("Endpoint `\(endpoint.debugDescription)` is not available.")
                    return
            }
            
            self.onConnect?(self.remoteContextIdentifier)
            
            self.processConnection = NSXPCConnection(listenerEndpoint: theEndpoint)
            self.processConnection?.remoteObjectInterface = NSXPCInterface(with: self.remoteProtocol)
            self.processConnection?.exportedObject = self.handler
            self.processConnection?.exportedInterface = NSXPCInterface(with: self.localProtocol)
            self.processConnection?.interruptionHandler = self.onInterrupt
            self.processConnection?.invalidationHandler = self.onInvalidate
            self.processConnection?.resume()
            
            self.service = self.processConnection?.remoteObjectProxyWithErrorHandler { error in
                print("Remote process error:", error)
                } as? S
            
            self.service?.handshake(connectionIdentifier: self.connectionIdentifier) {
                self.onHandshake?()
            }
        })
    }
}
