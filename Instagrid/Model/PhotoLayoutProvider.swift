//
//  PhotoLayoutProvider.swift
//  Instagrid
//
//  Created by Saddam Satouyev on 09/06/2020.
//  Copyright © 2020 Saddam Satouyev. All rights reserved.
//

import Foundation


class PhotoLayoutProvider {
    let layouts: [PhotoLayout] = [
        .init(numberOfTopPhoto: 1, numberOfBotPhoto: 2),
        .init(numberOfTopPhoto: 2, numberOfBotPhoto: 1),
        .init(numberOfTopPhoto: 2, numberOfBotPhoto: 2)
    ]
}
