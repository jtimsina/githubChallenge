//
//  GitViewController.swift
//

import UIKit

class GitViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
        
    let dataManager = DataManager.shared

    let git : GitModel
    let manager : DataManager
    let repoSearchController = UISearchController(searchResultsController: nil)

    let gitImageView : LazyLoading = {
        let image = LazyLoading()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "Image")
        image.widthAnchor.constraint(equalToConstant: 125).isActive = true
        image.heightAnchor.constraint(equalToConstant: 125).isActive = true

        image.clipsToBounds = true
        return image
    }()
    
    let userNameLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.numberOfLines = 0
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let userEmailLabel : UILabel = {
        let label = UILabel()
        label.textColor = UIColor.darkGray
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let userLocationLabel : UILabel = {
        let label = UILabel()
        label.textColor = UIColor.darkGray
        label.numberOfLines = 0
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let userJoinDateLabel : UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = UIColor.darkGray
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let followersLabel : UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = UIColor.darkGray
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let followingLabel : UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = UIColor.darkGray
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        
        return view
    }()
    
    let tableViewForRepo: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.register(TableViewRepoCellTableViewCell.self, forCellReuseIdentifier: "gitRepoCell")
        view.rowHeight = UITableView.automaticDimension
        //view.estimatedRowHeight = 100;
        view.backgroundColor = .white
        return view
    }()
    
    let contentView: UIView = {
        let view = UIView()

        view.translatesAutoresizingMaskIntoConstraints = false
//        view.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 100.0)
        return view
    }()
    
    init(_ git: GitModel, _ dataManger: DataManager) {
        self.git = git
        //self.gitUserModel = gitUserModel
        self.manager = dataManger
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        dataManager.delegate = self
        //manager.loadUserDetails(searchParam: git.gitUserName)
        manager.loadUserRepos(searchQuery: git.gitUserName)
        setupViewConstraints()
        addSearchController ()
    }
    
    func setupViewConstraints () {
        //set up scroll view
        view.addSubview(scrollView)
        let safeArea = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            scrollView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeArea.centerYAnchor),
            ])
        scrollView.addSubview(contentView)
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            scrollView.topAnchor.constraint(equalTo: contentView.topAnchor),
            scrollView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: safeArea.widthAnchor)
            ])
                
        // set up text view and image
        let textStackView = UIStackView(arrangedSubviews: [userNameLabel, userEmailLabel, userLocationLabel, userJoinDateLabel, followersLabel, followingLabel])
        textStackView.axis = .vertical
        textStackView.spacing = 15
        let combineStackView = UIStackView(arrangedSubviews: [gitImageView,textStackView])
        combineStackView.axis = .horizontal
        combineStackView.alignment = .center
        combineStackView.spacing = 8
        combineStackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(combineStackView)

        NSLayoutConstraint.activate([
            gitImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 50),
            gitImageView.trailingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 125),
            gitImageView.leadingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 125),
            gitImageView.bottomAnchor.constraint(equalTo: textStackView.topAnchor, constant: -20),
            textStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            textStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            textStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 8),
            ])
        
        tableViewForRepo.dataSource = self
        tableViewForRepo.delegate = self
        
        view.addSubview(tableViewForRepo)
        
        NSLayoutConstraint.activate([
            tableViewForRepo.topAnchor.constraint(equalTo: scrollView.bottomAnchor),
            tableViewForRepo.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            tableViewForRepo.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            tableViewForRepo.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        manager.loadUserDetails(searchParam: git.gitUserName)
        setUpView()
    }

    func addSearchController () {
        repoSearchController.searchBar.delegate = self
        repoSearchController.searchBar.placeholder = "Search for User's Repositories"
        tableViewForRepo.tableHeaderView = repoSearchController.searchBar
        //repoSearchController.hidesNavigationBarDuringPresentation = true
    }
    
    private func setUpView() {
        
        userNameLabel.text = String("Name : \((dataManager.userDetails?.name)!)")
        userJoinDateLabel.text = String ("Joining : \((dataManager.userDetails?.joinDate)!)")
        userEmailLabel.text =  String("Email : \((dataManager.userDetails?.email))")
        userLocationLabel.text = String("Location : \((dataManager.userDetails?.location)!)")
        followingLabel.text = String("\((dataManager.userDetails?.following)!) followers")
        followersLabel.text = String("Following \((dataManager.userDetails?.followers)!)")
        let imagepath = URL(string: git.imageURL!)!
        self.gitImageView.loadImage(fromURL: imagepath, placeHolderImage: " ")
    }
    
    
    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return manager.repoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "gitRepoCell", for: indexPath)  as? TableViewRepoCellTableViewCell else {
            return UITableViewCell()
        }
        
        tableView.rowHeight = 60
        let data = manager.getRepoModel(at: indexPath.row)
        cell.repoNameLabel.text = data.name
        cell.starLabel.text = data.gitStars
        cell.forkLabel.text = data.gitForks
        
        return cell
    }
    

    //MARK : - Table view delegate
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
       // manager.cancelTask(at: indexPath.row)
    }

}

// MARK: - UISearchBarDelegate
extension GitViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        repoSearchController.dismiss(animated: true, completion: nil)
    }
    
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let pretext = searchBar.text
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            if searchBar.text == pretext {
                self.manager.searchString = pretext
            }
        }
    }
    
    func scrollToTop() {
        tableViewForRepo.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
    }
    
}

extension GitViewController: DataMangerDelegate {
    func dataDidChange(_ isLoadMore : Bool) {
        setUpView()
        tableViewForRepo.reloadData()
    }
}
