//
//  CameraViewModel.swift
//  XinyangTestApp
//
//  Created by 张新杨 on 2025/3/13.
//

import SwiftUI
import WebKit

struct CameraViewModel: UIViewRepresentable {
    let urlString: String
    
    func makeUIView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        config.websiteDataStore = WKWebsiteDataStore.default()
        config.allowsInlineMediaPlayback = true
        config.mediaTypesRequiringUserActionForPlayback = []
        
        let webView = WKWebView(frame: .zero, configuration: config)
        webView.isOpaque = false
        webView.backgroundColor = .clear
        webView.scrollView.isScrollEnabled = false
        webView.loadHTMLString("<h1 style='text-align:center;'>Loading...</h1>", baseURL: nil)

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if let url = URL(string: urlString) {
                webView.load(URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 5))
            }
        }
        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        if webView.url?.absoluteString != urlString {
            webView.load(URLRequest(url: URL(string: urlString)!))
        }
    }
}


