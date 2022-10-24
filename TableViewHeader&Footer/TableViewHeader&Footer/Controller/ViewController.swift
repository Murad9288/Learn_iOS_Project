//
//  ViewController.swift
//  TableViewHeader&Footer
//
//  Created by Md Murad Hossain on 19/10/22.
//

import UIKit

final class ViewController: UIViewController {
    
    var dictionaries = [
        dictionaryPage(firstLetter: "A", list: [animal(image:"🍏", name:"Apple"),
                                               animal(image:"🪗", name:"Accordion")]),
        dictionaryPage(firstLetter: "B", list: [animal(image: "🏀", name:"Basketball"),
                                                animal(image:"🏸", name:"Batminton")]),
        dictionaryPage(firstLetter: "C", list: [animal(image:"🏏", name:"Cricket Game"),
                                                animal(image:"🐈", name:"Cat")])
    ]


    @IBOutlet private weak var tableView: UITableView!
    
                                           
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 44
        self.tableView.sectionHeaderHeight = UITableView.automaticDimension
        self.tableView.estimatedSectionHeaderHeight = 44
        self.tableView.sectionFooterHeight = UITableView.automaticDimension
        self.tableView.estimatedSectionFooterHeight = 44
        
        // MARK: Register Cell Call
        setUpTheAnimalTableViewCell()
        setUpTheAnimalTableViewHeaderFooterViewCell()

        
    }
     // MARK: AnimalTableViewCell Register
    func setUpTheAnimalTableViewCell(){
        self.tableView.register(UINib(nibName: "animalTableViewCell", bundle: nil), forCellReuseIdentifier: "animalTableViewCell")
    }
    
    // MARK: AnimalTableViewHeaderFooterViewCell Register
    func setUpTheAnimalTableViewHeaderFooterViewCell(){
        self.tableView.register(UINib(nibName: "animalTableViewHeaderFooterView", bundle: nil), forHeaderFooterViewReuseIdentifier: "animalTableViewHeaderFooterView")
    }


}

// MARK: UITable View Datasource Method

extension ViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.dictionaries.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dictionaries[section].list.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "animalTableViewHeaderFooterView") as? animalTableViewHeaderFooterView
        headerView?.discriptionLabel.text = "\(self.dictionaries[section].firstLetter) - Header"
        return headerView
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "animalTableViewHeaderFooterView") as? animalTableViewHeaderFooterView
        footerView?.discriptionLabel.text = "\(self.dictionaries[section].firstLetter) - Footer"
        return footerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "animalTableViewCell", for: indexPath) as? animalTableViewCell {
            cell.animal = self.dictionaries[indexPath.section].list[indexPath.row]
            return cell
        }
        return UITableViewCell()
            
    }
}



// MARK: UITableView Delegate Method
extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        return
    }
}



