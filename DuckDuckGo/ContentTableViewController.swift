//
//  ContentTableViewController.swift
//  DuckDuckGo
//
//  Created by Gopi Krishna on 11/19/19.
//  Copyright © 2019 iCreditWorks. All rights reserved.
//

import UIKit

class ContentTableViewController: UITableViewController, UISearchResultsUpdating {
    
    fileprivate var viewModel = ContentViewModel()
    
    var tableData = [ContentObject]()
    var filteredTableData = [ContentObject]()
    var resultSearchController = UISearchController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resultSearchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.dimsBackgroundDuringPresentation = false
            controller.searchBar.sizeToFit()
            tableView.tableHeaderView = controller.searchBar
            return controller
        })()
        viewModel.getContent(onSuccess: {
            self.tableData = self.viewModel.contentData
          DispatchQueue.main.async {
            self.tableView.reloadData()
          }
            print("Got Data")
        }, onFailure: {
            print("Error getting Data")
        })
        // Reload the table
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if  (resultSearchController.isActive) {
            return filteredTableData.count
        } else {
            return tableData.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        if (resultSearchController.isActive) {
            cell.textLabel?.text = filteredTableData[indexPath.row].Text
            return cell
        }
        else {
            cell.textLabel?.text = tableData[indexPath.row].Text
            //print(tableData?[indexPath.row])
            return cell
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        filteredTableData.removeAll(keepingCapacity: false)
        if let searchText = searchController.searchBar.text {
        filteredTableData = tableData.filter{String(describing: $0.Text) .contains(searchText) || $0.Result .contains(searchText)}
        self.tableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let contentDetailVC = segue.destination as? ContentDetailViewController, let indexPath = sender as? IndexPath {
            if (resultSearchController.isActive) {
                contentDetailVC.content = filteredTableData[indexPath.row]
            } else {
                contentDetailVC.content = viewModel.contentData[indexPath.row]
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let device = UIDevice.current.userInterfaceIdiom
        if device == .pad {
            let splitController = self.splitViewController!.viewControllers
            if let detailVC = splitController.last as? ContentDetailViewController {
                if (resultSearchController.isActive) {
                    detailVC.content = filteredTableData[indexPath.row]
                } else {
                    detailVC.content = viewModel.contentData[indexPath.row]
                }
                splitViewController?.showDetailViewController(detailVC, sender: indexPath)
            }
        } else {
            self.performSegue(withIdentifier: "DetailView", sender: indexPath)
        }
        
    }

}
