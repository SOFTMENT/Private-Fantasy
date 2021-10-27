//
//  MenLingerieViewController.swift
//  private fantasy
//
//  Created by Apple on 13/10/21.
//

import UIKit
import WebKit

class MenAndWomenLingerieViewController : UIViewController, WKUIDelegate, WKNavigationDelegate {
    
    @IBOutlet weak var headTitle: UILabel!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var webView: WKWebView!
    var mTitle : String?
    override func viewDidLoad() {
        
        backView.layer.cornerRadius = 12
        backView.isUserInteractionEnabled = true
        backView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(backBtnClicked)))
        
        webView.uiDelegate  =  self
        webView.navigationDelegate = self
        progressBar.progress = 0.0
        progressBar.tintColor = UIColor.red
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        webView.addSubview(progressBar)
        
        headTitle.text = mTitle!

    }
    
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            self.progressBar.alpha = 1.0
            progressBar.setProgress(Float(webView.estimatedProgress), animated: true)
            if webView.estimatedProgress >= 1.0 {
                UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveEaseInOut, animations: {
                    self.progressBar.alpha = 0.0
                }) { (BOOL) in
                    self.progressBar.progress = 0
                }
                
            }
            
        }
    }
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if navigationAction.targetFrame == nil {
            webView.load(navigationAction.request)
        }
        return nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        var urls = URL(string: "https://www.studmeup.com.au/")
        if mTitle! == "Men Lingerie" {
            urls = URL(string: "https://www.studmeup.com.au/")
        }
        else {
            urls = URL(string: "https://elegantlyscant.com/")
        }
       
        let request = URLRequest(url: urls!)
        webView.load(request)
    }

    
    
    @objc func backBtnClicked(){
        self.dismiss(animated: true, completion: nil)
    }
    
}
