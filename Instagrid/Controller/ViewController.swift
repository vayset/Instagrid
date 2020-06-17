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
    @IBOutlet weak var test: UIButton!
    @IBOutlet weak var buttonTwo: UIButton!
    @IBOutlet weak var buttonThree: UIButton!
    
    
    @IBAction func swipeForShareGrid(_ sender: Any) {
        let translationXAndY = CGAffineTransform(translationX: 0, y: -view.frame.height)
        
        UIView.animate(withDuration: 0.5) {
            self.mainGridView.transform = translationXAndY
        }
        
        presentActivityController()
    }
    @IBAction private func didTapOnLayoutButton(_ sender: UIButton) {
        
        
        createPhotoButtonsAccordingTo(tag: sender.tag)
        buttonThree.addTarget(self, action: #selector(fireworks), for: .touchUpInside)
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
    
    @IBOutlet weak var mainGridView: UIView!
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
    
    @objc func fireworks(_ sender: UIButton) {
        
        if sender === buttonTwo || sender === buttonThree  {
            self.buttonThree.setImage(UIImage(named: "Selected"), for: .selected)
            
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
    
    private func presentActivityController() {
        
        let image = convertViewToImage(view: mainGridView)
        
        let items: [Any] = [image]
        let avc = UIActivityViewController(activityItems: items, applicationActivities: nil)
        
        avc.completionWithItemsHandler = { _, _,_,_ in
            UIView.animate(withDuration: 0.2) {
                self.mainGridView.transform = .identity
            }
            
        }
        self.present(avc, animated: true, completion: nil)
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
    
    func convertViewToImage(view: UIView) -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: view.bounds)
        return renderer.image { rendererContext in
            view.layer.render(in: rendererContext.cgContext)
        }
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


