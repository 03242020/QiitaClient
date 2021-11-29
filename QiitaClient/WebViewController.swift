//
//  WebViewController.swift
//  QiitaClient
//
//  Created by ryo.inomata on 2021/11/29.
//

import UIKit
// WebKitをimport
import WebKit

class WebViewController: UIViewController {
    // WKWebViewをプロパティとして保持
    private let webView = WKWebView()

    override func viewDidLoad() {
        super.viewDidLoad()
        // webViewの大きさを画面全体にして表示
        webView.frame = view.frame
        view.addSubview(webView)

        // URLを指定してロードする
        let url = URL(string: "https://www.google.com")
        let request = URLRequest(url: url!)
        webView.load(request)
    }
}
