//
//  ViewController.swift
//  CustomTableView
//
//  Created by Md Murad Hossain on 11/10/22.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    
    @IBOutlet weak var tableView: UITableView!
    
    let mydata = [
        "Facebook","HackerRank","Skype","Instagram","Twitter","YouTube","Linktree","LinkedIn","Definition of money","Taka is n't important"
    ]
    let myimage = [
        UIImage(named: "1"),
        UIImage(named: "2"),
        UIImage(named: "3"),
        UIImage(named: "4"),
        UIImage(named: "5"),
        UIImage(named: "6"),
        UIImage(named: "7"),
        UIImage(named: "8"),
        UIImage(named: "9"),
        UIImage(named: "10")
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib.init(nibName: "DemoTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "DemoTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    
    // Table View
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mydata.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DemoTableViewCell",for:indexPath) as! DemoTableViewCell
        
        cell.myimageview.image = myimage[indexPath.row]
        cell.mylabel.text =  mydata[indexPath.row]
        
        // eita kono text na nile lekha lage:
        //cell.textLabel?.text = mydata[indexPath.row]
        return cell
    }
    
    

}

