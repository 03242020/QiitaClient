//
//  QiitaArticle.swift
//  QiitaClient
//
//  Created by ryo.inomata on 2021/11/30.
//

import Foundation

struct QiitaArticle: Codable {
    let body: String
    let title: String
    let url: String
    let created_at:String
//    let date:String
    let user: QiitaUser // ⓵
//    let user: String
}
