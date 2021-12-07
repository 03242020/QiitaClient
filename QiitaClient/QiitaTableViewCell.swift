//
//  QiitaTableViewCell.swift
//  QiitaClient
//
//  Created by ryo.inomata on 2021/11/25.
//

import UIKit

class QiitaTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var postedLabel: UILabel!
    
    func set(title: String, author: String, posted: String) {
        postedLabel.text = posted
        titleLabel.text = title
        authorLabel.text = author
    }
}
