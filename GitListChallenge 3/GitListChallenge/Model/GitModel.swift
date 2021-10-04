//
//  GitModel.swift
//

import Foundation


struct GitResponse: Decodable {
    let TotalCount: Int?
    let IncompleteResults: Bool?
    let Items: [Git]?
    
    enum CodingKeys: String, CodingKey {
        case TotalCount = "total_count"
        case IncompleteResults = "incomplete_results"
        case Items = "items"
    }
    
}

struct Git: Codable {
    let identifier: Int
    let UserName: String
    let ImagePath: String?
    let followers_url: String?
    let following_url: String?
    let repos_url: String?

    enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case UserName = "login"
        case ImagePath = "avatar_url"
        case followers_url, following_url, repos_url
    }
}


struct GitUserDetails : Codable {
    var name : String
    var email : String?
    var location : String
    var followers : Int
    var following : Int
    var joinDate : String
    
    enum CodingKeys : String, CodingKey {
        case joinDate = "created_at"
        case name, email, location, followers,following
    }
}


struct GitUserRepos : Codable {
    let name : String
    let forks : Int?
    let stars : Int?

    enum CodingKeys : String, CodingKey {
        case stars  = "stargazers_count"
        case name, forks
    }
}
