//
//  StatisticsViewController.swift
//
//  Created by Max Bronckers on 7/11/17.
//  Copyright © 2017 Harvard University. All rights reserved.
//

import UIKit

class StatisticsViewController: UIViewController {
    
    @IBOutlet weak var resetButton: UIButton!
    
    @IBOutlet weak var EmptyLabel: UILabel!
    
    @IBOutlet weak var BornLabel: UILabel!
    
    @IBOutlet weak var AliveLabel: UILabel!
    
    @IBOutlet weak var DeadLabel: UILabel!
    
    var emptyCells: Int = 0, deadCells: Int = 0, bornCells: Int = 0, aliveCells: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(engineNotification), name: NSNotification.Name(rawValue: Const.engineNotification), object: StandardEngine.engine)
        NotificationCenter.default.addObserver(self, selector: #selector(sizeNotification), name: NSNotification.Name(rawValue: Const.sizeNotification), object: StandardEngine.engine)
        updateValues()
        setLabels()
    }
    
    // MARK: - Notification Handlers
    
    func engineNotification() {
        updateValues()
        setLabels()
    }
    
    func sizeNotification() {
        resetCounts(sender: resetButton)
    }
    
    func removeListeners() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: Const.engineNotification), object: self)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: Const.sizeNotification), object: self)
    }
    
    // MARK: - Statistics Functions
    
    @IBAction func resetCounts(sender: UIButton) {
        countsToZero()
        updateValues()
        setLabels()
    }
    
    func countsToZero() {
        emptyCells = 0
        deadCells = 0
        bornCells = 0
        aliveCells = 0
    }
    
    func updateValues() {
        aliveCells += StandardEngine.engine.countCells(of: .alive).count
        deadCells += StandardEngine.engine.countCells(of: .died).count
        bornCells += StandardEngine.engine.countCells(of: .born).count
        emptyCells += StandardEngine.engine.countCells(of: .empty).count
    }
    
    func setLabels() {
        EmptyLabel.text = "Empty Cells: \(emptyCells)"
        AliveLabel.text = "Alive Cells: \(aliveCells)"
        BornLabel.text = "Born Cells: \(bornCells)"
        DeadLabel.text = "Dead Cells: \(deadCells)"
    }
    
}
