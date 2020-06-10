//
//  PhotoLayout.swift
//  Instagrid
//
//  Created by Saddam Satouyev on 09/06/2020.
//  Copyright © 2020 Saddam Satouyev. All rights reserved.
//

import Foundation

class PhotoLayout {
    init(numberOfTopPhoto: Int, numberOfBotPhoto: Int) {
        self.numberOfTopPhoto = numberOfTopPhoto
        self.numberOfBotPhoto = numberOfBotPhoto
    }
    
    let numberOfTopPhoto: Int
    let numberOfBotPhoto: Int
}
