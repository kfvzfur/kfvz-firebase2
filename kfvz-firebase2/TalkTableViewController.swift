//
//  TalkTableViewController.swift
//  kfvz-firebase2
//
//  Created by 馬馬桑 on 2019/6/5.
//  Copyright © 2019  kfvzfur. All rights reserved.
//

import UIKit
import Firebase
class TalkTableViewController: UITableViewController {
    var userid = "PYsYWPoSxptd9dMeRgfr"
    var identify = 1
    
    @IBOutlet weak var tftalk: UITextField!
   
    
    
    @IBOutlet var talktableview: UITableView!
    
    var photo2:QueryDocumentSnapshot?
    var photo3:QueryDocumentSnapshot?
    var message2 = [QueryDocumentSnapshot]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        getdata()
        // print("真的是你\(photo3?.documentID)")
        
    }
    
    // MARK: - Table view data source
    
    @IBAction func mypush(_ sender: Any) {
        message2.removeAll()
        let db = Firestore.firestore()
        var message3:String
      
        message3 = tftalk.text!
        
        var identify2:String
        //  identify = (photo2!.data()["identify"] as? Int)!
        
        if identify == 1{
            identify2 = "Internet_Celebrity_ID"
        }else{
            identify2 = "Vendor_ID"
        }
        let data: [String: Any] = ["content": message3,identify2:userid,"Message_Time":Date(),"identify":identify,"Story_ID":photo2!.documentID]
        //  var photoReference: DocumentReference?
        //print("這次的id 是：\(messageid!)")
        
        db.collection("Message_Board").addDocument(data: data){ (error) in
            
            if let error = error {
                print(error)
            }
            self.tftalk.text = ""
            self.message2.removeAll()
           //self.tableView.reloadData()
            
            
        }
    
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if message2.isEmpty
        {
            return 0
        }else{
            return message2.count
        }
        
    }
    
    
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "talkcell2", for: indexPath) as! TalkCell
            let message = message2[indexPath.row]
            // Configure the cell  var identify:Int
            var identify2:String
            identify = (message.data()["identify"] as? Int)!
    
            if identify == 1{
                identify2 = "Internet_Celebrity_ID"
            }else{
                identify2 = "Vendor_ID"
            }
            let userid = message.data()[identify2] as? String
            // users.data("\(userid)")
            cell.talkmessage.text = message.data()["content"] as? String
            if let mytext = message.data()["content"] as? String {

               let x = mytext.count / 19
                 print("有：\(mytext.count)個，結果為：\(x)")


                   talktableview.rowHeight = CGFloat(75 + (x+1) * 15)

            }
            cell.sticker.image = nil
            let db = Firestore.firestore()
    
            db.collection("users").document(userid!).getDocument { (querySnapshot, error) in
                cell.username.text = (querySnapshot?.data()!["name"] as! String)
    
    
                if let urlString2 = querySnapshot?.data()!["sticker"] as? String {
                    print("will fetch")
                    self.fetchImage(url: URL(string: urlString2)) { (image) in
                        DispatchQueue.main.async {
                            if let currentIndexPath = tableView.indexPath(for: cell), currentIndexPath == indexPath {
                                cell.sticker.image = image
                            }
                        }
                    }
                }
            }
            return cell
        }
    
    func getdata()
    {
        let db = Firestore.firestore()
        db.collection("Message_Board").order(by: "Message_Time").addSnapshotListener{ (querySnapshot, error) in
            if let querySnapshot = querySnapshot {
                for i in querySnapshot.documents{
                    if i.data()["Story_ID"] as! String == self.photo2!.documentID
                    {
                        self.message2.append(i)
                        self.tableView.reloadData()
                    }
                }
                
            } else {
                print("error")
            }
        }
        
    }
    func fetchImage(url: URL?, completionHandler: @escaping (UIImage?) -> ()) {
        if let url = url {
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let data = data, let image = UIImage(data: data) {
                    completionHandler(image)
                } else {
                    completionHandler(nil)
                }
            }
            task.resume()
        }
    }
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
