//
//  SurahCustomTableViewCell.swift
//  Japanese Quran Translation
//
//  Created by Sow Moussa on 2018/01/05.
//  Copyright © 2018 Sow Moussa. All rights reserved.
//

import UIKit

class SurahCustomTableViewCell: UITableViewCell {

    @IBOutlet weak var surahImage: UIImageView!
    @IBOutlet weak var surahName: UILabel!
    @IBOutlet weak var durationTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
