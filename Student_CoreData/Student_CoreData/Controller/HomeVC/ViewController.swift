//
//  ViewController.swift
//  Student_CoreData
//
//  Created by Md Murad Hossain on 13/12/22.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var textName: UITextField!
    @IBOutlet weak var textAddress: UITextField!
    @IBOutlet weak var textCity: UITextField!
    @IBOutlet weak var textMobile: UITextField!
    
    var i = Int()
    var isUpdateData = Bool()

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func saveButtonAction(_ sender: UIButton) {
        let dict = ["name" : textName.text, "address" : textAddress.text, "city" : textCity.text, "mobile" : textMobile.text]
        if isUpdateData {
            DatabaseHelper.shareInstance.editData(object: dict as! [String:String], i: i)
        }else{
            DatabaseHelper.shareInstance.save(object: dict as! [String:String])
        }
        
    }
    
    @IBAction func showSaveDataButton(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "listViewController") as! listViewController
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }

}

// MARK: Save coreData passing

extension ViewController: DataPass {
    
    func data(object: [String : String], index: Int, isEdit: Bool) {
        textName.text = object["name"]
        textAddress.text = object["address"]
        textCity.text = object["city"]
        textMobile.text = object["mobile"]
        i = index
        isUpdateData = isEdit

    }
    
}
