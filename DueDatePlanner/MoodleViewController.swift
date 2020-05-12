//
//  MoodleViewController.swift
//  DueDatePlanner
//
//  Created by Xusheng Liu on 5/12/20.
//  Copyright © 2020 Rose-Hulman. All rights reserved.
//

import UIKit
import WebKit

class MoodleViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let moodleURL = URL(string: "https://moodle.rose-hulman.edu/")!
        self.webView.load(URLRequest(url: moodleURL))
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
