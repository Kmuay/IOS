//
//  GoodsTableViewCell.swift
//  ShoppingList
//
//  Created by nju on 2020/11/14.
//

import UIKit

class GoodsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var photoimage: UIImageView!
    @IBOutlet weak var namelabel: UILabel!
    @IBOutlet weak var ratingcontrol: RatingControl!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
