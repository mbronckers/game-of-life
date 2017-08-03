//
//  ConfigurationsViewController.swift
//  FinalProject
//
//  Created by Max Bronckers on 7/23/17.
//  Copyright © 2017 Harvard University. All rights reserved.
//

import UIKit

class ConfigurationsViewController: UITableViewController {
    
    var configurations: [Configuration]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let configurationsUrl = URL(string: Const.file.configuration.url) {
            let dataTask = URLSession.shared.dataTask(with: configurationsUrl)
            {   (data, response, error) in
                
                if let error = error {
                    print(error)
                } else {
                    if let data = data {
                        self.configurations = Configuration.configurations(from: data)
                        self.configurations = self.configurations?
                            .sorted() { $0.name > $1.name }
                        
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                        
                    } else {
                        print("The call didn't work")
                    }
                }
            }
            dataTask.resume()
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
   
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let configurations = configurations else {
            return 1
        }
        return configurations.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Const.configurationCellDescription, for: indexPath)
        cell.textLabel?.text = "No configurations present"
        if let configurations = configurations {
            cell.textLabel?.text = configurations[indexPath.row].name.capitalized
        }
        return cell
    }
    
    func add() {
        var addition = configurations![0]
        addition.reset()
        configurations!.append(addition)
        tableView.reloadData()
        let indexPath = IndexPath(item: configurations!.count - 1, section: 0)
        tableView.selectRow(at:indexPath, animated: false, scrollPosition: .middle)
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? EditorViewController {
            if let indexPath = tableView.indexPathForSelectedRow {
                let configuration = configurations![indexPath.row]
                destination.configuration = configuration
                destination.completion = { (newConfiguration) in
                    self.configurations![indexPath.row].grid = newConfiguration.grid
                    self.configurations![indexPath.row].name = newConfiguration.name
                    self.tableView.reloadData()
                }
            }
        }
    }


}
