//
//  GridView.swift
//
//  Created by Max Bronckers on 7/6/17.
//  Copyright © 2017 Harvard University. All rights reserved.
//


import UIKit

@IBDesignable
class GridView: UIView {
    
    var delegate: GridViewDelegate?
    var dataSource: GridViewDataSource?
    var grid: Grid?
    
    var cellSizeCols: CGFloat {
        return self.frame.width / CGFloat(grid!.size.cols)
    }
    var cellSizeRows: CGFloat {
        return self.frame.height / CGFloat(grid!.size.rows)
    }
    
    @IBInspectable let aliveColor: UIColor = UIColor.green
    @IBInspectable let emptyColor: UIColor = UIColor.gray
    @IBInspectable let diedColor: UIColor = UIColor.gray.withAlphaComponent(CGFloat(0.6))
    @IBInspectable let bornColor: UIColor = UIColor.green.withAlphaComponent(CGFloat(0.6))
    @IBInspectable let gridColor: UIColor = UIColor.black
    
    @IBInspectable var gridWidth: CGFloat = 1.0
    
    override func draw(_ rect: CGRect) {
        drawGrid(rect)
    }
    
    // MARK: - Drawing Functions
    func drawGrid(_ rect: CGRect) {
        
        // Outer lines
        let edgePath = UIBezierPath()
        edgePath.lineWidth = gridWidth
        edgePath.move(to: rect.origin)
        edgePath.addLine(to: CGPoint(x: rect.origin.x, y: rect.height))
        edgePath.addLine(to: CGPoint(x: rect.width, y: rect.height))
        edgePath.addLine(to: CGPoint(x: rect.width, y: rect.origin.y))
        edgePath.addLine(to: CGPoint(x: rect.origin.x, y: rect.origin.y))
        gridColor.setStroke()
        edgePath.stroke()
        
        if let grid = grid {
            (1...grid.size.rows).forEach { row in
                let diffRows = rect.height/CGFloat(grid.size.rows)
                let diffCols = rect.width/CGFloat(grid.size.cols)
                let diffMin = min(diffRows, diffCols)
                let radius = CGFloat(diffMin/2.5)
                
                // Horizontal lines
                let relativeOriginY = CGPoint(x: rect.origin.x, y: rect.origin.y + (CGFloat(row) * diffRows))
                let linePathY = setLine(to: relativeOriginY)
                linePathY.addLine(to: CGPoint(x: rect.width, y: relativeOriginY.y))
                drawLine(linePathY)
                
                (1...grid.size.cols).forEach { col in
                    
                    // Vertical lines
                    let relativeOriginX = CGPoint(x: rect.origin.x + (CGFloat(col) * diffCols), y: rect.origin.y)
                    let linePathX = setLine(to: relativeOriginX)
                    linePathX.addLine(to: CGPoint(x: relativeOriginX.x, y: rect.height))
                    drawLine(linePathX)
                    
                    // Circles
                    let midPointX = CGPoint(x: relativeOriginX.x - (diffCols / 2), y: relativeOriginY.y - (diffRows / 2))
                    let color = stateColor(state: grid[row, col])
                    drawCircle(midPoint: midPointX, radius: radius, color: color)
                }
            }
        }
    }
    
    func setLine(to origin: CGPoint) -> UIBezierPath {
        let linePath = UIBezierPath()
        linePath.lineWidth = self.gridWidth
        linePath.move(to: origin)
        return linePath
    }
    
    func drawLine(_ line: UIBezierPath) {
        gridColor.setStroke()
        line.stroke()
    }
    
    func drawCircle(midPoint: CGPoint, radius: CGFloat, color: UIColor) {
        let circlePath = UIBezierPath(arcCenter: midPoint, radius: radius, startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true)
        color.setStroke()
        circlePath.stroke()
        color.withAlphaComponent(0.25).setFill()
        circlePath.fill()
    }
    
    // MARK: - Color Helper Function
    func stateColor(state: CellState) -> UIColor {
        switch state {
        case .alive: return aliveColor
        case .empty: return emptyColor
        case .died: return diedColor
        case .born: return bornColor
        }
    }
    
    // MARK: - Touch Handler
    var lastToggled = (row: -1, col: -1)
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let position = touches.first?.location(in: self) else { return }
        toggleCell(on: position)
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let position = touches.first?.location(in: self) else { return }
        if (Int(ceil(position.y / cellSizeRows)) != lastToggled.row || Int(ceil(position.x / cellSizeCols)) != lastToggled.col) {
            toggleCell(on: position)
        }
    }
    
    func toggleCell(on point: CGPoint) {
        lastToggled = (row: Int(ceil(point.y / cellSizeRows)), col: Int(ceil(point.x / cellSizeCols)))
        delegate?.toggle(row: lastToggled.row, col: lastToggled.col)
        update()
    }
    
    func update() {
        grid = dataSource?.grid
        self.setNeedsDisplay()
    }
}
 
