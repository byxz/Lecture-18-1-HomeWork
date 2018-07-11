//
//  ViewController.swift
//  url
//
//  Created by Mac on 21.06.2018.
//  Copyright © 2018 testOrg. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var textView: UITextView!
    
    @IBAction func reloadButton(_ sender: Any) {
        tableView.reloadData()
    }
    
    private let worker = APIWorker()
    
    var array:[PrivatStruct] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        advancedLoad()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        worker.сancel()
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    private func showAlert(with error: Error) {
        let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .cancel)
        alertController.addAction(action)
        
        show(alertController, sender: nil)
    }
    
    
    private func advancedLoad() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        worker.loadData { (games, error) in
            
            if let error = error {
                DispatchQueue.main.async {
                    self.showAlert(with: error)
                }
                return
            }
            
            guard let games = games else { return }
            
            
            DispatchQueue.main.async {
                
                self.textView.text = "\(games)"
                self.array = games
                self.reloadData()
            }
        }
        
    }
    
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomeCell
        
        cell.groupLabel.text = array[indexPath.row].city
        
        cell.triOfHomeTeamLabel.text = array[indexPath.row].devices.cityEN
        cell.fullOfHomeTeamLabel.text = array[indexPath.row].address
        
        cell.triOfVisitTeamLabel.text = array[indexPath.row].devices.cityRU
        cell.fullOfVisitTeamLabel.text = array[indexPath.row].address
        
        return cell
    }
    
    func reloadData() {
        tableView.reloadData()
    }
    
}

