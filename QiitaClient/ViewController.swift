//
//  ViewController.swift
//  QiitaClient
//
//  Created by ryo.inomata on 2021/11/25.
//

import UIKit
import Alamofire
import AVFoundation

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var button: UIButton!

    
    let username = "ryo_inomata"
    let password = "1q1q1q1q"


    var token = "daac5dc84737855447811d2982becb4afb2d688d"

    let Auth_header: HTTPHeaders = [
        "Authorization" : "Bearer daac5dc84737855447811d2982becb4afb2d688d"
    ]

    let decoder: JSONDecoder = JSONDecoder()
    let format = DateFormatter()
    let formatstr = DateFormatter()
    let iso8601DateFormatter = ISO8601DateFormatter()
        //表示するデータの配列
    var datas:[Data] = []
      //ページネーション関連変数
    var pageCount:Int = 1
      //表示ステータス
    var displayStatus:String = "standby"
      //ページの総数
    var total_pages:Int = 1
    
    private var articles: [QiitaArticle] = [] // ②取得した記事一覧を保持しておくプロパティ

    var num:Int = 0
    var test = 0
    var isLoading = false;


    override func viewDidLoad() {
        super.viewDidLoad()
        

      
        tableView.dataSource = self
        tableView.delegate = self // この行を追加
        formatstr.dateFormat = "yyyy-MM-dd"
        format.dateFormat = "yyyy-MM-dd'T'HH:mm:ssXXX"
        
        let nib = UINib(nibName: "QiitaTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "QiitaTableViewCell")
        tableView.rowHeight = 80
        getQiitaArticles(some: num)
        button.addAction(.init { _ in self.num += 20 }, for: .touchUpInside)
        button.addAction(.init { _ in self.getQiitaArticles(some: self.num) }, for: .touchUpInside)

    }

    // loadする関数の定義
    private func getQiitaArticles(some: Int) {
        AF.request("https://qiita.com/api/v2/tags/iOS/items?page=1&per_page=" + String(20 + some),headers: Auth_header).responseJSON { response in
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
        print(type(of: article.created_at))


        // ロケール設定（端末の暦設定に引きづられないようにする）
        format.locale = Locale(identifier: "en_US_POSIX")

        // タイムゾーン設定（端末設定によらず、どこの地域の時間帯なのかを指定する）
        format.timeZone = TimeZone(identifier: "Asia/Tokyo")


        // 変換
        let date = format.date(from: article.created_at)


        let dateStr = formatstr.string(from: date!)
        print(dateStr) // -> 2020-10-20 02:22:33 +0000
        let authorColon = "著者: " + article.user.id
        let postedColon = "投稿日: " + dateStr
        let titleColon = "タイトル: " + article.title
        // ⑨cellへの反映
        cell.set(title: titleColon, author: authorColon, posted: postedColon)

        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let storyboard = UIStoryboard(name: "WebViewController", bundle: nil)
            let webViewController = storyboard.instantiateInitialViewController() as! WebViewController
            let article = articles[indexPath.row]
            webViewController.url = article.url
            navigationController?.pushViewController(webViewController, animated: true)
    }

    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        if tableView.contentOffset.y + tableView.frame.size.height > tableView.contentSize.height && tableView.isDragging {
            getQiitaArticles(some: self.num)
        }
    }

}
