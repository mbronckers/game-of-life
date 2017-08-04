//
//  SimulationViewController.swift
//
//  Created by Max Bronckers on 7/11/17.
//  Copyright © 2017 Harvard University. All rights reserved.
//

import UIKit

class SimulationViewController: UIViewController, EngineDelegate, GridViewDataSource, GridViewDelegate {
    
    var grid: Grid?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        grid = StandardEngine.engine.grid as? Grid
        StandardEngine.engine.delegate = self
        inspectableGrid.dataSource = self
        inspectableGrid.delegate = self
        inspectableGrid.grid = self.grid
    }

    @IBOutlet weak var inspectableGrid: GridView!
    
    func toggle(row: Int, col: Int) {
        StandardEngine.engine.grid[row, col] = StandardEngine.engine.grid[row, col].toggle(value: StandardEngine.engine.grid[row, col])
    }
    
    func engineDidUpdate(engine: EngineProtocol) {
        self.grid = StandardEngine.engine.grid as? Grid
        inspectableGrid.update()
    }
    
    @IBAction func resetGrid() {
        StandardEngine.engine.resetGrid()
        inspectableGrid.update()
    }
    
    @IBAction func stepGrid() {
        StandardEngine.engine.grid = StandardEngine.engine.step()
        inspectableGrid.update()
    }
    
}
