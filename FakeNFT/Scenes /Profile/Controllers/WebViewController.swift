//
// Created by Ruslan S. Shvetsov on 15.02.2024.
//

import UIKit
import WebKit

protocol WebViewProtocol: AnyObject, ErrorView, LoadingView {
    func loadWebPage(with url: URL)
    func backAction()
}

final class WebViewController: UIViewController {
    lazy var activityIndicator = UIActivityIndicatorView()

    private var webView: WKWebView?
    private let presenter: WebPresenter

    init(presenter: WebPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        webView?.navigationDelegate = self
        setupBackButton()
        setupLayout()
        presenter.viewDidLoad()
    }

    private func setupLayout() {
        view.addSubview(activityIndicator)
        activityIndicator.constraintCenters(to: view)
    }

    private func setupBackButton() {
        let config = UIImage.SymbolConfiguration(pointSize: 12, weight: .regular)
        let backImage = UIImage(systemName: "chevron.left", withConfiguration: config)?
                .withTintColor(UIColor.closeButton, renderingMode: .alwaysOriginal)
        let backButton = UIBarButtonItem(image: backImage, style: .plain, target: self, action: #selector(backAction))
        navigationItem.leftBarButtonItem = backButton

        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .systemBackground
            appearance.titleTextAttributes = [.foregroundColor: UIColor.closeButton]
            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
        } else {
            navigationController?.navigationBar.barTintColor = .systemBackground
            navigationController?.navigationBar.isTranslucent = false
            navigationController?.navigationBar.tintColor = UIColor.closeButton
        }
    }

    @objc func backAction() {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - WebViewProtocol

extension WebViewController: WebViewProtocol {
    func loadWebPage(with url: URL) {
        webView?.load(URLRequest(url: url))
    }
}

// MARK: - WKNavigationDelegate

extension WebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        print("Did commit to loading content")
    }

    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("Started loading")
    }

    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        print("Decide policy for navigation action")
        decisionHandler(.allow)
    }

    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        print("Redirected")
        if let url = webView.url {
            print("New URL after redirect: \(url)")
            presenter.didReceiveRedirect(to: url)
        }
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("Finished loading")
        presenter.pageDidFinishLoading()
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("Failed to load: \(error.localizedDescription)")
        presenter.pageDidFailLoading(withError: error)
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print("Failed to load with error: \(error.localizedDescription)")
        presenter.pageDidFailLoading(withError: error)
    }
}
