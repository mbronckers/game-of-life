//
//  InstrumentationViewController.swift
//
//  Created by Max Bronckers on 7/11/17.
//  Copyright © 2017 Harvard University. All rights reserved.
//

import UIKit

class InstrumentationViewController: UIViewController {
   
    @IBOutlet weak var refreshFrequency: UISlider!
    
    @IBOutlet weak var timedRefresh: UISwitch!
    
    @IBOutlet weak var timerLabel: UILabel!
    
    @IBOutlet weak var refreshRateLabel: UILabel!
    
    @IBOutlet weak var rowLabel: UILabel!
    
    @IBOutlet weak var colLabel: UILabel!
    
    @IBOutlet weak var rowStepper: UIStepper!
    
    @IBOutlet weak var colStepper: UIStepper!
    
    
    override func viewDidLoad() {
        NotificationCenter.default.addObserver(self, selector: #selector(engineNotification), name: NSNotification.Name(rawValue: Const.engineNotification), object: StandardEngine.engine)
        
        refreshRateLabel.text = "Refresh Frequency: \(String(format: "%.1f", refreshFrequency.value))"
        rowLabel.text = "Rows: \(StandardEngine.engine.rows)"
        colLabel.text = "Columns: \(StandardEngine.engine.cols)"
        timerLabel.text = timedRefresh.isOn ? "Timed Refresh: On" : "Timed Refresh: Off"
        
        rowStepper.value = Double(StandardEngine.engine.rows)
        colStepper.value = Double(StandardEngine.engine.cols)
        StandardEngine.engine.refreshRate = Double(refreshFrequency.value)
    }
    
}

extension InstrumentationViewController {
    
    func engineNotification() {
        rowLabel.text = "Rows: \(StandardEngine.engine.grid.size.rows)"
        colLabel.text = "Columns: \(StandardEngine.engine.grid.size.cols)"
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        if let text = Int(textField.text!) {
            StandardEngine.engine.changeColSize(to: text)
            StandardEngine.engine.changeRowSize(to: text)
            rowLabel.text = "Rows: \(text)"
            colLabel.text = "Cols: \(text)"
        } else {
            textField.text = "\(size)"
        }
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func switchToggled(sender: UISwitch) {
        StandardEngine.engine.toggleTimer()
        timerLabel.text = sender.isOn ? "Timed Refresh: On" : "Timed Refresh: Off"
    }
    
    @IBAction func frequencyChanged(sender: UISlider) {
        StandardEngine.engine.changeRefreshRate(to: Double(sender.value))
        refreshRateLabel.text = "Refresh Frequency: \(String(format: "%.1f", sender.value))"
    }
    
    @IBAction func rowChanged(sender: UIStepper) {
        StandardEngine.engine.changeRowSize(to: Int(sender.value))
        rowLabel.text = "Rows: \(Int(sender.value))"
    }
    
    @IBAction func colChanged(sender: UIStepper) {
        StandardEngine.engine.changeColSize(to: Int(sender.value))
        colLabel.text = "Cols: \(Int(sender.value))"
    }
    
    @IBAction func addConfigurations(sender: UIBarButtonItem) {
        let viewControllers = self.childViewControllers
        if let vc = viewControllers[0] as? ConfigurationsViewController {
            vc.add()
        }
    }
    
}



