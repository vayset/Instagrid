//
//  ViewController.swift
//  Instagrid
//
//  Created by Saddam Satouyev on 17/05/2020.
//  Copyright © 2020 Saddam Satouyev. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    
    // MARK: - IBOutlets / IBActions
    
    @IBOutlet private weak var botStackView: UIStackView!
    @IBOutlet private weak var topStackView: UIStackView!

    @IBAction func swipeForShareGrid(_ sender: Any) {
        let items: [Any] = ["test"]
        let avc = UIActivityViewController(activityItems: items, applicationActivities: nil)

          // present the view controller
          self.present(avc, animated: true, completion: nil)
    }
    @IBAction private func didTapOnLayoutButton(_ sender: UIButton) {
        createPhotoButtonsAccordingTo(tag: sender.tag)
    }
    
    
    // MARK: - Internal
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createPhotoButtonsAccordingTo(tag: 1)
        
    }
    
    
    
    // MARK: - Private
    
    // MARK: - Properties - Private
    
    private let photoLayoutProvider = PhotoLayoutProvider()
    private var buttonToAssignPhoto: UIButton?
    
    private func drawUIButtonsForUploadPictures(selectUIButtonsPosition: UIStackView, nmbOfButtons: Int) {
        removePrecedenteStack(selectUIButtonsPosition: selectUIButtonsPosition)
        
        for _ in 1...nmbOfButtons {
            let photoButton = UIButton()
            photoButton.backgroundColor = .white
            photoButton.imageView?.contentMode = .scaleAspectFill
            
            let plusImage = UIImage(named: "Plus")
            photoButton.setImage(plusImage, for: .normal)
            
            photoButton.addTarget(self, action: #selector(tapOnImage), for: .touchUpInside)
            selectUIButtonsPosition.addArrangedSubview(photoButton)
        }
    }
    
    @objc func tapOnImage(_ sender: UIButton) {
        buttonToAssignPhoto = sender
        presentImagePicker()
    }
    
    private func removePrecedenteStack(selectUIButtonsPosition: UIStackView) {
        for subview in selectUIButtonsPosition.arrangedSubviews {
            subview.removeFromSuperview()
        }
    }
    
    func presentActivityController() {

    }
    
    private func presentImagePicker() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        present(imagePickerController, animated: true)
    }
    
    private func createPhotoButtonsAccordingTo(tag: Int) {
        let photoLayout = photoLayoutProvider.layouts[tag]
        drawUIButtonsForUploadPictures(selectUIButtonsPosition: topStackView, nmbOfButtons: photoLayout.numberOfTopPhoto)
        drawUIButtonsForUploadPictures(selectUIButtonsPosition: botStackView, nmbOfButtons: photoLayout.numberOfBotPhoto)
    }
    
    
    
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        
        if let image = info[.originalImage] as? UIImage {
            buttonToAssignPhoto?.setImage(image, for: .normal)
        }
        
        dismiss(animated: true, completion: nil)
        
    }
}


