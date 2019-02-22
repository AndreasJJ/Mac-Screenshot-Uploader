//
//  Config.swift
//  Screenshot-upload-tool
//
//  Created by Andreas Jensen Jonassen on 18.02.2019.
//  Copyright © 2019 Andreas Jensen Jonassen. All rights reserved.
//

import Foundation
import CoreData

class Config: NSObject {
    let defaults = UserDefaults.standard
    var appConfig = [AppConfig]()
    
    public override init() {
        let fetchrequest: NSFetchRequest<AppConfig> = AppConfig.fetchRequest()
        
        do {
            let appConfig = try PersistenceService.context.fetch(fetchrequest)
            if(appConfig.count == 0) {
                let _appConfig = AppConfig(context: PersistenceService.context)
                _appConfig.imageType = "png"
                _appConfig.saveFolder = NSHomeDirectory() + "/Desktop/"
                _appConfig.defaultServerConfig = ServerConfig(context: PersistenceService.context)
                var url = URLComponents()
                url.scheme = "http"
                url.host = "localhost"
                url.path = "/upload"
                url.port = 5000
                //_appConfig.defaultServerConfig!.uploadUrl = URL(fileURLWithPath: "localhost")
                _appConfig.defaultServerConfig!.uploadUrl = url.url!
                //_appConfig.defaultServerConfig!.arguments = [String : String]()
                _appConfig.defaultServerConfig!.arguments = ["username" : "andreas", "password" : "super-secret"]
                _appConfig.defaultServerConfig!.fileFormName = "file"
                var _appConfigArr = [AppConfig]()
                _appConfigArr.append(_appConfig)
                self.appConfig = _appConfigArr
            } else {
                self.appConfig = appConfig
            }
        } catch {
            print("Oh no!")
        }
    }
    
    public func setNoiseOption(quite: Bool) {
        appConfig[0].noise = quite
    }
    
    public func setImageType(type: String) {
        appConfig[0].imageType = type
    }
    
    public func setSaveFolderLocation(location: String) {
        appConfig[0].saveFolder = location
    }
    
    public func setDefaultServerConfig(ServerConfig: ServerConfig) {
        appConfig[0].defaultServerConfig = ServerConfig
    }
    
    public func getNoiseOption() -> Bool {
        return appConfig[0].noise
    }
    
    public func getImageType() -> String {
        return appConfig[0].imageType ?? "png"
    }
    
    public func getSaveFolderLocation() -> String {
        return appConfig[0].saveFolder ?? NSHomeDirectory() + "/Desktop/"
    }
    
    public func getDefaultUploadURL() -> URL {
        return appConfig[0].defaultServerConfig?.uploadUrl ?? URL(fileURLWithPath: "https://localhost")
    }
    
    public func getDefaultArguments() -> [String : String] {
        return appConfig[0].defaultServerConfig?.arguments ?? [String : String]()
    }
    
    public func getDefaultFileFormName() -> String {
        return appConfig[0].defaultServerConfig?.fileFormName ?? "file"
    }
}

