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
    var useridentify = 1
    var useridname = "Internet_Celebrity_ID"
    @IBOutlet var table: UITableView!
    var data1IsGet = false
    var data2IsGet = false
  
    
    
    @IBOutlet var activityIndicatorView: UIActivityIndicatorView!
    var messageid:String = ""
    var photos = [QueryDocumentSnapshot]()
    var users = [QueryDocumentSnapshot]()
    var praises = [QueryDocumentSnapshot]()
    var praise:QueryDocumentSnapshot?
    var mymessage = ""
    var praisemessage = [String]()
    var praisesid = [String:String]()
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
        //getdata()
        getpraise(userid2: userid)
        getdata()
        //tableView.reloadData()
    
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
      //  if data1IsGet == true && data2IsGet == true{
            
        
        var identify:Int
        var identify2:String
        let photo = photos[indexPath.row]
       
        index = indexPath.row
       // cell.photo2 = photo
        
            table.rowHeight = 400
        
        //cell.table2.reloadData()
        
        
      
       //抓取message哪位使用者的id記錄
        identify = (photo.data()["identify"] as? Int)!
        
        if identify == 1{
            identify2 = "Internet_Celebrity_ID"
        }else{
            identify2 = "Vendor_ID"
        }
        let userid2 = photo.data()[identify2] as? String
        // users.data("\(userid)")
        let db = Firestore.firestore()
        cell.userpicture.image = nil
        db.collection("users").document(userid2!).getDocument { (querySnapshot, error) in
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
        cell.praiselable.tag = indexPath.row
        cell.praiselable.addTarget(self, action: #selector(click2(sender:)), for: .touchUpInside)
        
        
        
       print("目標：\(photo.documentID)")
        //print("test:\(photos[0].documentID)")
    // getpraise(stroyid: photo.documentID, userid: useridname)
        
        //print("testP:\(praises![0].documentID)")
        if praises.isEmpty{
                        cell.praiselable.setTitle("讚", for:.normal)
                        print("那這裡咧")
                       
                    }else{
                      //print("新的id\(getpraise(stroyid: photo.documentID, userid: useridname))")
            for i in praises{
                //print("神奇\(i.data()["Story_ID"] as! String)")
                if i.data()["Story_ID"] as! String == photo.documentID{

                        //print("testP:\(praises[0].documentID)")
                        cell.praiselable.setTitle("收回讚", for: .normal)
                        praisesid.updateValue(i.documentID, forKey: photo.documentID)
                        print("成功")

                    break
                   }
               else{
                 cell.praiselable.setTitle("讚", for:.normal)
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
        
        
       // }
        return cell
        
    }
   @objc func click2(sender:UIButton){
   let Button = sender as UIButton
    let db = Firestore.firestore()
     let photo = photos[sender.tag]
    var identify2:String
    //  identify = (photo2!.data()["identify"] as? Int)!
    
    if useridentify == 1{
        identify2 = "Internet_Celebrity_ID"
    }else{
        identify2 = "Vendor_ID"
    }
//     == photo.documentID
    if let x = praisesid[photo.documentID] {
       praisesid.removeValue(forKey:photo.documentID)
        db.collection("Praise").document(x).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
                
            }
        }
       Button.setTitle("讚", for: .normal)
    }else{
        
        let data: [String: Any] = [identify2:userid,"identify":useridentify,"Story_ID":photo.documentID,"Messageidentify":0]
        let ref = db.collection("Praise")
        let id = ref.document().documentID
    ref.document(id).setData(data){ (error) in
        
        if let error = error {
            print(error)
          }
        
      }
        
        print("取到了：\(id)")
         praisesid.updateValue(id, forKey: photo.documentID)
        Button.setTitle("收回讚", for: .normal)
        
    }
    
}
    @objc func click(sender:UIButton){
        
        
        let photo = photos[sender.tag]
        let talkTableViewController = storyboard?.instantiateViewController(withIdentifier:"talkViewController") as! talkViewController
        //不拉線直接傳值
        navigationController?.pushViewController(talkTableViewController, animated: true)
       
        talkTableViewController.photo2 = photo
        
       // print("cell的id：\(talkTableViewController.photo2?.documentID)")
    }
    
    
   
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
          //  self.data1IsGet = true
        }
       
    }
    func getpraise(userid2:String){
        
        let db = Firestore.firestore()
        db.collection("Praise").whereField(useridname, isEqualTo: userid2).whereField("Messageidentify", isEqualTo: 0).addSnapshotListener{ (querySnapshot, error) in
            if let querySnapshot = querySnapshot {

               self.praises = querySnapshot.documents
                
            } else {
                print("error")
              
            }
            //self.data2IsGet = true
            
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
