//
//  StatViewController.swift
//  DueDatePlanner
//
//  Created by Xusheng Liu on 5/6/20.
//  Copyright © 2020 Rose-Hulman. All rights reserved.
//

import UIKit
import Firebase

class StatViewController: UIViewController {

    @IBOutlet weak var lateLabel: UILabel!
    @IBOutlet weak var notDueLabel: UILabel!
    var dueDatesListener: ListenerRegistration!
    var dueDatesRef: CollectionReference!
    var allDueDates = [DueDate]()
    var lateCount = 0
    var notDueCount = 0
    var total = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dueDatesRef = Firestore.firestore().collection("dueDates")
        let now = Timestamp.init()
        for dueDate in self.allDueDates{
            if dueDate.dueDate.compare(now) == .orderedDescending {
                self.notDueCount += 1
            } else {
                self.lateCount += 1
            }
        }
        self.total = self.notDueCount + self.lateCount
        lateLabel.text = "\(self.lateCount)/\(self.total) Late"
        notDueLabel.text = "\(self.notDueCount)/\(self.total) Not Due"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.startListening()
    }
    
    func startListening() {
        self.allDueDates.removeAll()
        if(self.dueDatesListener != nil){
            self.dueDatesListener.remove()
        }
        let query = self.dueDatesRef.whereField("author", isEqualTo: Auth.auth().currentUser!.uid)
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
            })
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.dueDatesListener.remove()
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
