//
//  Follower.swift
//  GitHubFollowers
//
//  Created by William Yeung on 3/21/21.
//

import Foundation

struct Follower: Codable, Hashable {
    var login: String
    var avatarUrl: String
}
