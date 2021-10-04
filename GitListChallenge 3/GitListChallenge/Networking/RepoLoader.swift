//
//  RepoLoader.swift
//  GitListChallenge
//

import Foundation

class RepoLoader {
    
    var session : GitURLSession = URLSession.shared
    static let shared = RepoLoader()
    
    private init() {
    }
    
    func getUserDetails(searchQuery: String?, compeltion: @escaping (Result<GitUserDetails>) -> Void) {
        
        let search = searchQuery?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
        let url = "https://api.github.com/users/\(search)"
        guard let url = URL(string: url) else {
            compeltion(Result.failure)
            return
        }
        
        self.session.dataTask(with: url) { (data, _, error) in
            if let _ = error {
                compeltion(Result.failure)
                return
            }
            
            guard let data = data else {
                compeltion(Result.failure)
                return
            }
            
            do {
                let gitResponse = try JSONDecoder().decode(GitUserDetails.self, from: data)
                compeltion(Result.success(gitResponse))
            } catch {
                compeltion(Result.failure)
            }
            
        }.resume()
    }
    
    func getUserRepos(searchQuery: String?, compeltion: @escaping (Result<[GitUserRepos]>) -> Void) {
        
        let search = searchQuery?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
        let url = "https://api.github.com/users/\(search)/repos"
        guard let url = URL(string: url) else {
            compeltion(Result.failure)
            return
        }
        
        self.session.dataTask(with: url) { (data, _, error) in
            if let _ = error {
                compeltion(Result.failure)
                return
            }
            
            guard let data = data else {
                compeltion(Result.failure)
                return
            }
            
            do {
                let gitResponse = try JSONDecoder().decode([GitUserRepos].self, from: data)
                compeltion(Result.success(gitResponse))
            } catch {
                compeltion(Result.failure)
            }
            
        }.resume()
    }
}
