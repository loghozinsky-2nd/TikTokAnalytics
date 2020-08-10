//
//  User.swift
//  TikTok Analytics
//
//  Created by Aleksander Loghozinsky on 06.08.2020.
//

import Foundation

protocol ResponseProtocol {
    var success: Bool { get }
    var statusCode: Int { get }
}

struct UserResponse: Decodable, ResponseProtocol {
    let success: Bool
    let statusCode: Int
    let data: UserData?
    
    private enum CodingKeys: String, CodingKey {
        case success
        case statusCode
        case data
    }
}

struct UserData: Decodable {
    let id: Int
    let tiktokId: Int
    let secUid: String
    let login: String
    let link: String
    let nickname: String?
    let bio: String?
    let avatarThumb: String?
    let avatarMedium: String?
    let avatar: String?
    let following: Int
    let followers: Int
    let followersLost: Int
    let followersGained: Int
    let likes: Int
    let videos: Int
    let lastVisit: String
    let createdAt: String
    
    private enum CodingKeys: String, CodingKey {
        case id
        case tiktokId = "tiktok_id"
        case secUid
        case login
        case link
        case nickname
        case bio
        case avatarThumb = "avatar_thumb"
        case avatarMedium = "avatar_medium"
        case avatar
        case following
        case followers
        case followersLost = "followers_lost"
        case followersGained = "followers_gained"
        case likes
        case videos
        case lastVisit = "last_visit"
        case createdAt = "created_at"
    }
}
