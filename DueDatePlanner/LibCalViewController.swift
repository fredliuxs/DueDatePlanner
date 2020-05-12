//
//  libCalViewController.swift
//  DueDatePlanner
//
//  Created by Xusheng Liu on 5/12/20.
//  Copyright © 2020 Rose-Hulman. All rights reserved.
//

import UIKit
import WebKit

class LibCalViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let libcalUrl = URL(string: "https://rose-hulman.libcal.com/")!
        self.webView.load(URLRequest(url: libcalUrl))
        self.webView.allowsBackForwardNavigationGestures = true
        self.webView.allowsLinkPreview = true
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
