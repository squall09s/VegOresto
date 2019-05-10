//
//  CharteViewController.swift
//  VegOresto
//
//  Created by Micha Mazaheri on 11/8/17.
//  Copyright © 2017 Nicolas Laurent. All rights reserved.
//

import UIKit
import WebKit

class CharteViewController: UIViewController {

    @IBOutlet weak var contentView: UIView!
    var webView: WKWebView?
    
    override func viewDidAppear(_ animated: Bool) {
        addPDFView()
    }
    
    private func addPDFView() {
        guard self.webView == nil else {
            return
        }

        let webView = WKWebView(frame: contentView.bounds)
        webView.alpha = 0
        contentView.addSubview(webView)
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[webView]|", options: [], metrics: nil, views: ["webView":webView]))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[webView]|", options: [], metrics: nil, views: ["webView":webView]))
        
        let pdfData = try! Data(contentsOf: Bundle.main.url(forResource: "2017-02-VegOresto-Charte", withExtension: "pdf")!)
        webView.load(pdfData, mimeType: "application/pdf", characterEncodingName: "utf-8", baseURL: URL(string: "https://vegoresto.fr")!)

        UIView.animate(withDuration: 0.5, animations: {
            webView.alpha = 1.0
        })

        self.webView = webView
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func backButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
