//
//  UPayWebViewController.swift
//  UPay
//
//  Created by 飞亦 on 6/12/19.
//  Copyright © 2019 飞亦. All rights reserved.
//

import UIKit
import JXFoundation
import WebKit

class UPayWebViewController: JXWkWebViewController {
    
    
    var urlStr: String?
    
    private var webUrl : URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.webView.backgroundColor = UIColor.clear
        
        self.webView.addObserver(self, forKeyPath: "title", options: .new, context: nil)
        self.webView.addObserver(self, forKeyPath: "URL", options: .new, context: nil)
      
        
        if
            let str = self.urlStr,
            let url = URL.init(string: str) {
            webUrl = url
            self.webView.load(URLRequest(url: url))
        } else {
            self.processView.alpha = 0.0
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //self.navigationController?.isNavigationBarHidden = false
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        
        if keyPath == "title" {
            //self.title = self.webView.title
            //            if  self.webView.title == "首页" {
            //                self.navigationItem.leftBarButtonItem = nil
            //            }else {
            //                self.title = self.webView.title;
            //                self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "nav_back"), style: .plain, target: self, action: #selector(goback))
            //            }
        }else if keyPath == "estimatedProgress"{
            if
                let change = change,
                let processValue = change[NSKeyValueChangeKey.newKey],
                let process = processValue as? Float{
                
                self.processView.setProgress(process, animated: true)//动画有延时，所以要等动画结束再隐藏
                if process == 1.0 {
                    //perform(<#T##aSelector: Selector##Selector#>, with: <#T##Any?#>, afterDelay: <#T##TimeInterval#>)
                    DispatchQueue.main.asyncAfter(wallDeadline: .now() + 0.25, execute: {
                        self.processView.alpha = 0.0
                    })
                }
            }
        }else if keyPath == "URL"{
            guard
                let change = change,
                let value = change[NSKeyValueChangeKey.newKey],
                let url = value as? URL else{
                    return
            }
            print("webview.url = " + (webView.url?.absoluteString)!)
            print("url = " + url.absoluteString)
            
            if webView.url?.absoluteString == webUrl?.absoluteString {
                //            self.navigationItem.leftBarButtonItem = nil
                print("首页")
                
            }else {
                //            self.title = self.webView.title;
                //            self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "nav_back"), style: .plain, target: self, action: #selector(goback))
                print("次级")
            }
        }
        
    }
    deinit {
        self.webView.removeObserver(self, forKeyPath: "title")
        self.webView.removeObserver(self, forKeyPath: "URL")
    }
    @objc func goback() {
        if self.webView.canGoBack {
            self.webView.goBack()
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc func loginStatus(notify:Notification) {
        print(notify)
        
        if let isSuccess = notify.object as? Bool,
            isSuccess == true,let url = webUrl{
            self.webView.load(URLRequest(url: url))
        }
    }
    override func requestData() {
        
        if let url = webUrl {
            self.webView.load(URLRequest(url: url))
        }
    }
}
extension UPayWebViewController {
    
    override func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        super.webView(webView, didStartProvisionalNavigation: navigation)
    }
    override func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        super.webView(webView, didCommit: navigation)
    }
    override func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        super.webView(webView, didFinish: navigation)
    }
    override func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        super.webView(webView, didFail: navigation, withError: error)
    }
}
extension UPayWebViewController {
    override func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print("message.name:",message.name)
        print("message.body:",message.body)
        guard let body = message.body as? String else {
            return
        }
        if message.name == "titleFn" {
            self.title = body
        } else if message.name == "copyFn" {
            if body == "true" {
                let pals = UIPasteboard.general
                pals.string = body
                ViewManager.showNotice("复制成功")
            }
        }
    }
}
