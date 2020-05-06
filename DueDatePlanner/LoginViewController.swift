//
//  LoginViewController.swift
//  DueDatePlanner
//
//  Created by Xusheng Liu on 5/6/20.
//  Copyright © 2020 Rose-Hulman. All rights reserved.
//

import UIKit
import Rosefire
import Firebase
import GoogleSignIn

class LoginViewController: UIViewController {
    
    let REGISTRY_TOKEN:String = "886c41b6-5a0c-4477-a724-b380e5541e7f"
    
    @IBOutlet weak var googleLoginButton: GIDSignInButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        GIDSignIn.sharedInstance().presentingViewController = self
        googleLoginButton.style = .wide
        googleLoginButton.colorScheme = .dark
    }

    @IBAction func login(_ sender: Any) {
        Rosefire.sharedDelegate()?.uiDelegate = self
        Rosefire.sharedDelegate()?.signIn(registryToken: REGISTRY_TOKEN, withClosure: { (err, result) in
            if (err != nil){
                return;
            }
            Auth.auth().signIn(withCustomToken: result!.token) { (user, error) in
                if (err != nil){
                    print("\(String(describing: error))")
                }
                print("user login successful")
                // User Successfully Signed In
                self.showNavViewController()
            }
        })
    }
    
    func loginCompletionCallback(_ user: User?, _ error: Error?) {
        if let error = error {
            print("Error during log in: \(error.localizedDescription)")
            let ac = UIAlertController(title: "Login failed", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(ac, animated: true)
        } else {
            showNavViewController()
        }
    }
    
    func showNavViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        self.view.window!.rootViewController = storyboard.instantiateViewController(withIdentifier: "NavViewController")
    }
    
}

