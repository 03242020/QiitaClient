//
//  ViewController.swift
//  QiitaClient
//
//  Created by ryo.inomata on 2021/11/25.
//

import UIKit
import Alamofire
import AVFoundation
import RxSwift
import RxCocoa

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var emptyLabel: UILabel!
    
    
    var disposeBag = DisposeBag()
    
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
      //表示ステータス
    var displayStatus:String = "standby"
    //現在取得しているセル数
    private var page: Int = 1
    private var escapePage: Int = 0
    private var per_page: Int = 10
    private var tag: String = "iOS"
    //必要以上のapi叩かない様にする
    private var loadStatus: String = "initial"
    private var articles: [QiitaArticle] = [] // ②取得した記事一覧を保持しておくプロパティ
    var bool = true
    private var viewArticles: [QiitaArticle] = []
    var num:Int = 0
    var test = 0
    var isLoading = false
    enum LoadStatus {
        case initial
        case fetching
        case full
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        searchBar.delegate = self //　追記
        tableView.dataSource = self
        tableView.delegate = self // この行を追加
        formatstr.dateFormat = "yyyy-MM-dd"
        format.dateFormat = "yyyy-MM-dd'T'HH:mm:ssXXX"
        
        let nib = UINib(nibName: "QiitaTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "QiitaTableViewCell")
        tableView.rowHeight = 80
        configureRefreshControl()  //この関数を実行することで更新処理がスタート
        getQiitaArticles()
        emptyLabel.isHidden = bool
        if self.articles.count == 0 {
            emptyLabel.isHidden = true
        }else{
            emptyLabel.isHidden = false
        }
        button.addAction(.init { _ in self.getQiitaArticles() }, for: .touchUpInside)

    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentOffsetY = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.height
        let distanceToBottom = maximumOffset - currentOffsetY
        print("===========スクロール処理===========")
        print("maximumOffset: ",maximumOffset)
        print("currentOffset.y: ",scrollView.contentOffset.y)
        print("contentSize.height: ",scrollView.contentSize.height)
        print("frame.height: ",scrollView.frame.height)
        print("distanceToBottom: ",distanceToBottom)
        print("articles.count: ",articles.count)
//        print("currentOffsetY: \(currentOffsetY)")
//        print("maximumOffset: \(maximumOffset)")
//        print("distanceToBottom: \(distanceToBottom)")
        if distanceToBottom < 50 {

            getQiitaArticles()
//            print("articles.count: ",articles.count)
        }
    }

    // loadする関数の定義
    private func getQiitaArticles() {
        guard loadStatus != "fetching" && loadStatus != "full" else { return }
        loadStatus = "fetching"
        print("getQiitaArticles内、サーチ処理中のpage ",self.page,"+ per_page " , self.per_page)
        
        AF.request("https://qiita.com/api/v2/tags/\(tag)/items?page=\(page)&per_page=\(per_page)",headers: Auth_header).responseJSON { [self] response in
            switch response.result {
            case .success:
                do {
                    print("page: " + String(self.page))
                    self.loadStatus = "loadmore"
                    //今のままだと全部上書きされているのでaddにしないといけない。 articlesを消えないように保持する。初期化するときはリフレッシュの時だけにする。

                    viewArticles = try self.decoder.decode([QiitaArticle].self, from: response.data!)

                    if self.page == 100 {
                        self.loadStatus = "full"
                    }
                    self.articles += viewArticles
                    print("getQiitaArticles内且つdo内、サーチ処理中のpage ",self.page,"+ per_page " , self.per_page)
                    if articles.count == 0 {
                        emptyLabel.isHidden = false
                    }else{
                        emptyLabel.isHidden = true
                    }
                    
                    self.page += 1 //pageを+1する処理
                    print("count: " + String(self.articles.count))
                    self.tableView.reloadData()
                } catch {
                    self.loadStatus = "error"
                    print("デコードに失敗しました")
                    emptyLabel.isHidden = false
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
//        print(type(of: article.created_at))


        // ロケール設定（端末の暦設定に引きづられないようにする）
        format.locale = Locale(identifier: "en_US_POSIX")

        // タイムゾーン設定（端末設定によらず、どこの地域の時間帯なのかを指定する）
        format.timeZone = TimeZone(identifier: "Asia/Tokyo")


        // 変換
        let date = format.date(from: article.created_at)


        let dateStr = formatstr.string(from: date!)
//        print(dateStr) // -> 2020-10-20 02:22:33 +0000
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
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text {
            print("===================サーチ処理=========================")
            if text == "" {
                self.page -= 1
                articles = []
                self.escapePage = self.page
                self.per_page = self.page * 10
                self.page = 1
                print("サーチ処理中のpage ",self.page,"+ per_page " , self.per_page)
                getQiitaArticles()
                print("サーチ処理中のarticles.count" ,self.articles.count)
                self.page = self.escapePage
                self.per_page = 10
                
            }else{
                self.page = 1
                tag = text
                articles = []
                getQiitaArticles()
                print("サーチelse...articles.count: ",articles.count)
                emptyLabel.isHidden = false
            }
        }
        self.tableView.reloadData()

        }
    func configureRefreshControl () {
       //RefreshControlを追加する処理
       tableView.refreshControl = UIRefreshControl()
       tableView.refreshControl?.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
    }

    @objc func handleRefreshControl() {
        print("================リフレッシュ処理================")
        articles = []
        self.page = 1
        getQiitaArticles()
//        更新したい処理をここに記入（データの受け取りなど）
       //上記の処理が終了したら下記が実行されます。
       DispatchQueue.main.async {
          self.tableView.reloadData()  //TableViewの中身を更新する場合はここでリロード処理
          self.tableView.refreshControl?.endRefreshing()  //これを必ず記載すること
       }
    }
    }
