//
//  TalkCell.swift
//  kfvz-firebase2
//
//  Created by 馬馬桑 on 2019/6/5.
//  Copyright © 2019  kfvzfur. All rights reserved.
//

import UIKit

class TalkCell: UITableViewCell {

    @IBOutlet weak var btpraise: UIButton!
    @IBOutlet weak var btreply: UIButton!
    @IBOutlet weak var talkmessage: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var sticker: UIImageView!
    @IBOutlet weak var talklable2: UILabel!
    
    @IBOutlet weak var talkpraise: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
