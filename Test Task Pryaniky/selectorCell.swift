//
//  selectorCell.swift
//  Test Task Pryaniky
//
//  Created by Egor Seleznev on 8/26/22.
//

import UIKit

class selectorCell: UITableViewCell, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet var selectorTableView: UITableView!
    var selectorElementDelegate: PassData?
    
    static let cellIdentifier = "selectorCell"
    
    var selectorData = [1: "txt1",
                        2: "txt2"]
    
    static func nib() -> UINib {
        return UINib(nibName: "selectorCell", bundle: nil)
    }
    
    public func configure(with viewModel: DataViewModel, selectorElementDelegate: PassData) {
        selectorTableView.delegate = self
        selectorTableView.dataSource = self
        selectorTableView.register(SelectorElementCell.nib(), forCellReuseIdentifier: SelectorElementCell.cellIdentifier)
        selectorData = [:]
        for variant in viewModel.cellData["variants"]! as! Array<[String:Any]> {
            selectorData[variant["id"] as! Int - 1] = variant["text"] as? String
        }
        if let selectedId = viewModel.cellData["selectedId"] as? Int {
            selectorTableView.selectRow(at: IndexPath(row: selectedId, section: 0), animated: false, scrollPosition: .none)
        }
        self.selectorElementDelegate = selectorElementDelegate
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK: - Table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectorData.count 
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = selectorTableView.dequeueReusableCell(withIdentifier: SelectorElementCell.cellIdentifier, for: indexPath) as! SelectorElementCell
        cell.delegate = selectorElementDelegate
        cell.configure(text: selectorData[indexPath.row] ?? "", index: indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
    }
    
}
