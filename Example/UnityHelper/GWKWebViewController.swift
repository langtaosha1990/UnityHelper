//
//  GWKWebViewController.swift
//  UnityHelper_Example
//
//  Created by Gpf 郭 on 2024/4/20.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import UIKit
import WebKit

class GWKWebViewController: UIViewController, WKNavigationDelegate, WKScriptMessageHandler {
    var webView: WKWebView!
    
    override func loadView() {
        let contentController = WKUserContentController()
        contentController.add(self, name: "callbackHandler")
        
        let configuration = WKWebViewConfiguration()
        configuration.userContentController = contentController
        
        webView = WKWebView(frame: .zero, configuration: configuration)
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.allowsBackForwardNavigationGestures = true
    }
    
    func loadWebView(_ urlStr:String) {
        guard let url = URL(string: urlStr) else {
            return
        }
        webView.load(URLRequest(url: url))
    }
    
    // 实现 WKScriptMessageHandler 的代理方法
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if let messageBody = message.body as? String {
            print("Message from JavaScript: \(messageBody)")
        }
    }
}
