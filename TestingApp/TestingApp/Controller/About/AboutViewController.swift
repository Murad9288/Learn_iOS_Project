//
//  AboutViewController.swift
//  TestingApp
//
//  Created by Md Hosne Mobarok on 5/7/22.
//

import UIKit

class AboutViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var nameArr = ["a", "b", "c", "d"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
    }
    
    // MARK: - Private methods.
    func setupTableView() {
        let nib = UINib(nibName: "TableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "cell")
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    // MARK: - Button Action.
    

}

extension AboutViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameArr.count /// name arr len
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        cell.nameLable.text = nameArr[indexPath.row] /// name arr index value shwo nameLabel UILabel
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Your selected cell index:::: \(indexPath.row)")
        
        print("Yout selected cell index value :::: \(nameArr[indexPath.row])")
    }
    
}
