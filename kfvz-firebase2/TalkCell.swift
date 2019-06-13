//
//  TalkCell.swift
//  kfvz-firebase2
//
//  Created by 馬馬桑 on 2019/6/5.
//  Copyright © 2019  kfvzfur. All rights reserved.
//

import UIKit

class TalkCell: UITableViewCell,UITableViewDataSource,UITableViewDelegate {
   
    @IBOutlet weak var btpraise: UIButton!
    @IBOutlet weak var btreply: UIButton!
    @IBOutlet weak var talkmessage: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var sticker: UIImageView!
    
    
    @IBOutlet weak var talkpraise: UIButton!
    
    
    
    @IBOutlet weak var talktable2: UITableView!
    
    @IBOutlet weak var sticker2: UIImageView!
    
    @IBOutlet weak var username2: UILabel!
    
    @IBOutlet weak var Talkmessage2: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        talktable2.dataSource = self as UITableViewDataSource
        talktable2.delegate = self as UITableViewDelegate
        talktable2.reloadData()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
    


}
