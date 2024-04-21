//
//  ViewController.swift
//  UnityHelper
//
//  Created by langtaosha1990 on 04/20/2024.
//  Copyright (c) 2024 langtaosha1990. All rights reserved.
//

import UIKit


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

//        let url = "/Users/gpf/CodeField/PrivatePods/pods/UnityHelper/Example/UnityHelper/WebView.html";
//        let webView = GWKWebViewController();
//        webView.loadWebView(url)
//        webView.loadWebView(url: "https://www.baidu.com/")
        if let url = Bundle.main.path(forResource: "WebView", ofType: "html") {
            let webView = GWKWebViewController();
            webView.loadWebView(url)
            self.present(webView, animated: true)
        }
        
    }

}

