//
//  ViewController.swift
//  QiitaClient
//
//  Created by ryo.inomata on 2021/11/25.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // ➀:tableViewのdataSourceをViewController自身に設定
        tableView.dataSource = self

        // ➁:cellをtableViewに設定
        // nibNameはファイル名を指定する
        let nib = UINib(nibName: "QiitaTableViewCell", bundle: nil)
        // Identifierを登録
        tableView.register(nib, forCellReuseIdentifier: "QiitaTableViewCell")
        // cellの高さを設定
        tableView.rowHeight = 80
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 表示するcellの数を返す
        return 15
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // ➂:➁で設定したIdentifierと同じ文字列で取得する。
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "QiitaTableViewCell", for: indexPath) as? QiitaTableViewCell else {
            return UITableViewCell()
        }
        // ➃:cellに情報を設定する
        cell.set(title: "タイトル\(indexPath.row)", author: "作成者")
        return cell
    }


}

