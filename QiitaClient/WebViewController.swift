//
//  WebViewController.swift
//  QiitaClient
//
//  Created by ryo.inomata on 2021/11/29.
//
import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate {
    var webView = WKWebView()
    var url: String!
    var topPadding:CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let screenWidth:CGFloat = view.frame.size.width
        let screenHeight:CGFloat = view.frame.size.height
        //        webView.frame = view.frame
        if #available(iOS 11.0, *) {
            // 'keyWindow' was deprecated in iOS 13.0: Should not be used for applications
            let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
            topPadding = window!.safeAreaInsets.top
        }
        //        let safeAreaInsets = UIApplication.shared.windows.first { $0.isKeyWindow }!.safeAreaInsets.left
        //        if(safeAreaInsets >= 80.0){
        //            webView.frame = CGRect(x: 0,
        //                                   y: 100,
        //                                   width: view.frame.size.width,
        //                                   height: view.frame.size.height)
        //        }
        let rect = CGRect(x: 0,
                          y: topPadding + 40,
                          width: screenWidth,
                          height: screenHeight - topPadding)
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: rect, configuration: webConfiguration)
        view.addSubview(webView)
        //        view.transform = CGAffineTransform(translationX: 0, y: 150)
        let url = URL(string: self.url)
        print("受け渡し: ", url)
        let request = URLRequest(url: url!)
        webView.load(request)
    }
    public func openURL(_ string: String?) {
        //        実際にはreturnするだけでなく何かしらのエラーメッセージが出るようにする
        guard string != nil else { return }
        let url = URL(string: url)!
        let request = URLRequest(url: url)
        webView.load(request)
    }
}


//import UIKit
//// WebKitをimport
//import WebKit
//
//class WebViewController: UIViewController {
//    // WKWebViewをプロパティとして保持
//    private let webView = WKWebView()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        // webViewの大きさを画面全体にして表示
//        webView.frame = view.frame
//        view.addSubview(webView)
//
//        // URLを指定してロードする
//        let url = URL(string: "https://www.google.com")
//        let request = URLRequest(url: url!)
//        webView.load(request)
//    }
//}
