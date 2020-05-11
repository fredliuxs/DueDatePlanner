//
//  MainTableViewController.swift
//  DueDatePlanner
//
//  Created by Xusheng Liu on 5/11/20.
//  Copyright © 2020 Rose-Hulman. All rights reserved.
//

import UIKit
import Firebase

class MainTableViewController: UITableViewController {
    
    let showSettingSegueIdentifier = "showSettingsSegue"
    let showCreateSegueIdentifier = "showCreateSegue"
    let noDueDateCellIdentifier = "noDueDateCell"
    let dueDateCellIdentifier = "dueDateCell"
    
    var authListenerHandle: AuthStateDidChangeListenerHandle!
    var dueDatesListener: ListenerRegistration!
    var dueDatesRef: CollectionReference!
    var allDueDates = [DueDate]()
    var orderBy: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Menu", style: .plain,target: self,action: #selector(self.presentMenu))
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        self.navigationItem.leftBarButtonItem?.tintColor = .white
        self.navigationItem.rightBarButtonItem?.tintColor = .white
        self.dueDatesRef = Firestore.firestore().collection("dueDates")
    }
    
    @objc func presentMenu(){
        let actionSheetController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        actionSheetController.addAction(UIAlertAction(title: "Settings", style: .default){
            (_) in
            self.performSegue(withIdentifier: self.showSettingSegueIdentifier, sender: self)
        })
        
        actionSheetController.addAction(UIAlertAction(title: "Create New", style: .default){
            (_) in
            self.performSegue(withIdentifier: self.showCreateSegueIdentifier, sender: self)
        })
        
        actionSheetController.addAction(UIAlertAction(title: "Sign Out",
                                                      style: .destructive)
        { (action) in
            do {
                try Auth.auth().signOut()
            } catch {
                print("Error on sign out: \(error.localizedDescription)")
            }
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            self.view.window!.rootViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
        })
        
        actionSheetController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(actionSheetController, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        authListenerHandle = Auth.auth().addStateDidChangeListener({ (auth, user) in
            if (Auth.auth().currentUser == nil){
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                self.view.window!.rootViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
                print("You messed up, there is no user. Go back to the login page")
            } else {
                print("You are signed in already! Stay on this page")
            }
        })
        self.startListening()
    }
    
    func startListening() {
        self.allDueDates.removeAll()
        if(self.dueDatesListener != nil){
            self.dueDatesListener.remove()
        }
        let query = self.dueDatesRef.order(by: self.orderBy ?? "dueDate", descending: true).limit(to: 50).whereField("author", isEqualTo: Auth.auth().currentUser?.uid as Any)
        self.dueDatesListener = query.addSnapshotListener { (snapshot, error) in
            if let error = error {
                print("Error fetching due dates \(error)")
                return
            }
            snapshot!.documentChanges.forEach({ (documentChanged) in
                if (documentChanged.type == .added){
                    print("Due Date Added")
                    self.allDueDates.append(DueDate(document: documentChanged.document))
                } else if (documentChanged.type == .modified){
                    print("Due Date Modified")
                    let modifiedDueDate = DueDate(document: documentChanged.document)
                    for dueDate in self.allDueDates {
                        if dueDate.id == modifiedDueDate.id {
                            dueDate.name = modifiedDueDate.name
                            dueDate.department = modifiedDueDate.department
                            dueDate.courseNumber = modifiedDueDate.courseNumber
                            dueDate.priorityLevel = modifiedDueDate.priorityLevel
                            dueDate.dueDate = modifiedDueDate.dueDate
                            break
                        }
                    }
                } else if (documentChanged.type == .removed){
                    print("Due Date Removed")
                    for i in 0..<self.allDueDates.count {
                        if self.allDueDates[i].id == documentChanged.document.documentID {
                            self.allDueDates.remove(at: i)
                            break
                        }
                    }
                }
                self.tableView.reloadData()
            })
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.dueDatesListener.remove()
        Auth.auth().removeStateDidChangeListener(authListenerHandle)
    }
    
    // MARK: - Table view data source
        
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return max(1, allDueDates.count)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : UITableViewCell
        
        if self.allDueDates.count == 0 {
            cell = tableView.dequeueReusableCell(withIdentifier: noDueDateCellIdentifier, for: indexPath) as UITableViewCell
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: dueDateCellIdentifier, for: indexPath) as UITableViewCell
            let dueDate = self.allDueDates[indexPath.row]
            var title = dueDate.name + "  "
            for _ in 0..<3 {
                title += "!"
            }
            cell.textLabel?.text = title
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/YYYY"
            dateFormatter.string(from: dueDate.dueDate.dateValue())
            cell.detailTextLabel?.text = "\(dueDate.department!) \(dueDate.courseNumber!)    \(dateFormatter.string(from: dueDate.dueDate!.dateValue()))"
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        if (self.allDueDates.count > 0) {
            let dueDate = self.allDueDates[indexPath.row]
            return (Auth.auth().currentUser?.uid == dueDate.author)
        }
        return false
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let dueDateToDelete = self.allDueDates[indexPath.row]
            dueDatesRef.document(dueDateToDelete.id!).delete()
        }
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
