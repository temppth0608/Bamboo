//
//  GeneralTableViewCell.swift
//  Bamboo
//
//  Created by 김혜원 on 2016. 1. 18..
//  Copyright © 2016년 ParkTaeHyun. All rights reserved.
//

import UIKit

class GeneralTableViewCell: UITableViewCell {
    
    @IBOutlet weak var contents: UIButton!
    
    @IBOutlet weak var likeNum: UILabel!
    
    @IBOutlet weak var commentNum: UILabel!
    
    @IBOutlet weak var keywordFirst: UIButton!
    
    @IBOutlet weak var keywordSecond: UIButton!
    
    @IBOutlet weak var keywordThird: UIButton!
    @IBOutlet weak var likeImage: UIButton!
    
    @IBOutlet weak var backgroundImage: UIImageView!
        override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        likeImage.addTarget(self, action: #selector(GeneralTableViewCell.contentLikeFunc), forControlEvents: .TouchUpInside)
        // Configure the view for the selected state
    }
    
    func contentLikeFunc() {
        let image = UIImage(named: "like")
        let image2 = UIImage(named: "unlike")
        
        if likeImage.imageView?.image == image2 {
            likeImage.setImage(image, forState: .Normal)
            var tmp = Int(likeNum.text!)
            tmp! = tmp! + 1
            likeNum.text = "\(tmp!)"
        } else {
            likeImage.setImage(image2, forState: .Normal)
            var tmp = Int(likeNum.text!)
            tmp! = tmp! - 1
            likeNum.text = "\(tmp!)"
            
        }
        
    }
}
