//
//  GitListLoader.swift
//

import Foundation

class GitListLoader {
    
    var session : GitURLSession = URLSession.shared
    static let shared = GitListLoader()
    
    private init() {
    }
    
    func getGitList(page: Int, searchString: String?, compeltion: @escaping (Result<GitResponse>) -> Void) {
        
        //Percent Encoding converts characters into a format that can be transmitted over the Internet.
        let search = searchString?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
        let url = "https://api.github.com/search/users?q=\(search)"
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
                let gitResponse = try JSONDecoder().decode(GitResponse.self, from: data)
                compeltion(Result.success(gitResponse))
            } catch {
                compeltion(Result.failure)
            }
            
        }.resume()
    }
}
