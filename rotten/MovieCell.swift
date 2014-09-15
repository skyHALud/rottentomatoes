//
//  MovieCell.swift
//  rotten
//
//  Created by Swaroop Butala on 9/11/14.
//  Copyright (c) 2014 Swaroop Butala. All rights reserved.
//

import UIKit

class MovieCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var synopsisLabel: UILabel!
    @IBOutlet weak var posterView: UIImageView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var tomatoIconView: UIImageView!
    @IBOutlet weak var rottenScoreLabel: UILabel!
    
    var cellBackGroundColor: UIColor!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        if (selected) {
            self.cellBackGroundColor = self.backgroundColor
            self.backgroundColor = UIColor(red: 0.259, green: 0.259, blue: 0.259, alpha: 1.000)
        } else {
            self.backgroundColor = self.cellBackGroundColor
        }
    }
    
    override func setHighlighted(highlighted: Bool, animated: Bool) {
        if (highlighted) {
            self.backgroundColor = UIColor(red: 0.259, green: 0.259, blue: 0.259, alpha: 1.000)
        } else {
            self.backgroundColor = self.cellBackGroundColor
        }
    }
}
