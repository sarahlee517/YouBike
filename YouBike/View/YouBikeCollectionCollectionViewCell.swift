//
//  YouBikeCollectionCollectionViewCell.swift
//  YouBike
//
//  Created by Sarah on 5/17/16.
//  Copyright © 2016 AppWorks School Sarah Lee. All rights reserved.
//

import UIKit

class YouBikeCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var YBAvailableLabel: UILabel!
    @IBOutlet weak var YBSeperator: UIView!
    @IBOutlet weak var YBStationLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCell()
        // Initialization code
    }
    
    func setupCell() {
        
        YBAvailableLabel.textColor = UIColor.ybkDarkSalmonColor()
        YBAvailableLabel.font = UIFont.ybkTextStyleFont(80)
        YBStationLabel.textColor = UIColor.ybkBrownishColor()
        YBStationLabel.font = UIFont.ybkTextStyle2Font(14)
        YBSeperator.backgroundColor = UIColor.ybkSandBrownColor()
//        layoutMargins = UIEdgeInsetsZero
    }

    
}
