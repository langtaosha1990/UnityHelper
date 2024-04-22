//
//  WKWebNavBackView.swift
//  SwiftTestDemo
//
//  Created by Gpf 郭 on 2024/4/21.
//
import UIKit
open class GWKWebNavBackView: UIView {
    lazy var dismissBtn:UIButton = {
        let btn = UIButton(type: .system)
        btn.frame = CGRectMake(WKWebviewControllerScreenWidth - 80, WKWebviewControllerStatusBarHeight + 10, 50, 30)
        btn.setTitle("Done", for: .normal)
        return btn
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.frame = CGRectMake(80, WKWebviewControllerStatusBarHeight + 10, WKWebviewControllerScreenWidth - 160, 30)
        label.textAlignment = .center
        return label
    }()
    
    lazy var backButton:UIButton = {
        let btn = UIButton(type: .system)
        btn.frame = CGRectMake(20, WKWebviewControllerStatusBarHeight + 10, 50, 30)
        btn.setTitle("Back", for: .normal)
        return btn
    }()
    lazy var progress: UIProgressView = {
        let rect:CGRect = CGRect.init(x: 0, y: WKWebviewControllerTopHeight - 2, width: WKWebviewControllerScreenWidth, height: 2.0)
        let tempProgressView = UIProgressView.init(frame: rect)
        tempProgressView.tintColor = UIColor.red
        tempProgressView.backgroundColor = UIColor.gray
        return tempProgressView
    }()
    
    override init(frame: CGRect) {
          super.init(frame: frame)
          // 在这里添加自定义的初始化逻辑
        addSubview(dismissBtn)
        addSubview(titleLabel)
        addSubview(backButton)
        addSubview(progress)
      }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

