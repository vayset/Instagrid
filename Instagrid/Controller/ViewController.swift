//
//  ViewController.swift
//  Instagrid
//
//  Created by Saddam Satouyev on 17/05/2020.
//  Copyright © 2020 Saddam Satouyev. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var botStackView: UIStackView!
    @IBOutlet weak var topStackView: UIStackView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func didTapOnLayoutButton(_ sender: UIButton) {
        for subview in topStackView.arrangedSubviews { subview.removeFromSuperview()
        }
        let photoButtonOne = UIButton()
        photoButtonOne.backgroundColor = .white
        topStackView.addArrangedSubview(photoButtonOne)
        
        
        for subview in botStackView.arrangedSubviews { subview.removeFromSuperview()
        }
        let photoButtonTwo = UIButton()
        photoButtonTwo.backgroundColor = .white
        botStackView.addArrangedSubview(photoButtonTwo)
        
        let photoButtonThree = UIButton()
        photoButtonThree.backgroundColor = .white
        botStackView.addArrangedSubview(photoButtonThree)
        
    }
    @IBAction func didTapOnLayoutTwoButton(_ sender: Any) {
        for subview in topStackView.arrangedSubviews {
            subview.removeFromSuperview()
        }
        let photoButtonOne = UIButton()
        photoButtonOne.backgroundColor = .white
        topStackView.addArrangedSubview(photoButtonOne)
        
        let photoButtonTwo = UIButton()
        photoButtonTwo.backgroundColor = .white
        topStackView.addArrangedSubview(photoButtonTwo)
        
        for subview in botStackView.arrangedSubviews {
            subview.removeFromSuperview()
        }
        let photoButtonThree = UIButton()
        photoButtonThree.backgroundColor = .white
        botStackView.addArrangedSubview(photoButtonThree)
        
    }
    
    
    @IBAction func didTapOnLayoutThreeButton(_ sender: Any) {
        for subview in topStackView.arrangedSubviews {
            subview.removeFromSuperview()
        }
        
        let photoButtonOne = UIButton()
        photoButtonOne.backgroundColor = .white
        topStackView.addArrangedSubview(photoButtonOne)
        
        let photoButtonTwo = UIButton()
        photoButtonTwo.backgroundColor = .white
        topStackView.addArrangedSubview(photoButtonTwo)
        
        for subview in botStackView.arrangedSubviews {
            subview.removeFromSuperview()
        }
        let photoButtonThree = UIButton()
        photoButtonThree.backgroundColor = .white
        botStackView.addArrangedSubview(photoButtonThree)
        
        let photoButtonFour = UIButton()
        photoButtonFour.backgroundColor = .white
        botStackView.addArrangedSubview(photoButtonFour)
        
    }
    
}

