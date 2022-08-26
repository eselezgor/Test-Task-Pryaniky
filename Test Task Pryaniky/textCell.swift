//
//  textCell.swift
//  Test Task Pryaniky
//
//  Created by Egor Seleznev on 8/26/22.
//

import UIKit

class textCell: UITableViewCell {
    
    @IBOutlet weak var cellLabel: UILabel!
    
    static let cellIdentifier = "textCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "textCell", bundle: nil)
    }
    
    public func configure(with viewModel: DataViewModel) {
        if let text = viewModel.cellData["text"] as? String {
            cellLabel.text = text
        } else {
            cellLabel.text = viewModel.name
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
