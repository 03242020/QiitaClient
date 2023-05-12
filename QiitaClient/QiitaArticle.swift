//
//  QiitaArticle.swift
//  QiitaClient
//
//  Created by ryo.inomata on 2021/11/30.
//

import Foundation

//struct QiitaArticle: Codable {
//
//    let body: String
//    let title: String
//    let url: String
//    let created_at:String
//    let user: QiitaUser
//}

struct QiitaArticle: Codable,Identifiable {
    var id: UUID // Todo.ID が UUID のエイリアスになる
    var title: String
    var done: Bool
}

struct QiitaArticleDiffable: Identifiable {
    var id: UUID
    
    let body: String
    let title: String
    let url: String
    let created_at:String
    let user: QiitaUser
}

//struct QiitaArticleDiffable: Identifiable {
//    var id: UUID
//    let title: String
//    var done: Bool
//}
