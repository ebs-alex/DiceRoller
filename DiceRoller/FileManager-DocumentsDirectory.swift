//
//  FileManager-DocumentsDirectory.swift
//  PhotoList
//
//  Created by Alex Moran on 9/22/23.
//

import Foundation

extension FileManager {
    static var documentDirectory: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
