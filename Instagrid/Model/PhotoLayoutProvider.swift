//
//  PhotoLayoutProvider.swift
//  Instagrid
//
//  Created by Saddam Satouyev on 09/06/2020.
//  Copyright © 2020 Saddam Satouyev. All rights reserved.
//

import Foundation
import UIKit


protocol PhotoLayoutProviderDelegate: class {
    func didUpdatePhotos()
}

class PhotoLayoutProvider {
    
    weak var delegate: PhotoLayoutProviderDelegate?
    
    // MARK: - Internal

    // MARK: - Properties - Internal
    
    let layouts: [PhotoLayout] = [
        .init(numberOfTopPhoto: 1, numberOfBotPhoto: 2),
        .init(numberOfTopPhoto: 2, numberOfBotPhoto: 1),
        .init(numberOfTopPhoto: 2, numberOfBotPhoto: 2)
    ]
    
    var photos: [UIImage?] = [
        nil, nil, nil, nil
        ] {
        didSet {
            delegate?.didUpdatePhotos()
        }
    }
}
