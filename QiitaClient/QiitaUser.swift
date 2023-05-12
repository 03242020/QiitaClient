//
//  QiitaUser.swift
//  QiitaClient
//
//  Created by ryo.inomata on 2021/11/29.
//

import Foundation

struct QiitaUser: Codable,Identifiable {
    
    let id: String
    let imageUrl: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case imageUrl = "profile_image_url"
    }
}
