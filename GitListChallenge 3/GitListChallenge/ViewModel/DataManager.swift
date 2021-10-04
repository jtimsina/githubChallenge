//
//  DataManager.swift
//

import Foundation
import UIKit

enum Result<T> {
    case success(T?)
    case failure
}

protocol DataMangerDelegate : class {
    func dataDidChange(_ isLoadMore : Bool)
}

//protocol  DatamanagerUserDetailsDelegate : class {
//    func userDataLoaded()
//}

class DataManager {
    static let shared = DataManager()
    private let cache = NSCache<NSString, UIImage>()
    private(set) var currentPage : Int
    weak var delegate : DataMangerDelegate?
    private var totalPage : Int?
    private let gitListLoader : GitListLoader
    private let gitUserDetails : RepoLoader
    
    var gitList : [Git]
    var repoList : [GitUserRepos]
    var userDetails : GitUserDetails?

    
    var searchString : String? {
        didSet {
            if searchString != oldValue {
                self.loadInitData()
            }
        }
    }
    
    private init(){
        gitListLoader = GitListLoader.shared
        gitUserDetails = RepoLoader.shared
      //  imageLoader = ImageLoader.shared
        gitList = [Git]()
        repoList = [GitUserRepos]()
        userDetails = GitUserDetails.init(name: "", email: "", location: "", followers: 0, following: 0, joinDate: "")
//        userDetails = GitUserDetails.init(name: "", email: "", location: "", followers: 0, following: 0, joinDate: "")
        currentPage = 0
        searchString = "a"
    }
    
    // This funcntion runs when the TableView is first loaded into the memory and when the searchString is changed.
    func loadInitData() {
        currentPage = 0
        gitListLoader.getGitList(page: currentPage + 1, searchString: searchString) { [weak self] (result) in
            if case .success(let result1) = result, let response2 = result1 {
                self?.gitList = response2.Items ?? []
            }
            DispatchQueue.main.async {
                self?.delegate?.dataDidChange(false)
            }
        }
    }
    
    // Load more repos in response to view scrolling.
    func loadMoreRepos() {
        // execute only when there's more repos in the search results.
        guard let totalPage = totalPage, currentPage < totalPage else {
            return
        }

        gitListLoader.getGitList(page: currentPage + 1 , searchString: searchString) { [weak self] (result) in
            if case .success(let result1) = result, let result2 = result1 {
                // add the current results to the overal list.
                self?.gitList += result2.Items ?? []
                DispatchQueue.main.async {
                    self?.delegate?.dataDidChange(true)
                }
            }
        }
    }
        
    func getGitModel(at index:Int) -> GitModel {
        assert(gitList.count > index, "The number of cells exceeds the number of item list!")
        return GitModel(git : gitList[index])
    }
    
    func getRepoModel (at index:Int) -> GitRepoModel {
        assert(repoList.count > index, "The number of cells exceeds the number of item list!")
        return GitRepoModel(gitRepo: repoList[index])
    }
        
    func loadUserDetails (searchParam:String) {
        gitUserDetails.getUserDetails(searchQuery: searchParam) { [weak self] (result) in
            if case .success(let result1) = result, let response2 = result1 {
                //self?.userDetails = response2
                self?.userDetails?.name = response2.name
                self?.userDetails?.email = response2.email
                self?.userDetails?.location  = response2.location
                self?.userDetails?.followers = response2.followers
                self?.userDetails?.following = response2.following
                self?.userDetails?.joinDate = response2.joinDate
                
            }
            DispatchQueue.main.async {
                self?.delegate?.dataDidChange(false)
            }
        }
    }
    
    func loadUserRepos (searchQuery : String) {
        gitUserDetails.getUserRepos(searchQuery: searchQuery) { [weak self] (result) in
            if case .success(let result1) = result, let response2 = result1 {
                self?.repoList = response2 
                print("The Repo Details are ----> \(response2)")
            }
            DispatchQueue.main.async {
                self?.delegate?.dataDidChange(false)
            }
        }
    }

    func requestData(completion: ((_ data: String) -> Void)) {
        let data = "gitUserDetails"
       completion(data)
    }

}

class LazyLoading : UIImageView {
    private let imageCache = NSCache<AnyObject, UIImage>()
    
    func loadImage(fromURL imageURL: URL, placeHolderImage: String) {
        self.image = UIImage(named: placeHolderImage)
        
        if let cachedImage = self.imageCache.object(forKey: imageURL as AnyObject) {
           
            //debugPrint("Image is from cache = \(imageURL)")
            self.image = cachedImage
            return
        }
        
        DispatchQueue.global().async {
            [weak self] in
            
            if let imageData = try? Data(contentsOf: imageURL) {
                //debugPrint("Image form server .......")
                
                if let image = UIImage(data: imageData) {
                    DispatchQueue.main.async {
                        self?.imageCache.setObject(image, forKey: imageURL as AnyObject)
                        self?.image = image
                    }
                }
            }
        }
    }
}
