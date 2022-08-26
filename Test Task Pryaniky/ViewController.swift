//
//  ViewController.swift
//  Test Task Pryaniky
//
//  Created by Egor Seleznev on 8/26/22.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var objectLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
//    var data: [DataViewModel] = [DataViewModel(name: "picture", cellData: ["text": "TextPic",
//                                                  "url": "https://pryaniky.com/static/img/logo-a-512.png"]),
//                                 DataViewModel(name: "hz", cellData: ["text": "TextText"]),
//                                 DataViewModel(name: "selector", cellData: ["selectedId": 2,
//                                                                            "variants": [["id": 1, "text": "Text1"],
//                                                                                         ["id": 2, "text": "Text2"],
//                                                                                         ["id": 3, "text": "Text3"]]
//                                                                           ])]
    var data: [DataViewModel] = []
    var order: [String] = []
    
    //MARK: - Did load
    override func viewDidLoad() {
        tableView.register(textCell.nib(), forCellReuseIdentifier: textCell.cellIdentifier)
        tableView.register(pictureCell.nib(), forCellReuseIdentifier: pictureCell.cellIdentifier)
        tableView.register(selectorCell.nib(), forCellReuseIdentifier: selectorCell.cellIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        let loadedData = loadData()
        order = loadedData.0
        data = []
        for orderElement in order {
            data.append(loadedData.1.first(where: {$0.name == orderElement})!)
        }
        
        super.viewDidLoad()
    }
    
    //MARK: - Load json
    
    func loadData() -> ([String], [DataViewModel]) {
        guard let url = URL(string: "https://pryaniky.com/static/json/sample.json") else { return ([], [])}
        
        var order: [String] = []
        var newData: [DataViewModel] = []
        var done = false
        let task = URLSession.shared.dataTask(with: url) { urlData, _, error in
            guard let urlData = urlData, error == nil else { return }
            
            do {
                if let data: [String: Any] = try? JSONSerialization.jsonObject(with: urlData) as? [String: Any] {
                    DispatchQueue.main.async {
                        order = data["view"] as! [String]
                        for elm in data["data"] as! [[String: Any]] {
                            let model = DataViewModel(name: elm["name"] as! String, cellData: elm["data"] as! [String : Any])
                            newData.append(model)
                        }
                        done = true
                    }
                }
            }
        }
        task.resume()
        
        repeat {
            RunLoop.current.run(until: Date(timeIntervalSinceNow: 0.1))
        } while !done
        return (order, newData)
    }
    
    func loadImage(urlString: String) -> UIImage {
        var image = UIImage()
        guard let url = URL(string: urlString) else { return image }
        
        var done = false
        let task = URLSession.shared.dataTask(with: url) { urlData, _, error in
            guard let urlData = urlData, error == nil else { return }
            DispatchQueue.main.async {
                image = UIImage(data: urlData)!
                done = true
            }
        }
        task.resume()
        
        repeat {
            RunLoop.current.run(until: Date(timeIntervalSinceNow: 0.1))
        } while !done
        return image
    }
    
    //MARK: - Table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let name = data[indexPath.row].name
        let viewModel = DataViewModel(name: name, cellData: data[indexPath.row].cellData)
        if name == "picture" {
            let cell = tableView.dequeueReusableCell(withIdentifier: pictureCell.cellIdentifier, for: indexPath) as! pictureCell
            
            cell.configure(with: viewModel, image: loadImage(urlString: viewModel.cellData["url"] as! String))
            return cell
        } else if name == "selector" {
            let cell = tableView.dequeueReusableCell(withIdentifier: selectorCell.cellIdentifier, for: indexPath) as! selectorCell
            cell.configure(with: viewModel, selectorElementDelegate: self)
            return cell
            
        } else if name == "hz" {
            let cell = tableView.dequeueReusableCell(withIdentifier: textCell.cellIdentifier, for: indexPath) as! textCell
            cell.configure(with: viewModel)
            
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        changeObjectName(newName: data[indexPath.row].name)
    }
    
    //MARK: - Label update
    
    func changeObjectName(newName: String) {
        objectLabel.text = "Object: \(newName)"
    }


}

struct DataViewModel {
    
    var name: String
    var cellData: [String: Any]
}

extension ViewController: PassData {
    func passData(passIndex: passIndex) {
        changeObjectName(newName: String(passIndex.index + 1))
    }
}
