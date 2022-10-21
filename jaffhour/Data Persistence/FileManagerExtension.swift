//
//  FileManagerExtension.swift
//  jaffhour
//
//  Created by Aidan on 2022-10-08.
//

import Foundation

// All credit to Paul Hudson's simple-swiftui SimpleToDo app
// A small extension on `FileManager` that returns the documents directory for this app.
extension FileManager {
    /// The documents directory for this app.
    static var documentsDirectory: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
