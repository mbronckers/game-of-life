//
//  EngineProtocol.swift
//
//  Created by Max Bronckers on 7/11/17.
//  Copyright © 2017 Harvard University. All rights reserved.
//

import Foundation

protocol EngineProtocol {
    var delegate: EngineDelegate? { get set }
   
    var grid: GridProtocol { get }
    
    var refreshRate: Double { get set }
    var refreshTimer: Timer? { get set }
   
    var rows: Int { get set }
    var cols: Int { get set }
    
    init(rows: Int, cols: Int)
    
    func step() -> GridProtocol
}

extension EngineProtocol {
    var refreshRate: Double {
        return 0.0
    }
}

protocol EngineDelegate {
    func engineDidUpdate(engine: EngineProtocol)
}

protocol GridViewDelegate {
    func toggle(row: Int, col: Int)
}

protocol GridViewDataSource {
    var grid: Grid? { get set }
}

struct Const {
    static let engineNotification = "engineDidUpdateNotification"
    static let sizeNotification = "sizeDidUpdateNotification"
    
    static let configurationCellDescription = "ConfigurationCell"

    struct file {
        static let configuration = (name: "configuration",
                            ext: "json",
                            url: "https://dl.dropboxusercontent.com/u/7544475/S65g.json?dl=1")
    }
    struct JSON {
        static let nameKey = "title"
        static let gridKey = "contents"
    }
}
