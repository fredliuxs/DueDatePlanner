//
//  WhereAmIViewController.swift
//  DueDatePlanner
//
//  Created by Xusheng Liu on 5/12/20.
//  Copyright © 2020 Rose-Hulman. All rights reserved.
//

import UIKit
import GoogleMaps

class WhereAmINowViewController: UIViewController {

    let API_KEY = "AIzaSyDo9CGUwBnbfC6TYxJR8tVup89QwnuwgT0"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: <#T##CLLocationDegrees#>, zoom: <#T##Float#>)

        // Do any additional setup after loading the view.
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
