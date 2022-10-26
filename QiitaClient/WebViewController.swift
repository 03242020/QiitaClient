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
        if #available(iOS 11.0, *) {
            // 'keyWindow' was deprecated in iOS 13.0: Should not be used for applications
            DispatchQueue.main.async {
                let scenes = UIApplication.shared.connectedScenes
                let windowScene = scenes.first as? UIWindowScene
                let window = windowScene?.windows.first
                //iOS 15.0から黄色のエラーメッセージが出るので修正
                //            let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
                self.topPadding = window!.safeAreaInsets.top
            }
        }
        DispatchQueue.main.async {
            let rect = CGRect(x: 0,
                              y: self.topPadding + 40,
                              width: screenWidth,
                              height: screenHeight - self.topPadding)
            let webConfiguration = WKWebViewConfiguration()
            self.webView = WKWebView(frame: rect, configuration: webConfiguration)
            self.view.addSubview(self.webView)
            //        view.transform = CGAffineTransform(translationX: 0, y: 150)
            let url = URL(string: self.url)
            print("受け渡し: ", url!)
            let request = URLRequest(url: url!)
            self.webView.load(request)
        }
    }
    public func openURL(_ string: String?) {
        DispatchQueue.main.async {
            guard string != nil else { return }
            let url = URL(string: self.url)!
            let request = URLRequest(url: url)
            self.webView.load(request)
        }
    }
}
