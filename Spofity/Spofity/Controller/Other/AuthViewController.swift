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
    public var complicationHandler:((Bool) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Sign In"
        view.backgroundColor = .systemBackground
        webview.navigationDelegate = self
        view.addSubview(webview)
        
        guard let url = AuthManager.shared.signInurl else{
            return
        }
        webview.load(URLRequest(url: url))
    }
    override func viewDidLayoutSubviews() {
        webview.frame = view.bounds
    }
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        guard let url = webview.url else {
            return
        }
        // Exchange code for access token
        let componet = URLComponents(string: url.absoluteString)
      guard let code = componet?.queryItems?.first(where: {$0.name == "code"})?.value
        else {
            return
        }
        print("code:\(code)")
    }
    


}
