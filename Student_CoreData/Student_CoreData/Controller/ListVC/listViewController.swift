//
//  listViewController.swift
//  Student_CoreData
//
//  Created by Md Murad Hossain on 13/12/22.
//

import UIKit

protocol DataPass {
    func data(object:[String:String], index: Int, isEdit: Bool)
}

class listViewController: UIViewController {
    @IBOutlet weak var tablView: UITableView!

    var student = [Student]()
    var delegate: DataPass!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableViewSetup()
    }
    
    func tableViewSetup() {
        let nib = UINib(nibName: "StudentTableViewCell", bundle: nil)
        tablView.register(nib, forCellReuseIdentifier: "cell")
        
        // information list pass
        student = DatabaseHelper.shareInstance.getStudentData()
    }
}


extension listViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return student.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! StudentTableViewCell
        cell.student = student[indexPath.row]
        return cell
    }
    
    
}

extension listViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 220
    }
    
    // MARK: Delete TableView Cell
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            student = DatabaseHelper.shareInstance.deleteData(index: indexPath.row)
            self.tablView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dict = ["name" : student[indexPath.row].name, "address" : student[indexPath.row].address, "city" : student[indexPath.row].city, "mobile" : student[indexPath.row].mobile]
        delegate.data(object: dict as! [String:String], index: indexPath.row, isEdit: true)
        self.navigationController?.popViewController(animated: true)
    }
    
    
//   MARK: TableViewCell Animation
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let anim = CATransform3DTranslate(CATransform3DIdentity, -500, 100, 0)
                cell.layer.transform = anim
                cell.alpha = 0.3
                
                UIView.animate(withDuration: 0.5){
                    cell.layer.transform = CATransform3DIdentity
                    cell.alpha = 1
                }
        }
    
}
