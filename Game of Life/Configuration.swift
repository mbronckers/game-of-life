//
//  Configuration.swift
//  FinalProject
//
//  Created by Max Bronckers on 7/25/17.
//  Copyright © 2017 Harvard University. All rights reserved.
//

import Foundation

struct Configuration {
    var name: String
    var contents: [[Int]]
    var grid: Grid?
    
    init(name: String, contents: [[Int]]) {
        self.name = name
        self.contents = contents
        
        let maxValue = contents.flatMap{ $0 }.reduce(0) {
            ($0 > $1) ? $0 : $1
        }
        
        self.grid = Grid(maxValue, maxValue)
        contents.forEach { position in self.grid![position[0], position[1]] = self.grid![position[0], position[1]].toggle(value: .empty) }
    }
    
    mutating func reset() {
        self.name = "New Configuration"
        self.contents = [[]]
        self.grid = Grid(10, 10)
    }
    
}

extension Configuration: CustomStringConvertible {
    var description: String {
        return name
    }
}

extension Configuration {
    
    init?(json: [String: Any]) {
        
        guard let name = json[Const.JSON.nameKey] as? String else {
            print("Error reading in the name of the configuration")
            return nil
        }
        
        guard let contents = json[Const.JSON.gridKey] as? [[Int]] else {
            print("Error reading in the content of the configuration")
            return nil
        }
            
        self.init(name: name, contents: contents)
    }
    
    static func configurations(from json: Any?) -> [Configuration]? {
        guard let jsonList = json as? Array<Dictionary<String,Any>> else {
                print("JSON unexpected: \(String(describing: json))")
                return nil
        }
        
        var tmpConfig = [Configuration]()
        jsonList.forEach {
            if let config = Configuration(json: $0) {
                tmpConfig.append(config)
            }
        }
        
        if tmpConfig.count == 0 {
            print("Configurations didn't convert")
            return nil
        }
        return tmpConfig
    }
    
    static func configurations(from data: Data) -> [Configuration]? {
        let jsonObject: Any
        do {
            jsonObject = try JSONSerialization.jsonObject(with: data,
                                                          options: .allowFragments)
        } catch {
            print("JSON Parsing failure: \(error)")
            return nil
        }
        
        return configurations(from: jsonObject)
    }
    
    static func configurations(from file: String = Const.file.configuration.name) -> [Configuration]? {
        guard let jsonPath = Bundle.main.path(forResource: file,
                                              ofType: Const.file.configuration.ext)
            else {
                print("File not present: \(file)")
                return nil
        }
        let jsonURL = URL(fileURLWithPath: jsonPath)
        // Error handling
        let jsonData: Data
        do {
            jsonData = try Data(contentsOf: jsonURL)
        } catch {
            print("JSON Data failure: \(error)")
            return nil
        }
        return configurations(from: jsonData)
    }

}

