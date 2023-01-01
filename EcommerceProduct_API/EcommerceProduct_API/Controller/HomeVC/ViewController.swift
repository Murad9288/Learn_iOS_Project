//
//  ViewController.swift
//  EcommerceProduct_API
//
//  Created by Md Murad Hossain on 3/12/22.
//

import UIKit


class ViewController: UIViewController {
    
    var AllProductData = [ProductModel]()
    let rest = RestManager()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
        fetchData()
    }
    
    func setUpTableView(){
        let nib = UINib(nibName: "productTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "productTableViewCell")
      
    }
    
    //MARK: fetchData
    
    func fetchData(){
        guard let url = URL(string: Api.MovieApiUrl) else { return }
        
        rest.makeRequest(toURL: url, withHttpMethod: .get) { result in
            
            if result.error != nil {
                print(result.error.debugDescription)
            }
            
            if let data = result.data {
                print(data)
                
                let decode = JSONDecoder()
                let welcome = try? decode.decode(Welcome.self, from: data)
                  
                guard let item = welcome else {return}
                self.AllProductData.append(contentsOf: item)
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
}



extension ViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AllProductData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "productTableViewCell") as! productTableViewCell
        cell.configure(allProduct: AllProductData[indexPath.row])
        return cell
    }
}


extension ViewController : UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyboradName = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboradName.instantiateViewController(withIdentifier: "ProductDetailsViewController") as! ProductDetailsViewController
        vc.pImage = AllProductData[indexPath.row].image!
        vc.pTitle = AllProductData[indexPath.row].title!
        vc.pDescription = AllProductData[indexPath.row].welcomeDescription ?? ""
        vc.pCategory = (AllProductData[indexPath.row].category!.rawValue)
        vc.pPrice = "$" + String((AllProductData[indexPath.row].price!))
        self.navigationController?.pushViewController(vc, animated: true)
    }

    
//    MARK: TableView  Cell Animation

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

        let anim = CATransform3DTranslate(CATransform3DIdentity, -500, 1, 0)
        cell.layer.transform = anim
        cell.alpha = 0.3

        UIView.animate(withDuration: 0.5){
            cell.layer.transform = CATransform3DIdentity
            cell.alpha = 1
        }
    }
}
    

//
////MARK: Api Image Downloaded
//
//extension UIImageView{
//    func downloaded(from url: URL, contentMode mode: ContentMode = .scaleAspectFit){
//        contentMode = mode
//        URLSession.shared.dataTask(with: url){data,response,error in
//            guard let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
//                  let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
//                  let data = data, error == nil,
//                  let image = UIImage(data: data)
//            else{
//                return
//            }
//            DispatchQueue.main.async() {
//                [weak self] in
//                self?.image = image
//            }
//        }.resume()
//    }
//
//    func downloaded(from link: String,contentMode mode: ContentMode = .scaleAspectFit){
//        guard let url = URL(string: link)else{return}
//        downloaded(from: url,contentMode: mode)
//    }
//}


