//
//  DBManager.swift
//  NanoChallengeNASA
//
//  Created by Mateus Rodrigues on 22/10/18.
//  Copyright © 2018 Mateus Rodrigues. All rights reserved.
//

import Foundation
import  UIKit
import CoreData

class DBManager {
    
    static let shared = DBManager()
    
    let persistentContainer: NSPersistentContainer!
    
    init(container: NSPersistentContainer) {
        self.persistentContainer = container
        self.persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    convenience init() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Can not get shared app delegate")
        }
        self.init(container: appDelegate.persistentContainer)
    }
    
    private func save() throws {
        try persistentContainer.viewContext.save()
    }
    
    func insertItem(id: String, title: String, description: String) {
        let photo = NSEntityDescription.insertNewObject(forEntityName: "Photo", into: persistentContainer.viewContext) as! Photo
        photo.id = id
        photo.title = title
        photo.photoDescription = description
        do {
            try save()
        } catch {
            print(error)
        }
    }
    
    func delete(photo: Photo) {
        persistentContainer.viewContext.delete(photo)
        try! save()
    }
    
    func fetchAllPhotos() -> [Photo] {
        let request: NSFetchRequest<Photo> = Photo.fetchRequest()
        let results = try? persistentContainer.viewContext.fetch(request)
        return results!
    }
    
    func fetchPhoto(id: String) -> Photo? {
        let request: NSFetchRequest<Photo> = Photo.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id)
        let results = try? persistentContainer.viewContext.fetch(request)
        return results?.first
    }
    
}
