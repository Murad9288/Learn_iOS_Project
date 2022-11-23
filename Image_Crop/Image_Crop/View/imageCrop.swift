//
//  imageCrop.swift
//  Image_Crop
//
//  Created by Md Murad Hossain on 15/11/22.
//

import Foundation
import Combine
import UIKit

protocol ImagePickerControllerDelegate: AnyObject {
    func didSelectImage(_ selectedImageInfo: UserImageInfo)
    func didDismissWithoutSelectingImage(_ viewController: ImagePickerViewController)
}

class ImagePickerViewController: UIViewController {

    private var imagePicker: ImagePicker?

    weak var delegate: ImagePickerControllerDelegate?

    private var cancelables: Set<AnyCancellable> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bindValue()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        imagePicker?.showPicker()
    }

    private func setupView() {
        view.backgroundColor = .clear
        setupImagePicker()
    }

    private func setupImagePicker() {
        imagePicker = ImagePicker(presentationController: self)
    }

    private func bindValue() {
        imagePicker?.$state
            .sink(receiveValue: { [weak self] state in
                guard let self = self else { return }

                self.imagePicker?.dismissPicker()

                if case .selected(let imageInfo) = state {
                    self.delegate?.didSelectImage(imageInfo)
                } else if case .canceled = state {
                    self.delegate?.didDismissWithoutSelectingImage(self)
                }
            })
            .store(in: &cancelables)
    }
}

class ImagePicker: NSObject {

    enum ImagePickerState {
        case presented
        case selected(info: UserImageInfo)
        case canceled
    }

    // MARK: - Image Picker Properties
    private var presentationController: UIViewController?
    private var imagePickerContoller: UIImagePickerController?

    @Published var state: ImagePickerState = .presented

    init(presentationController: UIViewController) {
        self.imagePickerContoller = UIImagePickerController()

        super.init()

        self.presentationController = presentationController

        imagePickerContoller?.delegate = self
        imagePickerContoller?.view.backgroundColor = .clear
        imagePickerContoller?.modalPresentationStyle = .overCurrentContext
        imagePickerContoller?.modalTransitionStyle = .crossDissolve
        imagePickerContoller?.sourceType = .photoLibrary
        imagePickerContoller?.allowsEditing = false
    }

    private func setupImagePickerController() {
        imagePickerContoller = UIImagePickerController()
    }

    func showPicker() {
        presentationController?.present(imagePickerContoller!, animated: true, completion: nil)
    }

    func dismissPicker() {
        imagePickerContoller?.dismiss(animated: true)
    }
}

// MARK: - Image Picker Delegate
extension ImagePicker: UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let selectedImage = info[.originalImage] as? UIImage else { return }
        guard let filePath = info[.imageURL] as? URL else { return }
        
        let imgName = filePath.lastPathComponent
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
        let localPath = documentDirectory!.appending(imgName)
        
        let userImageInfo = UserImageInfo(image: selectedImage, pathURL: URL(string: localPath)!)
        
        self.state = .selected(info: userImageInfo)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.state = .canceled
    }
}

// MARK: - User Image Info
struct UserImageInfo {
    var image: UIImage
    var pathURL: URL
}
