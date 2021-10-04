//
//  TableViewController.swift
//

import UIKit

class TableViewController: UITableViewController {
    
    let noDataLabel : UILabel = {
        let label = UILabel()
        label.text = "Your search did not match"
        label.numberOfLines = 0
        label.textColor  = UIColor.lightGray
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        return label
    }()
    
    let dataManager = DataManager.shared
    let searchController = UISearchController(searchResultsController: nil)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupSearchBar()
        setupNavigation()
        
        dataManager.loadInitData()
        dataManager.delegate = self
    }
    
    func setupTableView () {
        tableView.register(TableViewCell.self, forCellReuseIdentifier: "gitCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200;
        tableView.backgroundView  = noDataLabel
        tableView.tableFooterView = UIView()
        tableView.backgroundView?.isHidden = true
    }
    
    func setupSearchBar () {
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search for Users"
        searchController.searchBar.text = dataManager.searchString
    }
    
    func setupNavigation() {
        //self.navigationItem.hidesSearchBarWhenScrolling = false
        self.navigationItem.searchController = searchController
        self.navigationItem.title = "GitHub Searcher"
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataManager.gitList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "gitCell", for: indexPath)  as? TableViewCell else {
            return UITableViewCell()
        }
        
        let data = dataManager.getGitModel(at: indexPath.row)
        cell.titleLabel.text = data.gitUserName
        cell.detailLabel.text = data.repoIdentifier
        let imagepath = URL(string: data.imageURL!)!
        cell.gitImageView.loadImage(fromURL: imagepath, placeHolderImage: " ")
        
        return cell
    }

    
    //MARK : - Table view delegate
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //dataManager.cancelTask(at: indexPath.row)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = GitViewController(dataManager.getGitModel(at: indexPath.row), dataManager)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    //MARK : - Incremental loading
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offseY = scrollView.contentOffset.y
        let contentH = scrollView.contentSize.height
        if offseY > contentH - scrollView.frame.height{
            dataManager.loadMoreRepos()
        }
    }
}


// MARK: - UISearchBarDelegate
extension TableViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchController.dismiss(animated: true, completion: nil)
    }
    
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let pretext = searchBar.text
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            if searchBar.text == pretext {
                self.dataManager.searchString = pretext
            }
        }
    }
    
    func scrollToTop() {
        self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
    }
}

// MARK: - DataManager delegate
extension TableViewController: DataMangerDelegate {
    func dataDidChange(_ isLoadMore : Bool) {
        tableView.backgroundView?.isHidden = dataManager.gitList.count != 0
        self.tableView.reloadData()
        if !isLoadMore && dataManager.gitList.count > 0 { self.scrollToTop()}
    }
}


