//
//  ViewController.swift
//  CustomTableViewDataPass
//
//  Created by Md Murad Hossain on 20/10/22.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var imgName = ["1","2","3","4","1","2","3","4","1","2","3","4"]
    var friendName = ["murad","kahem","faysal","helal","murad","kahem","faysal","helal","murad","kahem","faysal","helal"]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setup()
    }
    func setup(){
        let nib = UINib(nibName: "FriendTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        
    }

}

extension ViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imgName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let call = tableView.dequeueReusableCell(withIdentifier: "cell") as! FriendTableViewCell
        call.configure(img: UIImage(named: imgName[indexPath.row]), name1: friendName[indexPath.row])
        return call
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboradName = UIStoryboard(name: "Details", bundle: nil)
        let vc = storyboradName.instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
        vc.im = UIImage(named: imgName[indexPath.row])!
        vc.lb = friendName[indexPath.row]
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    
}
