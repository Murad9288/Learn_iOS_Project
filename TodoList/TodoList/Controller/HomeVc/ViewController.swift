//
//  ViewController.swift
//  TodoList
//
//  Created by Md Murad Hossain on 11/10/22.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableveiw: UITableView!
    
    var todoArr = [Data]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        todoArr = [
            Data(profileName: "Facebook", avatar: UIImage(named: "1")),
            Data(profileName: "ABC", avatar: UIImage(named: "2")),
            Data(profileName: "XYZ", avatar: UIImage(named: "3"))
        ]
        
        setupTableVeiw()
    }

    override func viewWillAppear(_ animated: Bool) {
        tableveiw.reloadData()
    }
    
    // MARK: - Private Methods
    
    func setupTableVeiw() {
        let nib = UINib(nibName: "TableViewCell", bundle: nil)
        tableveiw.register(nib, forCellReuseIdentifier: "cell")
        tableveiw.delegate = self
        tableveiw.dataSource = self
    }
    
    // MARK: - Button Action
    @IBAction func addButtonAction(_ sender: UIBarButtonItem) {
        let storyboard = UIStoryboard(name: "Add", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AddDataViewController") as! AddDataViewController

        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
    

}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        
        cell.imageVeiw.image = todoArr[indexPath.row].avatar
        cell.nameLabel.text = todoArr[indexPath.row].profileName
        return cell
    }
    
}
