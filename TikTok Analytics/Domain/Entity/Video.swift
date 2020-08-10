//
//  Video.swift
//  TikTok Analytics
//
//  Created by Aleksander Loghozinsky on 08.08.2020.
//

import Foundation

struct VideoResponse: Decodable, ResponseProtocol {
    let success: Bool
    let statusCode: Int
    let data: [Video]?
    let videoCount: Int
    
    private enum CodingKeys: String, CodingKey {
        case success
        case statusCode
        case data
        case videoCount
    }
}

struct Video: Decodable {
    let id: Int
    let tiktokId: Int
    let userId: Int
    let urlTiktok: String
    let url: String
    let coverTiktok: String
    let cover: String
    let text: String
    let comments: Int
    let likes: Int
    let plays: Int
    let shares: Int
    let createTime: String
    let active: Int
    let createdAt: String
    
    
    private enum CodingKeys: String, CodingKey {
        case id
        case tiktokId = "tiktok_id"
        case userId = "user_id"
        case urlTiktok = "url_tiktok"
        case url
        case coverTiktok = "cover_tiktok"
        case cover
        case text
        case comments
        case likes
        case plays
        case shares
        case createTime = "create_time"
        case active
        case createdAt = "created_at"
    }
}
