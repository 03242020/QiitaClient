//
//  TagViewController.swift
//  QiitaClient
//
//  Created by ryo.inomata on 2021/12/24.
//

import UIKit
import Alamofire
import AVFoundation
import RxSwift
import RxCocoa
import WebKit

class TagViewController: UIViewController, UISearchBarDelegate, UITabBarDelegate, UICollectionViewDataSource, UICollectionViewDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        formatstr.dateFormat = "yyyy-MM-dd"
        format.dateFormat = "yyyy-MM-dd'T'HH:mm:ssXXX"
        collectionView.register(UINib(nibName: "QiitaCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "QiitaCollectionViewCell")
        collectionView.register(UINib(nibName: "CustomCell", bundle: nil), forCellWithReuseIdentifier: "CustomCell")
        configureRefreshControl()
        getQiitaArticles()
        let configuration = UICollectionLayoutListConfiguration(appearance: .plain)
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        collectionView.collectionViewLayout = layout
        buttonIos.rx.tap.subscribe(onNext:{[weak self] in
            self!.tag = "iOS"
            self!.articles = []
            self!.collectionView.reloadData()
            self!.getQiitaArticles()
        }).disposed(by: disposeBag)
        buttonKotlin.rx.tap.subscribe(onNext:{[weak self] in
            self!.tag = "Kotlin"
            self!.articles = []
            self!.collectionView.reloadData()
            self!.getQiitaArticles()
        }).disposed(by: disposeBag)
        buttonJava.rx.tap.subscribe(onNext:{[weak self] in
            self!.tag = "Java"
            self!.articles = []
            self!.collectionView.reloadData()
            self!.getQiitaArticles()
        }).disposed(by: disposeBag)
    }
    
    typealias DataSourceType = UICollectionViewDiffableDataSource<Int, String>
    
    private var dataSource: DataSourceType!
    let disposeBag = DisposeBag()
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var buttonIos: UIButton!
    @IBOutlet weak var buttonKotlin: UIButton!
    @IBOutlet weak var buttonJava: UIButton!
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("articles.count: ", articles.count)
        return articles.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCell", for: indexPath) as! CustomCell
        let article = articles[indexPath.row]
            format.locale = Locale(identifier: "en_US_POSIX")
            format.timeZone = TimeZone(identifier: "Asia/Tokyo")
            let date = format.date(from: article.created_at)
            let dateStr = formatstr.string(from: date!)
            let authorColon = "著者: " + article.user.id
            let postedColon = "投稿日: " + dateStr
            let titleColon = "タイトル: " + article.title
        cell.setupCell(title: titleColon, author: authorColon, posted: postedColon)
        cell.layer.borderColor = UIColor.lightGray.cgColor // 外枠の色
        cell.layer.borderWidth = 1.0 // 枠線の太さ
        return cell
    }
    
    var token = "daac5dc84737855447811d2982becb4afb2d688d"

    //QiitaAPI制限を1時間1000回に増やす。ベアラー認証。
    let Auth_header: HTTPHeaders = [
        "Authorization" : "Bearer daac5dc84737855447811d2982becb4afb2d688d"
    ]

    let decoder: JSONDecoder = JSONDecoder()
    let encoder: JSONEncoder = JSONEncoder()
    let format = DateFormatter()
    let formatstr = DateFormatter()
    let iso8601DateFormatter = ISO8601DateFormatter()
    //表示するデータの配列
    var datas:[Data] = []
    //表示ステータス
    var displayStatus:String = "standby"
    //    現在取得しているセル数
    private var page: Int = 1
    private var escapePage: Int = 0
    private var per_page: Int = 20
    private var tag: String = "iOS"
    public var tabTag = 0
    //    必要以上のapi叩かない様にする
    private var loadStatus: String = "initial"

    private var articles: [QiitaArticle] = [] // ②取得した記事一覧を保持しておくプロパティ
    var bool = true
    private var viewArticles: [QiitaArticle] = []
    var num:Int = 0
    var countStack = 0
    var free = ""
    var isLoading = false
    enum LoadStatus {
        case initial
        case fetching
        case full
    }
    

    
    override func viewDidAppear(_ animated: Bool) {
         super.viewDidAppear(animated)
     }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentOffsetY = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.height
        let distanceToBottom = maximumOffset - currentOffsetY

        if(countStack != articles.count) {
            print("articles.count: ",articles.count)
        }
        countStack = articles.count
        if distanceToBottom < 50 {
            getQiitaArticles()
            print(articles.count)
        }
        self.view.endEditing(true)
    }
    
    //     loadする関数の定義
    private func getQiitaArticles() {
        guard loadStatus != "fetching" && loadStatus != "full" else { return }
        loadStatus = "fetching"
        print("getQiitaArticles内、サーチ処理中のpage ",self.page,"+ per_page " , self.per_page)

        AF.request("https://qiita.com/api/v2/tags/\(tag)/items?page=\(page)&per_page=\(per_page)",headers: Auth_header).responseData { [self] response in
            switch response.result {
            case .success:
                do {
                    print("page: " + String(self.page))
                    self.loadStatus = "loadmore"
                    viewArticles = try self.decoder.decode([QiitaArticle].self, from: response.data!)
                    if self.page == 100 {
                        self.loadStatus = "full"
                    }
                    self.articles += viewArticles
                    print("getQiitaArticles内且つdo内、サーチ処理中のpage ",self.page,"+ per_page " , self.per_page)
                    self.page += 1 //pageを+1する処理
                    self.collectionView.reloadData()
                } catch {
                    self.loadStatus = "error"
                    print("デコードに失敗しました")
                }
            case .failure(let error):
                print("error", error)
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "WebViewController", bundle: nil)
            let webViewController = storyboard.instantiateInitialViewController() as! WebViewController
            let article = self.articles[indexPath.row]
            webViewController.url = article.url
            self.navigationController?.pushViewController(webViewController, animated: true)
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text {
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
                let storyboard = UIStoryboard(name: "WebViewController", bundle: nil)
                guard let viewController = storyboard.instantiateInitialViewController() as? WebViewController else { return }
                let itemString = String(text)
                let itemEncodeString = itemString.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)
                let urlString = "https://qiita.com/search?q=\(itemEncodeString!)"
                viewController.url = urlString
                navigationController?.pushViewController(viewController, animated: true)
                viewController.openURL(viewController.url)
                print("サーチelse...articles.count: ",articles.count)
            }
        }
        searchBar.resignFirstResponder()
        self.collectionView.reloadData()

    }
    func configureRefreshControl () {
        //RefreshControlを追加する処理
        collectionView.refreshControl = UIRefreshControl()
        collectionView.refreshControl?.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
    }
    
    @objc func handleRefreshControl() {
        articles = []
        self.page = 1
        getQiitaArticles()
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            self.collectionView.refreshControl?.endRefreshing()
            self.view.endEditing(true)
        }
    }
}

//============================================================


class TagLabel: UILabel {
    
    let tagPadding: CGFloat = 5
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.cornerRadius = 2
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 1
        textColor = UIColor.black
        clipsToBounds = true
        numberOfLines = 1
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        let insets = UIEdgeInsets(top: tagPadding, left: tagPadding, bottom: tagPadding, right: tagPadding)
        return super.drawText(in: rect.inset(by: insets))
    }
}
