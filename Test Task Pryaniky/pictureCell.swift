//
//  pictureCell.swift
//  Test Task Pryaniky
//
//  Created by Egor Seleznev on 8/26/22.
//

import UIKit

class pictureCell: UITableViewCell {

    @IBOutlet var cellLabel: UILabel!
    @IBOutlet var picture: UIImageView!
    
    static let cellIdentifier = "pictureCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "pictureCell", bundle: nil)
    }
    
    public func configure(with viewModel: DataViewModel, image: UIImage) {
        if let text = viewModel.cellData["text"] as? String {
            cellLabel.text = text
        } else {
            cellLabel.text = viewModel.name
        }
        picture.image = image
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
