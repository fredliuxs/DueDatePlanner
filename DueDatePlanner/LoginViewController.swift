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
import FBSDKLoginKit

class LoginViewController: UIViewController, LoginButtonDelegate {
    
    let REGISTRY_TOKEN:String = "886c41b6-5a0c-4477-a724-b380e5541e7f"
    
    @IBOutlet weak var googleLoginButton: GIDSignInButton!
    @IBOutlet weak var loginStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        GIDSignIn.sharedInstance().presentingViewController = self
        googleLoginButton.style = .wide
        googleLoginButton.colorScheme = .dark
        
        let fbLoginButton = FBLoginButton()
        fbLoginButton.delegate = self
        fbLoginButton.center.x = self.view.center.x
        fbLoginButton.center.y = self.view.center.y + 20
        fbLoginButton.frame.size.height = 40
        self.view.addSubview(fbLoginButton)
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
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        if let error = error {
            print("error login with Facebook \(error)")
            return
        }
        //Do Something after Login
        if AccessToken.current == nil {
            return
        }
        let fbCredential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString)
        Auth.auth().signIn(with: fbCredential) { (authData, error) in
            if let error = error {
                print("Error during log in: \(error)")
                return
            } else {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                self.view.window!.rootViewController = storyboard.instantiateViewController(withIdentifier: "NavViewController")
            }
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        
    }
    
    @IBAction func pressedYahooLogin(_ sender: Any) {
        let githubProvider = OAuthProvider(providerID: "yahoo.com")
        let alertController = UIAlertController(title: "Login with Yahoo", message: "You are going to login with Yahoo, please confirm", preferredStyle: .alert)
        let continueAction = UIAlertAction(title: "Continue", style: .default) { (UIAlertAction) in
            // [START firebase_auth_github]
            githubProvider.getCredentialWith(_: nil){ (credential, error) in
                if let error = error {
                    print(error)
                    return
                }
                Auth.auth().signIn(with: credential!) {
                    (result, error) in
                    if let error = error {
                        print(error)
                        return
                    }
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    self.view.window!.rootViewController = storyboard.instantiateViewController(withIdentifier: "NavViewController")
                }
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        alertController.addAction(continueAction)
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func pressedGithubLogin(_ sender: Any) {
        let githubProvider = OAuthProvider(providerID: "github.com")
        let alertController = UIAlertController(title: "Login with Github", message: "You are going to login with Github, please confirm", preferredStyle: .alert)
        let continueAction = UIAlertAction(title: "Continue", style: .default) { (UIAlertAction) in
            // [START firebase_auth_github]
            githubProvider.getCredentialWith(_: nil){ (credential, error) in
                if let error = error {
                    print(error)
                    return
                }
                Auth.auth().signIn(with: credential!) {
                    (result, error) in
                    if let error = error {
                        print(error)
                        return
                    }
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    self.view.window!.rootViewController = storyboard.instantiateViewController(withIdentifier: "NavViewController")
                }
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        alertController.addAction(continueAction)
        present(alertController, animated: true, completion: nil)
    }
}


