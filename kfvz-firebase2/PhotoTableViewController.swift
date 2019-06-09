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
    var userid = "lbp0Z3dATAdv4JGwybKG"
    
    @IBOutlet var table: UITableView!
    
    @IBOutlet var activityIndicatorView: UIActivityIndicatorView!
    var messageid:String = ""
    var photos = [QueryDocumentSnapshot]()
    var photo3:QueryDocumentSnapshot?
   var users = [QueryDocumentSnapshot]()
    var mymessage:String = ""
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//
//
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl = UIRefreshControl()
       // tblDemo.addSubview(refreshControl)
       // print("本頁id\(photo3?.documentID)")
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
    
    
    var index = 0
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "mycell", for: indexPath) as! PhotoTableViewCell
        
        //messageid = reference.child(childRef.key)
        // Configure the cell...
        
        let photo = photos[indexPath.row]
        index = indexPath.row
           photo3 = photo
              cell.photo2 = photo
        if let mytext = (photo.data()["message2"] as? String)?.components(separatedBy: "\t") {
            //print(table.frame.height)94
            if mytext.count < 4
                {
                table.rowHeight = CGFloat(359 + (mytext.count) * 44)
               }
             else{
            
                 table.rowHeight = 369 + 176
                 }
        } else{
            table.rowHeight = 400
            }
        cell.table2.reloadData()
         
        
        print("data", photo.data())
        var identify:Int
        var identify2:String
        identify = (photo.data()["identify"] as? Int)!
       
        if identify == 1{
                identify2 = "Internet_Celebrity_ID"
            }else{
                identify2 = "Vendor_ID"
            }
        let userid = photo.data()[identify2] as? String
       // users.data("\(userid)")
        let db = Firestore.firestore()
        cell.userpicture.image = nil
        db.collection("users").document(userid!).getDocument { (querySnapshot, error) in
            cell.username.text = (querySnapshot?.data()!["name"] as! String)
            

            if let urlString2 = querySnapshot?.data()!["sticker"] as? String {
                print("will fetch")
                self.fetchImage(url: URL(string: urlString2)) { (image) in
                    DispatchQueue.main.async {
                        if let currentIndexPath = tableView.indexPath(for: cell), currentIndexPath == indexPath {
                            cell.userpicture.image = image
                        }
                    }
                }
            }
        }
        cell.btpush.tag = indexPath.row
       cell.btpush.addTarget(self, action: #selector(click(sender:)), for: .touchUpInside)
       //print ("測式：\(users.count)")
        cell.celllable.text = photo.data()["Post_Content"] as? String
        if let timeStamp = photo.data()["date"] as? Timestamp {
            
            let date =  Date(timeIntervalSince1970: TimeInterval(timeStamp.seconds))
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            formatter.timeStyle = .short
            cell.timelable.text = formatter.string(from: date)
        }
        
        cell.celphoto.image = nil
        if let urlString = photo.data()["Picture"] as? String {
            print("will fetch")
            self.fetchImage(url: URL(string: urlString)) { (image) in
                DispatchQueue.main.async {
                    if let currentIndexPath = tableView.indexPath(for: cell), currentIndexPath == indexPath {
                        cell.celphoto.image = image
                    }
                }
            }
            
            
        }
    
        
        return cell
        
    }
    @objc func click(sender:UIButton){
        
       // let indexpath = IndexPath(row: index, section: 0)
        let photo = photos[sender.tag]

       //let cell = tableView.cellForRow(at: indexpath) as! PhotoTableViewCell
        let talkTableViewController = storyboard?.instantiateViewController(withIdentifier:"TalkTableViewController") as! TalkTableViewController
       // let talkTableViewController2 = UIStoryboard
       // cell.photo2 = (photo3![indexpath] as! QueryDocumentSnapshot)
        talkTableViewController.photo3 = photo
        
        print("cell的id：\(talkTableViewController.photo3?.documentID)")
    }
    
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let tag = sender as! Int
//        let controller = segue.destination as! TalkTableViewController
//        controller.photo3 = photos[tag]
//        
//    }
//
//        }
//    }
    
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        performSegue(withIdentifier: "testyou", sender: self)
//    }
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "testyou"{
//            if let indexPath = tableView.indexPathForSelectedRow{
//                let eng = segue.destination as! TalkTableViewController
//                eng.photo3 = photos[indexPath.row]
//            }
//        }
//        let photo = photos[indexPath!.row]
//        print(photo.documentID)
//        let VC = segue.destination as! TalkTableViewController
//        VC.photo2 = photo
        
//    }
    
  func getdata()
    {
        let db = Firestore.firestore()
        db.collection("News_Feed").order(by: "date", descending: true).addSnapshotListener{ (querySnapshot, error) in
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
