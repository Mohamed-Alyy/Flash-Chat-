//
//  ChatViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import Firebase

// ===== Dealing with Data in Firestore =====
/// 1- Save Data (db.collection.addDocument)
/// 2- Query Data (db.collection.getDocumenst)
/// 3- Listening to updates Data
/// 4- Sort Data retrieved form Firestore

class ChatViewController: UIViewController {
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        // Register Xib for tableView
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        setUpUI()
        loadUpdatedMessagesFromeFirestore()
        
        
    }
    // MARK: - Variables
    
    let db = Firestore.firestore()
    
    var messages = [Messages]()
    
    // MARK: - iBAction
    
    @IBAction func sendPressed(_ sender: UIButton) {
        saveMessagesInFireStore()
    }
    
    
    @IBAction func logOutBtnPressed(_ sender: UIBarButtonItem) {
        logOut()
    }
    
    
    
    
    // MARK: - Helper Functions
    
    func setUpUI () {
        title = K.appName
        self.navigationItem.hidesBackButton = true
    }
    
    func logOut(){
        
        do{
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
        }catch{
            print(error)
        }
    }
    
    
    func saveMessagesInFireStore(){
        if let messaageBody = messageTextfield.text , let sendrMail = Auth.auth().currentUser?.email {
            db.collection(K.FStore.collectionName).addDocument(data: [
                K.FStore.senderField: sendrMail,
                K.FStore.bodyField: messaageBody,
                K.FStore.dateField: Date().timeIntervalSince1970
                
            ]) { error in
                if let err = error {
                    print("Fail to Save Data error: \(err)")
                } else {
                    self.messageTextfield.text = ""
                }
            }
        }
    }
    
    // get Messages without Updates form firestore
    func retriveMessagesFromFirestore(){
        db.collection(K.FStore.collectionName).order(by: K.FStore.dateField).getDocuments { dataSnapshot, error in
            self.messages = []
            if let err = error {
                print("Fail to retrive data: \(err)")
            } else {
                
                if let dataDocumens = dataSnapshot?.documents {
                    for doc in dataDocumens {
                        let data = doc.data()
                        
                        if let smsSender = data[K.FStore.senderField] as? String, let smsBody = data[K.FStore.bodyField] as? String {
                            let newMessage = Messages(sender: smsSender , smsBody: smsBody)
                            self.messages.append(newMessage)
                            
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                        }
                    }
                }
            }
        }
    }
    
    // get Messgaes and listening to updeate from firestore
    func loadUpdatedMessagesFromeFirestore () {
        db.collection(K.FStore.collectionName)
            .order(by: K.FStore.dateField)
            .addSnapshotListener { dataSnapshot, error in
                
            self.messages = []
            if let err = error {
                print("Fail to retrive data: \(err)")
            } else {
                if let dataDocumens = dataSnapshot?.documents {
                    for doc in dataDocumens {
                        let data = doc.data()
                        
                        if let smsSender = data[K.FStore.senderField] as? String, let smsBody = data[K.FStore.bodyField] as? String {
                            let newMessage = Messages(sender: smsSender , smsBody: smsBody)
                            self.messages.append(newMessage)
                        
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                        }
                    }
                }
            }
        }
    }
}




// MARK: - UITableView Delegate

extension ChatViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        messages.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! MessageCell
        cell.messageLBL.text = messages[indexPath.row].smsBody
        return cell
    }
    
    
}
