//
//  ViewController.swift
//  Instagrid
//
//  Created by Saddam Satouyev on 17/05/2020.
//  Copyright © 2020 Saddam Satouyev. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var botStackView: UIStackView!
    @IBOutlet weak var topStackView: UIStackView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func didTapOnLayoutButton(_ sender: UIButton) {
        drawUIButtonsForUploadPictures(selectUIButtonsPosition: topStackView, nmbOfButtons: 0)
        drawUIButtonsForUploadPictures(selectUIButtonsPosition: botStackView, nmbOfButtons: 1)
    }
    
    @IBAction func didTapOnLayoutTwoButton(_ sender: UIButton) {
        drawUIButtonsForUploadPictures(selectUIButtonsPosition: topStackView, nmbOfButtons: 1)
        drawUIButtonsForUploadPictures(selectUIButtonsPosition: botStackView, nmbOfButtons: 0)

        
        
    }
    
    func photoUpload(vc: UIImagePickerController) {
        vc.sourceType = .photoLibrary
        vc.allowsEditing = true
        vc.delegate = self
        present(vc, animated: true)
    }
    
    @IBAction func didTapOnLayoutThreeButton(_ sender: UIButton) {
        drawUIButtonsForUploadPictures(selectUIButtonsPosition: topStackView, nmbOfButtons: 1)
        drawUIButtonsForUploadPictures(selectUIButtonsPosition: botStackView, nmbOfButtons: 1)

    }
    
    func removePrecedenteStack(selectUIButtonsPosition: UIStackView) {
        for subview in selectUIButtonsPosition.arrangedSubviews {
            subview.removeFromSuperview()
        }
    }
    
    func drawUIButtonsForUploadPictures(selectUIButtonsPosition: UIStackView, nmbOfButtons: Int) {
        removePrecedenteStack(selectUIButtonsPosition: selectUIButtonsPosition)
        for i in 0...nmbOfButtons {
            let drawOneButton = UIButton()
            let drawSecondButton = UIButton()
            let buttons: [UIButton] = [drawOneButton, drawSecondButton]
            buttons[i].backgroundColor = .white
            selectUIButtonsPosition.addArrangedSubview(buttons[i])
        }
//        switch nmbOfSTacks {
//        case 1:
//            buttons[0].backgroundColor = .white
//            selectStackViews.addArrangedSubview(buttons[0])
//        case 2:
//                    for i in 0...1 {
//                        buttons[i].backgroundColor = .white
//                        selectStackViews.addArrangedSubview(buttons[i])
//                    }
//        default:
//            return
//        }
//
    }
}


