//
//  AuthViewController.swift
//  Spofity
//
//  Created by Pallavi on 12/07/21.
//

import UIKit
import WebKit
class AuthViewController: UIViewController,WKNavigationDelegate {

    private let webview:WKWebView = {
        let prefe = WKWebpagePreferences()
        prefe.allowsContentJavaScript = true
        
        let config = WKWebViewConfiguration()
        config.defaultWebpagePreferences = prefe
        let webview = WKWebView(frame: .zero, configuration: config)
        return webview
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Sign In"
        view.backgroundColor = .systemBackground
        webview.navigationDelegate = self
        view.addSubview(webview)
    }
    override func viewDidLayoutSubviews() {
        webview.frame = view.bounds
    }
    


}
