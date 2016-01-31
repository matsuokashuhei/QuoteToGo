//
//  AuthorManager.swift
//  QuotesToGo
//
//  Created by matsuosh on 1/31/16.
//  Copyright © 2016 Daniel Autenrieth. All rights reserved.
//

import UIKit

class AuthorManager: NSObject {

    class func addAuthor(name: String, completion: (author: Author) -> ()) {
        let moc = CoreDataHelper.managedObjectContext()
        let predicate = NSPredicate(format: "name = %@", name)
        let authors = CoreDataHelper.fetchEntities(NSStringFromClass(Author), managedObjectContext: moc, predicate: predicate, sortDescriptor: nil)
        if let author = authors.firstObject as? Author {
            completion(author: author)
        } else {
            let author = CoreDataHelper.insertManagedObject(NSStringFromClass(Author), managedObjectContext: moc) as! Author
            author.name = name
            do {
                try WikiFace.faceForPerson(name, size: CGSize(width: 118, height: 118), completion: { (image, imageFound) -> () in
                    if imageFound == true {
                        let faceImageView = UIImageView(image: image!)
                        faceImageView.contentMode = .ScaleAspectFill
                        WikiFace.centerImageViewOnFace(faceImageView)
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            UIGraphicsBeginImageContextWithOptions(faceImageView.bounds.size, true, 0)
                            let context = UIGraphicsGetCurrentContext()
                            faceImageView.layer.renderInContext(context!)
                            let croppedImage = UIGraphicsGetImageFromCurrentImageContext()
                            UIGraphicsEndImageContext()
                            let imageData = UIImageJPEGRepresentation(croppedImage, 0.5)
                            author.image = imageData
                            try! moc.save()
                            completion(author: author)
                        })
                    } else {
                        author.image = nil
                        try! moc.save()
                        completion(author: author)
                    }
                })
            } catch WikiFace.WikiFaceError.CouldNotDownloadImage {
                print("Cound not access wikipedias for author image. sitting default picture.")
                author.image = nil
                try! moc.save()
                completion(author: author)
            } catch {
                print(error)
            }
        }
    }
}
