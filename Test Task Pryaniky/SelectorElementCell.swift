//
//  SelectorElementCell.swift
//  Test Task Pryaniky
//
//  Created by Egor Seleznev on 8/26/22.
//

import UIKit

class SelectorElementCell: UITableViewCell {

    static let cellIdentifier = "SelectorElementCell"
    
    var delegate: PassData?
    var index: Int = 0
    
    static func nib() -> UINib {
        return UINib(nibName: "SelectorElementCell", bundle: nil)
    }
    
    @IBOutlet var selectorLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(text: String, index: Int) {
        selectorLabel.text = text
        selectorLabel.numberOfLines = 1
        selectorLabel.adjustsFontSizeToFitWidth = true
        self.index = index
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        if self.isSelected == selected { return }
        super.setSelected(selected, animated: animated)
        delegate?.passData(passIndex: passIndex(index: index))
    }
    
}

//MARK: - Pass index

struct passIndex {
    var index: Int
}

protocol PassData {
    func passData(passIndex: passIndex)
}
