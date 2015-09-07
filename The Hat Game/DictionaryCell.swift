//
//  DictionaryCell.swift
//  The Hat
//
//  Created by Руслан Тхакохов on 26.07.15.
//  Copyright (c) 2015 Руслан Тхакохов. All rights reserved.
//

import UIKit

class DictionaryCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var difficultyLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
