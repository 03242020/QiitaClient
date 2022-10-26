//
//  CustomCell.swift
//  QiitaClient
//
//  Created by ryo.inomata on 2022/10/20.
//

import UIKit

class CustomCell: UICollectionViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var subTitle: UILabel!
    @IBOutlet weak var posted: UILabel!
    
    //    func setupCell(model: Model) {
//        title.text = model.title
//
//        if let text = model.subTitle {
//            subTitle.text = text
//        }
    
    func setupCell(title: String, author: String, posted: String) {
        self.title.text = title
        subTitle.text = author
        self.posted.text = posted
        self.backgroundColor = .lightGray
    }
}
