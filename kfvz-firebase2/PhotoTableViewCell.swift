//
//  PhotoTableViewCell.swift
//  kfvz-firebase2
//
//  Created by 馬馬桑 on 2019/5/21.
//  Copyright © 2019  kfvzfur. All rights reserved.
//

import UIKit
import Firebase
class PhotoTableViewCell: UITableViewCell,UITableViewDataSource,UITableViewDelegate {
    
    
    @IBOutlet weak var userpicture: UIImageView!
    
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var table2: UITableView!
    @IBOutlet weak var timelable: UILabel!
    @IBOutlet weak var celllable: UILabel!
    @IBOutlet weak var celphoto: UIImageView!
    
    
    @IBOutlet weak var praiselable: UIButton!
    
    @IBOutlet weak var mymessage: UITextField!
    
    @IBOutlet weak var mypush: UIButton!
    
    var photo2:QueryDocumentSnapshot?
    var mytext = [String]()
    let db = Firestore.firestore()
      var myindex:IndexPath?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        table2.dataSource = self as UITableViewDataSource
        table2.delegate = self as UITableViewDelegate
        table2.reloadData()
    }
    
    
    @IBAction func testpush(_ sender: Any) {
//        print("本頁：\(photo2!.documentID)")
    }
    
    
    
    @IBAction func mypush(_ sender: Any) {
        
        //activityIndicatorView.startAnimating()
        var message3:String
        // messageid = photo2.documentID
        let messageid = photo2?.documentID
      
        message3 = (photo2?.data()["message2"] as? String) ?? ""
        message3 += mymessage.text! + "\t"
        mytext.append(mymessage.text!)
        let data: [String: Any] = ["message2": message3]
        //  var photoReference: DocumentReference?
        print("這次的id 是：\(messageid!)")
        
        db.collection("News_Feed").document(messageid!).updateData(data){ (error) in
            
            if let error = error {
                print(error)
            }
            self.mymessage.text = ""
            
           self.table2.reloadData()
          //  table2.reloadRows(at: [IndexPath], with: .fade)
           // self.table2.cellForRow(at: myindex)
         //   table2.reloadRows(at: myindex, with: .automatic)
//           table2.reloadRows(at: , with: <#T##UITableView.RowAnimation#>)
        }
       
        
    }
    
 
    @IBOutlet weak var btpush: UIButton!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let message3 = photo2?.data()["message2"] as? String{
            mytext = message3.components(separatedBy: "\t")
            print("有幾個陣列\(mytext.count)")
            return mytext.count
        } else {
            return 0
        }
        
        
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "talkcell", for: indexPath) as! Talkcellcontroller
          //cell.renderCell(info: dataSource[indexPath.row])
    
        
        
        
//        if mytext.count >= 1
//        {
//          cell.isHidden = false
//         
//           
//               let text = mytext[indexPath.row]
//            myindex = indexPath
//                  cell.messagelable.text = text
//                  return cell
//        }else{
////            cell.isHidden = true
////            table2.rowHeight = 0
//        }
//       cell.reloadInputViews()
        return cell
    }
    //
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}
