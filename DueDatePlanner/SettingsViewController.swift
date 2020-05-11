//
//  SettingsViewController.swift
//  DueDatePlanner
//
//  Created by Xusheng Liu on 5/6/20.
//  Copyright © 2020 Rose-Hulman. All rights reserved.
//

import UIKit
import Firebase
import MessageUI

class SettingsViewController: UIViewController, MFMailComposeViewControllerDelegate {

    @IBOutlet weak var sendEmailBtn: UIButton!
    @IBOutlet weak var helloLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if Auth.auth().currentUser?.providerData.count != 0 {
            helloLabel.text = "Hello \(Auth.auth().currentUser!.providerData[0].displayName!)!"
        } else {
            helloLabel.text = "Hello \(Auth.auth().currentUser!.uid)!"
        }
        sendEmailBtn.isHidden = MFMailComposeViewController.canSendMail() ? true : false
    }
    

    @IBAction func pressedLogout(_ sender: Any) {
        do {
            try Auth.auth().signOut()
        } catch {
            print("Error on sign out: \(error)")
        }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        self.view.window!.rootViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
    }
    
    @IBAction func pressedSendEmail(_ sender: Any) {
        if MFMailComposeViewController.canSendMail() {
            let composeVC = MFMailComposeViewController()
            composeVC.mailComposeDelegate = self
                      
            // Present the view controller modally.
            self.present(composeVC, animated: true, completion: nil)
        }

    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
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
