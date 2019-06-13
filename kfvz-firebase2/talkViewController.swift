//
//  talkViewController.swift
//  kfvz-firebase2
//
//  Created by 馬馬桑 on 2019/6/12.
//  Copyright © 2019  kfvzfur. All rights reserved.
//

import UIKit
import Firebase
class talkViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    var userid = "lbp0Z3dATAdv4JGwybKG"
    var useridentify = 1
    var useridname = "Internet_Celebrity_ID"
    
    var photo2:QueryDocumentSnapshot?
    var photo3:QueryDocumentSnapshot?
    var message2 = [QueryDocumentSnapshot]()
     let db = Firestore.firestore()
    var praises2 = [QueryDocumentSnapshot]()
    var praise:QueryDocumentSnapshot?
     var praisesid = [String:String]()
    @IBOutlet weak var tftalk: UITextField!
    @IBOutlet weak var talktableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        getpraise(userid2: useridname)
        getdata()
    }

    @IBAction func mypush(_ sender: Any) {
        message2.removeAll()
        
        if let message3 = tftalk.text{
        var identify2:String

        if useridentify == 1{
            identify2 = "Internet_Celebrity_ID"
        }else{
            identify2 = "Vendor_ID"
        }
        let data: [String: Any] = ["content": message3,identify2:userid,"Message_Time":Date(),"identify":useridentify,"Story_ID":photo2!.documentID]
        db.collection("Message_Board").addDocument(data: data){ (error) in
            
            if let error = error {
                print(error)
            }
            self.tftalk.text = ""
            self.message2.removeAll()
           self.getdata()
            
            
            }
        }
    }
    
    
    @IBAction func talkpraise(_ sender: Any) {
    }
    
    
    
    func getdata()
    {
        db.collection("Message_Board").whereField("Story_ID", isEqualTo: self.photo2!.documentID).order(by: "Message_Time").addSnapshotListener{ (querySnapshot, error) in
            if let querySnapshot = querySnapshot {
                
                        self.message2 = querySnapshot.documents
                       self.talktableview.reloadData()
                

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
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
     func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if message2.isEmpty
        {
            return 0
        }else{
            return message2.count
        }
        
      }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "talkcell2", for: indexPath) as! TalkCell
        let message = message2[indexPath.row]
         var identify:Int
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
            
            
            talktableview.rowHeight = CGFloat(75 + (x+1) * 20)
            
        }
        cell.talkpraise.tag = indexPath.row
        cell.talkpraise.addTarget(self, action: #selector(click3(sender:)), for: .touchUpInside)
        
        if praises2.isEmpty{
            cell.talkpraise.setTitle("讚", for:.normal)
            print("那這裡咧")
            
        }else{
            //print("新的id\(getpraise(stroyid: photo.documentID, userid: useridname))")
            for i in praises2{
                if i.data()["MessageId"] as! String == message.documentID{
                    
                    //print("testP:\(praises[0].documentID)")
                    cell.talkpraise.setTitle("收回讚", for: .normal)
                    praisesid.updateValue(i.documentID, forKey: message.documentID)
                   // print("成功")
                    
                    break
                }
                else{
                    cell.talkpraise.setTitle("讚", for:.normal)
                }
            }
            
        }
        
        
        cell.sticker.image = nil
       
        
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
    @objc func click3(sender:UIButton){
        let Button = sender as UIButton
        let db = Firestore.firestore()
        var identify2:String
        //  identify = (photo2!.data()["identify"] as? Int)!
         let message = message2[sender.tag]
        
        if useridentify == 1{
            identify2 = "Internet_Celebrity_ID"
        }else{
            identify2 = "Vendor_ID"
        }
        //     == photo.documentID
        if let x = praisesid[message.documentID] {
            praisesid.removeValue(forKey:message.documentID)
            db.collection("Praise").document(x).delete() { err in
                if let err = err {
                    print("Error removing document: \(err)")
                } else {
                    print("Document successfully removed!")
                    
                }
            }
            Button.setTitle("讚", for: .normal)
        }else{
            
            let data: [String: Any] = [identify2:userid,"identify":useridentify,"MessageId":message.documentID,"Messageidentify":1]
            let ref = db.collection("Praise")
            let id = ref.document().documentID
            ref.document(id).setData(data){ (error) in
                
                if let error = error {
                    print(error)
                }
                
            }
            
            print("取到了：\(id)")
            praisesid.updateValue(id, forKey: message.documentID)
            Button.setTitle("收回讚", for: .normal)
            
        }
        
    }
    
    func getpraise(userid2:String){
        
        let db = Firestore.firestore()
        db.collection("Praise").whereField(useridname, isEqualTo: userid).whereField("Messageidentify", isEqualTo: 1).addSnapshotListener{ (querySnapshot, error) in
            if let querySnapshot = querySnapshot {
                
                self.praises2 = querySnapshot.documents
                
            } else {
                print("error")
                
            }
            
            }
        
        
        
        
    }
    
}
