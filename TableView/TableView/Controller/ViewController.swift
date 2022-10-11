//
//  ViewController.swift
//  TableView
//
//  Created by Md Murad Hossain on 11/10/22.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet var tableView: UITableView!
    
    let mydata = ["First","Second","Third","Four","Five","Six","Seven"]
    let myimage = [""]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib.init(nibName: "DataTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "DataTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
    }

    // Table View
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mydata.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DataTableViewCell",for:indexPath) as! DataTableViewCell
        
        cell.imageview.backgroundColor = .red
        cell.imagelabel.text =  mydata[indexPath.row]
        
        
        // eita kono text na nile lekha lage:
        //cell.textLabel?.text = mydata[indexPath.row]
        return cell
    }
}

