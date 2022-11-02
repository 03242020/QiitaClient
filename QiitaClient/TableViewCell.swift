//
//  TableViewCell.swift
//  QiitaClient
//
//  Created by ryo.inomata on 2022/11/02.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var postedLabel: UILabel!
    
    func setupCell(title: String, author: String, posted: String) {
        authorLabel.text = author
        postedLabel.text = posted
        titleLabel.text = title
    }
}
