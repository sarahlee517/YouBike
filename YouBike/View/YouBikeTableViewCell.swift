//
//  YouBikeTableViewCell.swift
//  YouBike
//
//  Created by Sarah on 5/1/16.
//  Copyright © 2016 AppWorks School Sarah Lee. All rights reserved.
//

import UIKit

protocol CellDelegation: class {
    func cell(cell: YouBikeTableViewCell, viewMap sender: AnyObject!)
}

class YouBikeTableViewCell: UITableViewCell {
    
    weak var delegation: CellDelegation?
    
    var station = StationDatas()
    
    // MARK : properties
    @IBOutlet weak var stationNameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var availableNumLabel: UILabel!
    @IBOutlet weak var numLeftLabel: UILabel!
    @IBOutlet weak var numRightLabel: UILabel!
    @IBOutlet weak var separatorView: UIView!
    @IBOutlet weak var viewMapButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        setupCell()
        setupButton()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setupButton() {
        viewMapButton.backgroundColor = UIColor.clearColor()
        viewMapButton.setTitle(NSLocalizedString("viewMap", comment: ""), forState: UIControlState.Normal)
        viewMapButton.titleLabel!.adjustsFontSizeToFitWidth = true
        viewMapButton.titleLabel?.textAlignment = NSTextAlignment.Center
        viewMapButton.setTitleColor(UIColor.ybkDarkSalmonColor(), forState: UIControlState.Normal)
        viewMapButton.titleLabel?.font = UIFont.ybkTextStyle3Font(16)
        viewMapButton.layer.borderColor = UIColor.ybkDarkSalmonColor().CGColor
        viewMapButton.layer.cornerRadius = 4.0
        viewMapButton.layer.borderWidth = 1.0
        viewMapButton.addTarget(self, action: #selector(YouBikeTableViewCell.viewMap(_:)), forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    func setupCell() {
        tintColor = UIColor.ybkPaleColor()
        stationNameLabel.textColor = UIColor.ybkBrownishColor()
        locationLabel.textColor = UIColor.ybkSandBrownColor()
        availableNumLabel.textColor = UIColor.ybkDarkSalmonColor()
        numLeftLabel.textColor = UIColor.ybkSandBrownColor()
        numRightLabel.textColor = UIColor.ybkSandBrownColor()
        separatorView.backgroundColor = UIColor.ybkDarkSandColor()
        numLeftLabel.text = NSLocalizedString("numLeftLabel", comment: "")
        numRightLabel.text = NSLocalizedString("numRightLabel", comment: "")
        numRightLabel.sizeToFit()
        layoutMargins = UIEdgeInsetsZero
    }
    
    func viewMap(sender: UIButton) {
        delegation?.cell(self, viewMap: sender)
    }
    
    
}
