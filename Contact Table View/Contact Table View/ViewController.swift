//
//  ViewController.swift
//  Contact Table View
//
//  Created by Md Murad Hossain on 8/8/22.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    
    let names = [
        "Murad",
        "Rana",
        "Mofajjol",
        "Fahim",
        "Imran",
        "Saberul",
        "Kashem",
        "Faysal",
        "Masud",
        "Masum",
        "Shuvo",
        "Kawsar",
        "Jalil",
        "Jony",
        "Saiful",
        "Sany",
        "Monir",
        "Jibon"
    
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }


}

extension ViewController: UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("you tapped me!")
    }
}

extension ViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return names.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = names[indexPath.row]
        return cell
    }
}
