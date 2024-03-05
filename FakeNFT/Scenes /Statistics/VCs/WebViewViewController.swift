//
//  WebViewViewController.swift
//  FakeNFT
//
//  Created by Александр Медведев on 23.02.2024.
//

import UIKit
import WebKit

final class WebViewViewController: UIViewController, WKUIDelegate {

    private var userWebsite: String

    private lazy var webView: WKWebView = {
        let webView = WKWebView()
        webView.uiDelegate = self
        return webView
    }()

    init(userWebsite: String) {
        self.userWebsite = userWebsite
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .figmaWhite

        setupUI()
        setupLayout()
        makeURLloadRequest()
    }

    private func setupUI() {
        [webView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }

    private func makeURLloadRequest() {
        guard let url = URL(string: userWebsite) else {
            print("Invalid URL")
            return
        }

        let request = URLRequest(url: url)
        webView.load(request)
    }
}
