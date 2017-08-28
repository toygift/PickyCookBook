//
//  MainPageCollectionViewCell.swift
//  PickyCookBook
//
//  Created by ParkGuy on 2017. 8. 9..
//  Copyright © 2017년 유하늘. All rights reserved.
//

import UIKit

class MainPageCell: UICollectionViewCell {
    
    @IBOutlet weak var recipesTitle: UILabel!
    @IBOutlet weak var likeNum: UILabel!
    @IBOutlet weak var recipesImage: UIImageView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        recipesImage.image = UIImage(named: "1.jpg")
    }
    
    
    
    @IBAction func likeButton(_ sender: Any) {
        
    }
    
    @IBAction func bookMarkButton(_ sender: Any) {
        
    }
    
}
