//
//  QiitaUser.swift
//  QiitaClient
//
//  Created by ryo.inomata on 2021/11/29.
//

import Foundation

struct QiitaUser: Codable {
    //    let created_at: String
    //    "created_at": "2000-01-01T00:00:00+00:00",
    let id: String
    let imageUrl: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case imageUrl = "profile_image_url"
    }
}
