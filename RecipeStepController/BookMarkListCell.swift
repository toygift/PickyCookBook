//
//  BookMarkListCell.swift
//  RecipeStepController
//
//  Created by jaeseong on 2017. 8. 23..
//  Copyright © 2017년 sevenTeam. All rights reserved.
//

import UIKit

class BookMarkListCell: UITableViewCell {

    
    @IBOutlet var recipeTitle: UILabel!
    @IBOutlet var recipeMemo: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
