//
//  EditorViewController.swift
//  FinalProject
//
//  Created by Max Bronckers on 7/23/17.
//  Copyright © 2017 Harvard University. All rights reserved.
//

import UIKit

class EditorViewController: UIViewController, GridViewDelegate, GridViewDataSource {

    var completion: ((Configuration) -> Void)?
    var configuration: Configuration?
    var grid: Grid?
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var gridEditor: GridView!
    
    func toggle(row: Int, col: Int) {
        configuration!.grid![row, col] = configuration!.grid![row, col].toggle(value: configuration!.grid![row, col])
        grid = configuration!.grid
    }
    
    @IBAction func saveConfiguration(_ sender: UIBarButtonItem) {
        if let configurationTitle = titleTextField.text, let completion = completion {
            StandardEngine.engine.saveGrid(grid: grid)
            configuration!.name = configurationTitle
            configuration!.grid = grid
            completion(configuration!)
        }
        navigationController?.popToRootViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gridEditor.delegate = self
        gridEditor.dataSource = self
        grid = configuration?.grid
        gridEditor!.grid = self.grid
        self.title = configuration?.name
        self.titleTextField!.text = configuration?.name
        
        navigationController?.setNavigationBarHidden(false, animated: true)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
