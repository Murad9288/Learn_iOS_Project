//
//  ViewController.swift
//  MultiplePhotos
//
//  Created by Md Murad Hossain on 18/10/22.
//

import UIKit
import PhotosUI


// Hello world!



class ViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var selectedImageArray = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: Register Collection View Call
        setupCollectionView()
        
        
    }
    // MARK: Register Collection View Cell
    
    func setupCollectionView(){
        let nib = UINib(nibName: "CollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "cell")
    }
    
    
    // MARK: AddButton Action
    @IBAction func addButtonImage(_ sender: UIBarButtonItem){
        var config = PHPickerConfiguration()
        config.selectionLimit = 1000
        let phPickerVC = PHPickerViewController(configuration: config)
        phPickerVC.modalPresentationStyle = .fullScreen
        phPickerVC.delegate = self
        self.present(phPickerVC,animated: true)
    }


}


// MARK: PHPickerViewController Delegate Method
extension ViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true)
        for result in results{
            result.itemProvider.loadObject(ofClass: UIImage.self) { object, error in
                if let image = object as? UIImage{
                    self.selectedImageArray.append(image)
                }
                // MARK: Image Reload Picker. Main Code
                
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }
    }
}



// MARK: UICollectionView Datasource Method

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        selectedImageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        cell.imageView.image = selectedImageArray[indexPath.row]
        cell.deleteButtuon.addTarget(self, action: #selector(handleRemoveItem), for: .touchUpInside)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let stb = UIStoryboard(name: "imageView", bundle: nil)
        let vc = stb.instantiateViewController(withIdentifier: "ImageViewController") as! ImageViewController
        vc.selectedImage = selectedImageArray[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    
    
    // MARK: Delete Button and Action UIAlertController
    
    @objc func handleRemoveItem(sender: UIButton) {
        if let photoCVCell = sender.superview?.superview as? CollectionViewCell {
            let alert = UIAlertController(title: "Delete", message: "Are you sure about deleting this image!", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { [self](action:UIAlertAction!) in
                guard let indexPath = collectionView.indexPath(for: photoCVCell) else {
                    return
                }
                self.selectedImageArray.remove(at: indexPath.row)
                print("Remove item")
                self.collectionView.deleteItems(at: [indexPath])
                self.collectionView.reloadData()
            }))
            
            alert.view.tintColor = .red
            self.present(alert, animated: true, completion: nil)
        }
    }

}




// MARK: UICollectionView Delegate Flow Layout Method

extension ViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        // MARK: collectionView allready loaded image width and height size
        
        return CGSize(width: collectionView.frame.size.width/3, height: collectionView.frame.size.height/5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

// MARK: Program Finished

