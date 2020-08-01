//
//  ViewController.swift
//  Instagrid
//
//  Created by Saddam Satouyev on 17/05/2020.
//  Copyright © 2020 Saddam Satouyev. All rights reserved.
//

import UIKit


class PhotoLayoutViewController: UIViewController {
    
    // MARK: - IBOutlets / IBActions
    
    @IBOutlet private weak var botStackView: UIStackView!
    @IBOutlet private weak var topStackView: UIStackView!
    @IBOutlet private var layoutButtons: [UIButton]!
    @IBOutlet private weak var mainGridView: UIView!
    @IBOutlet private weak var swipeToShareLabel: UILabel!
    @IBOutlet private weak var shareArrowImageView: UIImageView!
    @IBOutlet private var swipeToShareRecognizer: UISwipeGestureRecognizer!
    
    
    @IBAction private func swipeForShareGrid(_ sender: Any) {
        let translationXAndY = CGAffineTransform(translationX: gridTranslationXValue, y: gridTranslationYValue)
        
        UIView.animate(withDuration: 0.5) {
            self.mainGridView.transform = translationXAndY
        }
        
        presentActivityController()
    }
    @IBAction private func didTapOnLayoutButton(_ sender: UIButton) {
        selectPhotoLayoutWith(tag: sender.tag)
    }
    
    
    // MARK: - Internal
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photoLayoutProvider.delegate = self
        
        updateUIAccordingToOrientation()
        setupLayoutButtons()
    
        selectPhotoLayoutWith(tag: 1)
        
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        
        coordinator.animate(alongsideTransition: { _ in
            self.updateUIAccordingToOrientation()
            
        })
        
    }
    
    // MARK: - Private
    
    // MARK: - Properties - Private
    
    private let photoLayoutProvider = PhotoLayoutProvider()
    private var buttonIndexToAssignPhoto: Int?
    private var photoButtons: [UIButton] = []
    
    private var windowInterfaceOrientation: UIInterfaceOrientation? {
        if #available(iOS 13.0, *) {
            return UIApplication.shared.windows.first?.windowScene?.interfaceOrientation
        } else {
            return UIApplication.shared.statusBarOrientation
        }
    }
    
    private var gridTranslationXValue: CGFloat = 0
    private var gridTranslationYValue: CGFloat = 0
    
    // MARK: - Methods - Private
    
    private func selectPhotoLayoutWith(tag: Int) {
        for button in layoutButtons {
            button.isSelected = false
        }
        
        createPhotoButtonsAccordingTo(tag: tag)
        layoutButtons[tag].isSelected = true
    }
    
    private func updateUIAccordingToOrientation() {
    
        guard let orientation = windowInterfaceOrientation else { return }
        
        if orientation == .portrait {
            swipeToShareLabel.text = "Swipe up to share"
            shareArrowImageView.transform = .identity
            swipeToShareRecognizer.direction = .up
            
            gridTranslationXValue = 0
            gridTranslationYValue = -view.frame.height
            
        } else {
            swipeToShareLabel.text = " Swipe left to share"
            shareArrowImageView.transform = CGAffineTransform(rotationAngle: -(.pi / 2))
            swipeToShareRecognizer.direction = .left
            
            gridTranslationXValue = -view.frame.width
            gridTranslationYValue = 0
        }
    }
    
    
    private func setupLayoutButtons() {
        
        let image = UIImage(named: "Selected")
        for button in layoutButtons {
            button.setImage(image, for: .selected)
        }
    }
    
    private func drawUIButtonsForUploadPictures(selectUIButtonsPosition: UIStackView, nmbOfButtons: Int) {
        removePrecedenteStack(selectUIButtonsPosition: selectUIButtonsPosition)
        
        for _ in 1...nmbOfButtons {
            let photoButton = UIButton()
            photoButton.backgroundColor = .white
            photoButton.imageView?.contentMode = .scaleAspectFill
            
            let plusImage = UIImage(named: "Plus")
            photoButton.setImage(plusImage, for: .normal)
            
            photoButton.addTarget(self, action: #selector(tapOnImage), for: . touchUpInside)
            photoButtons.append(photoButton)
            selectUIButtonsPosition.addArrangedSubview(photoButton)
        }
    }
    
    @objc private func tapOnImage(_ sender: UIButton) {
        buttonIndexToAssignPhoto = sender.tag
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
        photoButtons.removeAll()
        let photoLayout = photoLayoutProvider.layouts[tag]
        drawUIButtonsForUploadPictures(selectUIButtonsPosition: topStackView, nmbOfButtons: photoLayout.numberOfTopPhoto)
        drawUIButtonsForUploadPictures(selectUIButtonsPosition: botStackView, nmbOfButtons: photoLayout.numberOfBotPhoto)
        for (index, button) in photoButtons.enumerated() {
            button.tag = index
        }
        didUpdatePhotos()
    }
    
    private func convertViewToImage(view: UIView) -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: view.bounds)
        return renderer.image { rendererContext in
            view.layer.render(in: rendererContext.cgContext)
        }
    }
    
}

// MARK: - Extension


extension PhotoLayoutViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        
        
        if
            let image = info[.originalImage] as? UIImage,
            let imageIndex = buttonIndexToAssignPhoto {
            photoLayoutProvider.photos[imageIndex] = image
        }
        
        dismiss(animated: true, completion: nil)
        
    }
}



extension PhotoLayoutViewController: PhotoLayoutProviderDelegate {
    func didUpdatePhotos() {
        for (index, photo) in photoLayoutProvider.photos.enumerated() {
            guard let photo = photo else { continue }
            photoButtons[index].setImage(photo, for: .normal)
        }
    }
    
    
}
