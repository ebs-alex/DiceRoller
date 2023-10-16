//
//  rollResults.swift
//  DiceRoller
//
//  Created by Alex Moran on 10/14/23.
//

import Foundation

@MainActor class RollResults: ObservableObject {
    
    @Published var results: [Int]
    
    let savePathList = FileManager.documentDirectory.appendingPathComponent("SavedProspects")
    
    init() {
        do {
            let data = try Data(contentsOf: savePathList)
            results = try JSONDecoder().decode([Int].self, from: data)
        } catch {
            results = []
        }
    }
    
    private func save() {
        do {
            let data = try JSONEncoder().encode(results)
            try data.write(to: savePathList, options: [.atomic, .completeFileProtection])
        } catch {
            print("Unable to save data/nerror: \(error.localizedDescription)")
        }
    }
    
    func add(_ result: Int) {
        results.append(result)
        save()
    }
    
    func clearResults() {
        results = []
        save()
    }
    
    
}
