//
//  RestaurantDetailViewController.swift
//  Travel++
//
//  Created by Tori Duguid on 4/27/22.
//

import WebKit
import UIKit

class RestaurantDetailViewController: UIViewController, WKNavigationDelegate {
    
    var webView: WKWebView!
    
    var restaurant: Restaurant?
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        let yelpUrl = restaurant?.url
        webView.load(URLRequest(url: yelpUrl!))
        webView.allowsBackForwardNavigationGestures = true
        
        
    }
}
