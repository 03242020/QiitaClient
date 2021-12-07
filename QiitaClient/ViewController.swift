//
//  ViewController.swift
//  QiitaClient
//
//  Created by ryo.inomata on 2021/11/25.
//

import UIKit
import Alamofire

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    let decoder: JSONDecoder = JSONDecoder()
    let df = DateFormatter()
    private var articles: [QiitaArticle] = [] // ②取得した記事一覧を保持しておくプロパティ

    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self // この行を追加

        let nib = UINib(nibName: "QiitaTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "QiitaTableViewCell")
        tableView.rowHeight = 80
        getQiitaArticles()
    }
//    count =+
    let url: URL = URL(string: "https://qiita.com/api/v2/tags/iOS/items?page=1&per_page=20")!
    // loadする関数の定義
    private func getQiitaArticles() {
        AF.request(url).responseJSON { response in
            switch response.result {
            case .success:
                do {
                    self.articles = try self.decoder.decode([QiitaArticle].self, from: response.data!)
                    self.tableView.reloadData()
                } catch {
                    print("デコードに失敗しました")
                }
            case .failure(let error):
                print("error", error)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        articles.count
//        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "QiitaTableViewCell", for: indexPath) as? QiitaTableViewCell else {
            return UITableViewCell()
        }
        // ⑧indexPathを用いてarticlesから該当のarticleを取得する
        let article = articles[indexPath.row]
        // ⑨cellへの反映
        cell.set(title: article.title, author: article.user.id, posted: article.created_at)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let storyboard = UIStoryboard(name: "WebViewController", bundle: nil)
            let webViewController = storyboard.instantiateInitialViewController() as! WebViewController
            let article = articles[indexPath.row]
            webViewController.url = article.url
//            webViewController.title = article.title
            navigationController?.pushViewController(webViewController, animated: true)
    }
}
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "QiitaTableViewCell", for: indexPath)
//        let titleLabel = cell.viewWithTag(1) as! UILabel
//        titleLabel.numberOfLines = 0
//        titleLabel.text = articles[indexPath.row].title
//        let authorLabel = cell.viewWithTag(2) as! UILabel
//        authorLabel.numberOfLines = 0
//        authorLabel.text = articles[indexPath.row].title
//        let postedLabel = cell.viewWithTag(3) as! UILabel
//        postedLabel.numberOfLines = 0
//        postedLabel.text = articles[indexPath.row].title
////        cell.textLabel?.text = articles[indexPath.row].title
//        return cell
//    }

//    private func loadArticles() {
//        // ③Qiita APIを叩く
//        AF.request("https://qiita.com/api/v2/tags/iOS/items").response { response in
//            guard let data = response.data else {
//                return
//            }
//            let decoder = JSONDecoder()
//            do {
//                // ④レスポンスを[QiitaArticle]にデコード
//                let articles: [QiitaArticle] = try decoder.decode([QiitaArticle].self, from: data)
//                // ⑤取得した記事をarticlesに代入
//                self.articles = articles
//                print(articles)
//                // ⑥tableViewを更新
//                self.tableView.reloadData()
//            } catch {
//                print(error)
//            }
//        }
//    }


//extension ViewController: UITableViewDataSource , UITableViewDelegate {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 10
//    }
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: "QiitaTableViewCell", for: indexPath) as? QiitaTableViewCell else {
//            return UITableViewCell()
//        }
//        let article = articles[indexPath.row]
//        cell.set(title: article.title, author: article.user.id)
//        return cell
//    }
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let storyboard = UIStoryboard(name: "WebViewController", bundle: nil)
//        let webViewController = storyboard.instantiateInitialViewController() as! WebViewController
//        navigationController?.pushViewController(webViewController, animated: true)
//    }
//}

//extension ViewController: UITableViewDelegate, UITableViewDataSource {
//
//func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//    articles.count
//}
//
//func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//    let cell = tableView.dequeueReusableCell(withIdentifier: "articleCell", for: indexPath)
//    cell.textLabel?.text = articles[indexPath.row].title
//    return cell
//}
//
//}
