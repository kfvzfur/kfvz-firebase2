//
//  PhotoTableViewController.swift
//  kfvz-firebase2
//
//  Created by 馬馬桑 on 2019/5/21.
//  Copyright © 2019  kfvzfur. All rights reserved.
//

import UIKit
import Firebase
class PhotoTableViewController: UITableViewController{
    
    
    @IBOutlet var table: UITableView!
    
    @IBOutlet var activityIndicatorView: UIActivityIndicatorView!
    var messageid:String = ""
    var photos = [QueryDocumentSnapshot]()
    var mymessage:String = "1"
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//
//
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl = UIRefreshControl()
       // tblDemo.addSubview(refreshControl)
        
        getdata()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        return photos.count
        
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
    
    
    @IBAction func mypush(_ sender: Any) {
//        let db = Firestore.firestore()
//        db.collection("photos").order(by: "date", descending: true).getDocuments { (querySnapshot, error) in
//            if let querySnapshot = querySnapshot {
//
//                self.photos = querySnapshot.documents
//                DispatchQueue.main.async {
//
//                    self.table.beginUpdates()
//                    self.table.reloadRows(at: self.table.indexPathsForVisibleRows!, with: .none)
//                   self.table.endUpdates()
//                }
//            } else {
//                print("error")
//            }
//        }
//        getdata()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "mycell", for: indexPath) as! PhotoTableViewCell
        
        //messageid = reference.child(childRef.key)
        // Configure the cell...
        
        let photo = photos[indexPath.row]
      
              cell.photo2 = photo
        if let mytext = (photo.data()["message2"] as? String)?.components(separatedBy: "\t") {
            //print(table.frame.height)94
            if mytext.count < 4
                {
                table.rowHeight = CGFloat(349 + (mytext.count) * 44)
               }
             else{
            
                 table.rowHeight = 349 + 176
                 }
        } else{
            table.rowHeight = 349
            }
        
         cell.table2.reloadData()
        
        print("data", photo.data())
        messageid = photo.documentID
        cell.celllable.text = photo.data()["message"] as? String
        if let timeStamp = photo.data()["date"] as? Timestamp {
            
            let date =  Date(timeIntervalSince1970: TimeInterval(timeStamp.seconds))
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            formatter.timeStyle = .short
            cell.timelable.text = formatter.string(from: date)
        }
        
        cell.celphoto.image = nil
        if let urlString = photo.data()["photoUrl"] as? String {
            print("will fetch")
            fetchImage(url: URL(string: urlString)) { (image) in
                DispatchQueue.main.async {
                    if let currentIndexPath = tableView.indexPath(for: cell), currentIndexPath == indexPath {
                        cell.celphoto.image = image
                    }
                }
            }
            
            
        }
        // button
        //        cell.mypush.tag = indexPath.section*1000 + indexPath.row
        //        cell.mypush.addTarget(self, action: Selector(("mypush")), for: UIControl.Event.touchUpInside)
        //        mymessage = cell.mymessage.text!
        
        
        
        return cell
        
    }
    
    
  func getdata()
    {
        let db = Firestore.firestore()
        db.collection("photos").order(by: "date", descending: true).addSnapshotListener { (querySnapshot, error) in
            if let querySnapshot = querySnapshot {
                
                self.photos = querySnapshot.documents
                self.tableView.reloadData()
                
                
            } else {
                print("error")
            }
        }
    }
    /*
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
     
     // Configure the cell...
     
     return cell
     }
     */
    
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
