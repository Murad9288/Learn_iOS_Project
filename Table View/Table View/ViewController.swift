//
//  ViewController.swift
//  Table View
//
//  Created by Md Murad Hossain on 6/8/22.
//

import UIKit


class ViewController: UIViewController ,UITableViewDataSource,UITableViewDelegate{

    var list_data = ["LinkedIn","Github","Youtube","Facebook","Swift","Twitter","Instagram","CodeChef","CodeForeces","HackerRank","HackerEarth","Toph"]
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list_data.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cell")
        cell.textLabel?.text = list_data[indexPath.row]
        return cell
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

