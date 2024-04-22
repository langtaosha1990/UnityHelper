//
//  GWKWebViewController.swift
//  SwiftTestDemo
//
//  Created by Gpf 郭 on 2024/4/20.
//

import UIKit
import WebKit

//MARK: 是否为刘海屏系列
public var iPhoneXSerialKey:Bool{
    if #available(iOS 11.0, *) {
        let bottom:CGFloat = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
        return bottom > 0
    }else{ return false }
}

//MARK: -  status_bar
public let WKWebviewControllerStatusBarHeight:CGFloat = iPhoneXSerialKey ? 44 : 20
//MARK: -  TopHeight
public let WKWebviewControllerTopHeight:CGFloat = WKWebviewControllerStatusBarHeight+44
//MARK: -  BottomHeight
public let WKWebviewControllerBottomHeight:CGFloat = iPhoneXSerialKey ? 83 : 49
//MARK: -  BottomSafeEdge
public let WKWebviewControllerBottomSafeEdge:CGFloat = iPhoneXSerialKey ? 37:0
//MARK: -  ScreenWidth
public let WKWebviewControllerScreenWidth:CGFloat = UIScreen.main.bounds.size.width
//MARK: -  ScreenHeight
public let WKWebviewControllerScreenHeight:CGFloat = UIScreen.main.bounds.size.height

public enum URLType {
    /// 在线
    case online
    /// 本地文件
    case localFile
}

public class GWKWebViewController: UIViewController, WKNavigationDelegate, WKUIDelegate {
    
    public lazy var navBackView: GWKWebNavBackView = {
        let backView = GWKWebNavBackView();
        backView.frame = CGRectMake(0, 0, WKWebviewControllerScreenWidth, WKWebviewControllerTopHeight)
        backView.backgroundColor = UIColor.init(red: 237 / 255.0, green: 231 / 255.0, blue: 221 / 255.0, alpha: 1.0)
        view.addSubview(backView)
        return backView
    }()
    
    
    public lazy var webView: WKWebView = {
        let configuration = WKWebViewConfiguration()
        configuration.userContentController.add(self, name: "callbackHandler")
        let webView = WKWebView(frame:.zero, configuration: configuration)
//        let webView = WKWebView()
        webView.allowsBackForwardNavigationGestures = true
        webView.frame = CGRectMake(0, WKWebviewControllerTopHeight, UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height - 84)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.autoresizingMask = UIView.AutoresizingMask.init(rawValue: 1|4)
        webView.isMultipleTouchEnabled = true
        webView.autoresizesSubviews = true
        webView.scrollView.alwaysBounceVertical = true
        webView.allowsBackForwardNavigationGestures = true
        webView.navigationDelegate = self
        return webView
    }()
    

    init() {
        super.init(nibName: nil, bundle: nil)
        // 在这里进行其他的初始化操作
        modalPresentationStyle = .fullScreen
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addKVOObserver()
        view.addSubview(navBackView)
        view.addSubview(webView)
        navBackView.dismissBtn.addTarget(self, action: #selector(dismissAction), for: .touchUpInside)
        navBackView.backButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        self.navBackView.backButton.isHidden = true
        configScriptHandler()
    }
    
    @objc func dismissAction() {
        dismiss(animated: true)
    }
    
    @objc func goBack() {
        self.webView.goBack()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func loadWebView(_ urlStr:String, _ type : URLType) {
        if type == .localFile {
            let url = URL(fileURLWithPath: urlStr)
            webView.loadFileURL(url, allowingReadAccessTo: url)
        } else {
            guard let url = URL(string: urlStr) else {
                return
            }
            webView.load(URLRequest(url: url))
        }
    }
    
    //MARK: - 添加观察者
    public func addKVOObserver(){
        self.webView.addObserver(
            self,
            forKeyPath: "estimatedProgress",
            options: [NSKeyValueObservingOptions.new,NSKeyValueObservingOptions.old],
            context: nil
        )
        self.webView.addObserver(
            self,
            forKeyPath: "canGoBack",
            options:[NSKeyValueObservingOptions.new,NSKeyValueObservingOptions.old],
            context: nil
        )
        self.webView.addObserver(
            self,
            forKeyPath: "title",
            options: [NSKeyValueObservingOptions.new,NSKeyValueObservingOptions.old],
            context: nil
        )
    }
    
    //MARK: - 移除观察者,观察者的创建和移除一定要成对出现
    deinit{
        self.webView.removeObserver(self, forKeyPath: "estimatedProgress")
        self.webView.removeObserver(self, forKeyPath: "canGoBack")
        self.webView.removeObserver(self, forKeyPath: "title")
    }
}

extension GWKWebViewController {
    public override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            print("进度:", self.webView.estimatedProgress)
            self.navBackView.progress.alpha = 1.0
            self.navBackView.progress.setProgress(Float(self.webView.estimatedProgress), animated: true)
            if self.webView.estimatedProgress >= 1{
                UIView.animate(withDuration: 1.0, animations: {
                    self.navBackView.progress.alpha = 0
                }, completion: { (finished) in
                    self.navBackView.progress.setProgress(0.0, animated: false)
                })
            }
        }else if keyPath == "title" {
            self.navBackView.titleLabel.text = self.webView.title;
        }else if keyPath == "canGoBack" {
            self.navBackView.backButton.isHidden = !self.webView.canGoBack
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
}

extension GWKWebViewController : WKScriptMessageHandler {
    
    func configScriptHandler() {
       
//        view.addSubview(webView)
    }
    
    func callJS() {
        let jsonData = [
            "key1": "value1",
            "key2": "value2"
        ]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: jsonData, options: [])
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                let javaScriptString = "jsAction(\(jsonString))"
                webView.evaluateJavaScript(javaScriptString) { (result, error) in
                    if let error = error {
                        print("Failed to execute JavaScript: \(error)")
                    } else {
                        print("JavaScript execution result: \(String(describing: result))")
                    }
                }
            }
        } catch {
            print("Failed to convert JSON to string:", error)
        }
        
    }
    
    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "callbackHandler" {
            // 处理来自 JavaScript 的消息
            if let messageBody = message.body as? String {
                print("Received message from JavaScript: \(messageBody)")
                callJS()
            }
        }
    }
    
    
}


