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

    let decoder: JSONDecoder = JSONDecoder()
    let format = DateFormatter()
    let formatstr = DateFormatter()
    let iso8601DateFormatter = ISO8601DateFormatter()
    
    private var articles: [QiitaArticle] = [] // ②取得した記事一覧を保持しておくプロパティ
//    var player:AVAudioPlayer?
    var num:Int = 0
    var test = 0
    var isLoading = false;
//    let num1:Int = 86
//    let url = self.num1 as! String
//    let url = String(self.num1)

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        func scrollViewDidScroll(_ scrollView: UIScrollView) {
//            let currentOffsetY = scrollView.contentOffset.y
//            let maximumOffset = scrollView.contentSize.height - scrollView.frame.height
//            let distanceToBottom = maximumOffset - currentOffsetY
//            print("currentOffsetY: \(currentOffsetY)")
//            print("maximumOffset: \(maximumOffset)")
//            print("distanceToBottom: \(distanceToBottom)")
//        }
        
//        func scrollViewDidScroll(_ scrollView: UIScrollView) {
//
//          if (self.table.contentOffset.y + self.table.frame.size.height > self.table.contentSize.height && self.table.isDragging && !isLoading){
//
//            isLoading = true
//
//            displayPage += 1
//
//            myload(page: displayPage)
//
//          }
//
//        }
//        let button = UIButton()
//        button.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(button)
//
//        button.layer.cornerRadius = 60 / 2
//        button.layer.cornerCurve = .continuous
//        button.backgroundColor = UIColor.red
//        button.setTitle("追加読み込み", for: .normal)
////        button.addAction(.init { _ in self.num += 20 }, for: .touchUpInside)
////        button.addAction(.init { _ in self.getQiitaArticles(some: self.num) }, for: .touchUpInside)
//        let constraints = [
//            button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30),
//            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            button.widthAnchor.constraint(equalToConstant: 200),
//            button.heightAnchor.constraint(equalToConstant: 60)
//        ]
//        NSLayoutConstraint.activate(constraints)
//        button.addTarget(self, action: #selector(self.buttonTapped(sender:)), for: .touchUpInside)
//    }
//
//    @objc func buttonTapped(sender:UIButton) {
//        animateView(sender)
//    }
//
//    func animateView(_ viewToAnimate:UIView) {
//        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn, animations: {
//            viewToAnimate.transform = CGAffineTransform(scaleX: 1.08, y: 1.08)
//        }) { (_) in
//            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 10, options: .curveEaseOut, animations: {
//                viewToAnimate.transform = .identity
//
//            }, completion: nil)
//        }
        
//        let sNum1:String = String(num1)
        
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
//    count =+

//    let num = 0
//    let insert = self.num
//    let url = "https://qiita.com/api/v2/tags/iOS/items?page=1&per_page=" + String(20 + self.some)
//    let url: URL = URL(string: "https://qiita.com/api/v2/tags/iOS/items?page=1&per_page=20")!
    // loadする関数の定義
    private func getQiitaArticles(some: Int) {
        AF.request("https://qiita.com/api/v2/tags/iOS/items?page=1&per_page=" + String(20 + some)).responseJSON { response in
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
//        let strDate = format.string(from: article.created_at)
//        let date = format.date(from: article.created_at)
//        print(article.created_at)
        //dateFormatter.dateFormat = "yyyyMMddHHmmssSSS" // ミリ秒込み

        // ロケール設定（端末の暦設定に引きづられないようにする）
        format.locale = Locale(identifier: "en_US_POSIX")

        // タイムゾーン設定（端末設定によらず、どこの地域の時間帯なのかを指定する）
        format.timeZone = TimeZone(identifier: "Asia/Tokyo")
        //dateFormatter.timeZone = TimeZone(identifier: "Etc/GMT") // 世界標準時

        // 変換
        let date = format.date(from: article.created_at)
//        let date1 = iso8601DateFormatter.date(from: article.created_at)
        //let date = dateFormatter.date(from: "20201020112233456") // ミリ秒込み

        // 結果表示

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

//extension ViewController {
//    var player: AVAudioPlayer? {
//        get {
//            guard let object = objc_getAssociatedObject(self, &player) as? AVAudioPlayer else {
//                return nil
//            }
//            return object
//        }
//        set {
//            objc_setAssociatedObject(self, &player, newValue, .OBJC_ASSOCIATION_RETAIN)
//        }
//    }
//}
//
//class TouchFeedbackView: UIView {
//    // タップ開始時の処理
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        super.touchesBegan(touches, with: event)
//        self.touchStartAnimation()
//    }
//
//    // タップキャンセル時の処理
//    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
//        super.touchesCancelled(touches, with: event)
//        self.touchEndAnimation()
//    }
//
//    // タップ終了時の処理
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        super.touchesEnded(touches, with: event)
//        self.touchEndAnimation()
//    }
//
//    // ビューを凹んだように見せるアニメーション
//    private func touchStartAnimation() {
//        UIView.animate(withDuration: 0.1,
//                       delay: 0.0,
//                       options: UIView.AnimationOptions.curveEaseIn,
//                       animations: {
//                        // 少しだけビューを小さく縮めて、奥に行ったような「凹み」を演出する
//                        self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
//        },
//                       completion: nil
//        )
//    }
//
//    // 凹みを元に戻すアニメーション
//    private func touchEndAnimation() {
//        UIView.animate(withDuration: 0.1,
//                       delay: 0.0,
//                       options: UIView.AnimationOptions.curveEaseIn,
//                       animations: {
//                        // 元の倍率に戻す
//                        self.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
//        },
//                       completion: nil
//        )
//    }
//}

//// 使用例
//class LessonCardView: TouchFeedbackView {
//    // ...
//}
