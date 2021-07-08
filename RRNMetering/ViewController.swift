//
//  ViewController.swift
//  RRNMetering
//
//  Created by Vlad Ralovich on 1.07.21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var mySearchBar: UISearchBar!
    
    var searchActive = false
    var filtered: [Model] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        crealeModel()
        myTableView.delegate = self
        myTableView.dataSource = self
        mySearchBar.delegate = self
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchActive ? filtered.count : model.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = searchActive ? filtered[indexPath.row].name : model[indexPath.row].name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let detailVC = storyboard.instantiateViewController(identifier: "DetailViewController") as! DetailViewController
        
        detailVC.titleForLabel = searchActive ? filtered[indexPath.row].name : model[indexPath.row].name
        detailVC.ipPost = searchActive ? filtered[indexPath.row].ip : model[indexPath.row].ip
        show(detailVC, sender: nil)
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        filtered = model.filter({ (mod) -> Bool in
            let tmp: NSString = mod.name as NSString
            let range = tmp.range(of: searchText, options: .caseInsensitive)
                    return range.location != NSNotFound
                })
                if(filtered.count == 0){
                    searchActive = false;
                } else {
                    searchActive = true;
                }
                self.myTableView.reloadData()
    }
}
