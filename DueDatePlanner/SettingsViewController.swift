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
import FBSDKLoginKit

class SettingsViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    let showStatSegueIdentifier = "showStatSegue"
    
    @IBOutlet weak var sendEmailBtn: UIButton!
    @IBOutlet weak var helloLabel: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var spinnerStackView: UIStackView!
    
    var allDueDates = [DueDate]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if Auth.auth().currentUser?.providerData.count != 0 {
            helloLabel.text = "Hello \(Auth.auth().currentUser!.providerData[0].displayName!)!"
        } else {
            helloLabel.text = "Hello \(Auth.auth().currentUser!.uid)!"
        }
        sendEmailBtn.isHidden = MFMailComposeViewController.canSendMail() ? false : true
        let imgString = self.getRandomImageUrl()
        if let imgUrl = URL(string: imgString) {
            DispatchQueue.global().async { // Download in the background
                do {
                    let data = try Data(contentsOf: imgUrl)
                    DispatchQueue.main.async { // Then update on main thread
                        self.imgView.image = UIImage(data: data)
                        self.spinnerStackView.isHidden = true
                        self.imgView.backgroundColor = .white
                    }
                } catch {
                    print("Error downloading image: \(error)")
                }
            }
        }
    }
    
    func getRandomImageUrl() -> String {
        let testImages = ["https://i.pinimg.com/236x/c5/32/0b/c5320b986c4f874d9c0aed1ff2d9d446.jpg",
                          "https://i.pinimg.com/236x/b3/89/40/b3894065a1024675370f27ee6c6b7205.jpg",
                          "https://upload.wikimedia.org/wikipedia/en/thumb/e/ed/Rose%E2%80%93Hulman_Institute_of_Technology_seal.svg/1200px-Rose%E2%80%93Hulman_Institute_of_Technology_seal.svg.png",
                          "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcSBYiY0ATDyzqU7v1EME0zFuDo-WjwLQxm1Ie45hPu-tKwFnykT&usqp=CAU",
                          "https://www.rose-hulman.edu/about-us/community-and-public-services/sports-and-recreation-center/_assets/images/Basic-Block-2-and-3-Column/SRC-CCR-UP-Campus_SRC_Fall-19803.jpg",
                          "https://scontent-lga3-1.xx.fbcdn.net/v/t1.0-9/13315384_546822312164039_8345425966917196037_n.jpg?_nc_cat=102&_nc_sid=dd9801&_nc_ohc=FjSnijl57rUAX9MwDNA&_nc_ht=scontent-lga3-1.xx&oh=1a4c567224d5664e82184a9a8d9f3d5a&oe=5EDFBE03",
                          "https://scontent-lga3-1.xx.fbcdn.net/v/t1.0-9/12728842_507459596100311_6580929277128929733_n.jpg?_nc_cat=102&_nc_sid=05277f&_nc_ohc=D8F5OARZOEwAX8UnEA_&_nc_ht=scontent-lga3-1.xx&oh=b30db66428ea5c1a6491f64be5c1a924&oe=5EDE4C33",
                          "https://www.rose-hulman.edu/visit/_assets/images/Image-Top-Carousel/Visit-C-top-Photo-Campus_Olin.jpg",
                          "https://i2.wp.com/charlestowncourier.com/wp-content/uploads/2019/02/Rose.jpg?resize=639%2C426&ssl=1",
                          "https://www.rose-hulman.edu/visit/campus-facilities/_assets/images/Image-Top-Carousel/White_Chapel-C-top-Campus_White_Chapel-29449.jpg",
                          "https://scholar.rose-hulman.edu/slideshow/1022/preview.jpg",
                          "https://theaitu.com/wp-content/uploads/2017/11/Rose.jpg",
                          "https://www.rose-hulman.edu/visit/_assets/images/Image-Top-Carousel/Visit-C-top-Photo-16-Campus_Spring-24948.jpg",
                          "https://www.ratiodesign.com/sites/default/files/styles/detail_full_header/public/project/large/RHIT%20Lakeside%20header%20large.jpg?itok=J6D5l6Zm",
                          
        ]
        let randomIndex = Int(arc4random_uniform(UInt32(testImages.count)))
        return testImages[randomIndex];
    }
    
    
    @IBAction func pressedLogout(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            let loginManager = LoginManager()
            loginManager.logOut()
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
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
        if segue.identifier == "showStatSegue" {
            
        }
        if segue.identifier == showStatSegueIdentifier {
            (segue.destination as! StatViewController).allDueDates = self.allDueDates
        }
     }
     
    
}
