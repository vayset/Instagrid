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
    
    /// Swipe function to share grid
    @IBAction private func swipeForShareGrid(_ sender: Any) {
        
        let translationXAndY = CGAffineTransform(translationX: gridTranslationXValue, y: gridTranslationYValue)
        UIView.animate(withDuration: 0.5) {
            self.mainGridView.transform = translationXAndY
        }
        
        presentActivityController()
    }
    
    ///Function to choose the grid
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
    
    /// Method to select the type of grid using tags
    private func selectPhotoLayoutWith(tag: Int) {
        
        for button in layoutButtons {
            button.isSelected = false
        }
        
        createPhotoButtonsAccordingTo(tag: tag)
        layoutButtons[tag].isSelected = true
    }
    
    /// Method that manages the orientation part
    private func updateUIAccordingToOrientation() {
        
        guard let orientation = windowInterfaceOrientation else { return }
        
        if orientation == .portrait {
            swipeToShareLabel.text = "Swipe up to share"
            shareArrowImageView.transform = .identity
            swipeToShareRecognizer.direction = .up
            
            gridTranslationXValue = 0
            gridTranslationYValue = -view.frame.height
            
        } else {
            swipeToShareLabel.text = "Swipe left to share"
            shareArrowImageView.transform = CGAffineTransform(rotationAngle: -(.pi / 2))
            swipeToShareRecognizer.direction = .left
            
            gridTranslationXValue = -view.frame.width
            gridTranslationYValue = 0
        }
    }
    
    /// Method that applies the selected image over the grid selection buttons
    private func setupLayoutButtons() {
        
        let image = UIImage(named: "Selected")
        for button in layoutButtons {
            button.setImage(image, for: .selected)
        }
    }
    
    /// Method to create insert picture buttons
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
    
    /// Method for get tap on image
    @objc private func tapOnImage(_ sender: UIButton) {
        buttonIndexToAssignPhoto = sender.tag
        presentImagePicker()
    }
    
    /// Method that erases the previous stack
    private func removePrecedenteStack(selectUIButtonsPosition: UIStackView) {
        for subview in selectUIButtonsPosition.arrangedSubviews {
            subview.removeFromSuperview()
        }
    }
    
    /// New controller to upload images
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
    
    /// Method that provides access to library to recover photos
    private func presentImagePicker() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        present(imagePickerController, animated: true)
    }
    
    /// According to the grid selected, the method will create the image insertion buttons
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
    
    /// A method that converts the view to an image
    private func convertViewToImage(view: UIView) -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: view.bounds)
        return renderer.image { rendererContext in
            view.layer.render(in: rendererContext.cgContext)
        }
    }
    
}

// MARK: - Extension

extension PhotoLayoutViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    /// Method which allows to recover the chosen image
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
    /// Method that checks if there are new image updates
    func didUpdatePhotos() {
        
        for (index, photo) in photoLayoutProvider.photos.enumerated() {
            guard
                let photo = photo,
                index < photoButtons.count
                else { continue }
            photoButtons[index].setImage(photo, for: .normal)
        }
    }
    
    
}
