//
//  StandardEngine.swift
//
//  Created by Max Bronckers on 7/11/17.
//  Copyright © 2017 Harvard University. All rights reserved.
//

import Foundation

class StandardEngine: EngineProtocol {
   
    var delegate: EngineDelegate?
    var refreshRate: Double = 0.0
    var refreshTimer: Timer?
    var rows: Int
    var cols: Int
    
    var grid: GridProtocol = Grid(10,10) {
        didSet {
            delegate?.engineDidUpdate(engine: self)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: Const.engineNotification), object: self)
        }
    }
    
    required init(rows: Int, cols: Int) {
        self.rows = rows
        self.cols = cols
    }
    
    static var engine: StandardEngine = {
        let tmpEngine = StandardEngine(rows: 10, cols: 10)
        tmpEngine.grid = Grid(10, 10)
        return tmpEngine
    }()
    
// MARK: - Timer Functions
    
    func startTimer() {
        let timerSelector = #selector(timerTriggered(timer:))
        refreshTimer = Timer.scheduledTimer(timeInterval: refreshRate, target: self, selector: timerSelector, userInfo: nil, repeats: true)
    }
    
    @objc func timerTriggered(timer: Timer) {
        refreshTimer = timer
        grid = step()
    }
    
    func stopTimer() {
        refreshTimer?.invalidate()
        refreshTimer = nil
    }
    
    func toggleTimer() {
        if let _ = refreshTimer {
            stopTimer()
        } else {
            startTimer()
        }
    }
// MARK: - Instrumentation Functions
    
    func changeRefreshRate(to value: Double) {
        refreshRate = value
        if let _ = refreshTimer {
            stopTimer()
            startTimer()
        }
    }
    
    func changeRowSize(to value: Int) {
        rows = value
        grid = Grid(rows, cols)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: Const.sizeNotification), object: self)
    }
    
    func changeColSize(to value: Int) {
        cols = value
        grid = Grid(rows, cols)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: Const.sizeNotification), object: self)
    }
    
    func resetGrid() {
        grid = Grid(rows, cols)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: Const.sizeNotification), object: self)
    }
    
    func saveGrid(grid: Grid?) {
        self.grid = grid!
        rows = grid!.size.rows
        cols = grid!.size.cols
    }
    
    let lazyPositions = { (size: GridSize) in
        return (0 ..< size.rows)
            .lazy
            .map { zip( [Int](repeating: $0, count: size.cols) , 0 ..< size.cols ) }
            .flatMap { $0 }
            .map { GridPosition($0) }
    }

// Mark: - Statistics Functions
        
    func countCells(of state: CellState) -> [GridPosition] {
        return lazyPositions(grid.size).filter { return  grid[$0.row, $0.col] == state }
    }

// MARK: - Grid Functions
    
    func step() -> GridProtocol {
        return grid.next()
    }
}
