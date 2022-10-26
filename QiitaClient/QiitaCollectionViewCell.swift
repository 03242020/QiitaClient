//
//  QiitaCollectionViewCell.swift
//  QiitaClient
//
//  Created by ryo.inomata on 2022/10/21.
//

import UIKit

class QiitaCollectionViewCell: UICollectionViewCell {

    
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var postedLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    func setupCell(title: String, author: String, posted: String) {
        authorLabel.text = author
        postedLabel.text = posted
        titleLabel.text = title
    }
}

//import UIKit
//
//class QiitaCollectionViewCell: UICollectionViewCell {
//
//
//    @IBOutlet weak var authorLabel: UILabel!
//    @IBOutlet weak var postedLabel: UILabel!
//    @IBOutlet weak var titleLabel: UILabel!
//
//    func set(title: String, author: String, posted: String) {
//        postedLabel.text = posted
//        titleLabel.text = title
//        authorLabel.text = author
//    }
//}
