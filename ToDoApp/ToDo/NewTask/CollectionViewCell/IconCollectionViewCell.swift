//
//  IconCollectionViewCell.swift
//  ToDoApp
//
//  Created by Bundid on 26/11/2565 BE.
//

import UIKit

class IconCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var iconView: UIView!
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var bullet: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        iconView.setCircle()
        bullet.setCircle()
    }
}
