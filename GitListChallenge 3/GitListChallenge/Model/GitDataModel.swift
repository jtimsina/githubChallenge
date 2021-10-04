//
//  GitDataModel.swift
//

import Foundation

struct GitModel {
    
    let git : Git
    
    init(git : Git){
        self.git = git
    }
    
    var loaction: String {
        get {
            return String("Location : \(git.identifier)")
        }
    }
    var gitUserName : String {
        get {
            return git.UserName
        }
    }
    
    var gitUserWithPrefixName : String {
        get {
            return String("Name : \(git.UserName)")
        }
    }

    var emailDetails : String {
        get {
            return String("Email Id: \(git.UserName)@abcd.com")
        }
    }
    var imageURL : String? {
        get {
            return git.ImagePath
        }
    }
    
    var repoIdentifier : String {
        get {
            return String("Repo: \(git.identifier)")
        }
    }

}

struct GitRepoModel {
    let gitRepo : GitUserRepos
    
    init(gitRepo : GitUserRepos){
        self.gitRepo = gitRepo
    }
    
    var name: String {
        get {
            return gitRepo.name
        }
    }
    
    var gitForks : String {
        get {
            return String("\(gitRepo.forks!) Forks")
        }
    }

    var gitStars : String {
        get {
            return String("\(gitRepo.stars!) Stars")
        }
    }

}
