//
//  GoRewindProcessCommunicator.swift
//  ProcessCommunicator
//
//  Created by Konstantin Gonikman on 09.04.19.
//  Copyright © 2019 Konstantin Gonikman. All rights reserved.
//

import Foundation
import os.log

public class GoRewindProcessCommunicator {
    
    private static func infoPlist(plistUrl: URL) -> Dictionary<String, AnyObject>? {    
        guard FileManager.default.fileExists(atPath: plistUrl.path) else { return nil }
        
        if let pListData = FileManager.default.contents(atPath: plistUrl.path) {
            do {
                let pListObject = try PropertyListSerialization.propertyList(from: pListData, options:PropertyListSerialization.ReadOptions(), format:nil)
                
                guard let pListDict = pListObject as? Dictionary<String, AnyObject> else {
                    return nil
                }
                
                return pListDict
                
            } catch {
                print("Error reading regions plist file: \(error)")
                return nil
            }
        }
        
        return nil
    }
    
    public static func setupConnection(with plistUrl: URL, startAgent: Bool) {
        #if DEBUG
        GoRewindProcessConstants.serviceNamePrefix = "dev."
        #else        
        if let plist = infoPlist(plistUrl: plistUrl), let branch = plist["M37GitBranch"] as? String {
            GoRewindProcessConstants.serviceNamePrefix = branch + "."
        }
        #endif
        
        if startAgent {
            OEXPCCAgentConfiguration.defaultConfiguration(withName: GoRewindProcessConstants.serviceName())
        }
        
        OEXPCCAgent.defaultAgent(withServiceName: GoRewindProcessConstants.fullServiceName())
        
        os_log("SetupConnection. fullServiceName: %{public}@. Start agent? %{public}@", GoRewindProcessConstants.fullServiceName(), startAgent.description) 
    }
    
    
    public static func terminate() {
        OEXPCCAgentConfiguration.current()?.tearDownAgent()
    }
}
