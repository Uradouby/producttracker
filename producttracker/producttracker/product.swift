//
//  product.swift
//  producttracker
//
//  Created by njuios on 2020/11/9.
//
import UIKit
import Foundation
import os.log

class Product:NSObject,NSCoding {
    required convenience init?(coder aDecoder: NSCoder)
    {
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String else {
                os_log("Unable to decode the name for a Meal object.", log: OSLog.default, type: .debug)
                return nil
            }
            // Because photo is an optional property of Meal, just use conditional cast.
            let photo = aDecoder.decodeObject(forKey: PropertyKey.photo) as? UIImage
            
            let rating = aDecoder.decodeInteger(forKey: PropertyKey.rating)
            
            // Must call designated initializer.
            self.init(name: name, photo: photo, rating: rating)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(photo, forKey: PropertyKey.photo)
        aCoder.encode(rating, forKey: PropertyKey.rating)
    }
    
    //MARK: Properties
    struct PropertyKey {
        static let name = "name"
        static let photo = "photo"
        static let rating = "rating"
    }
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("meals")
    var name: String
    var photo: UIImage?
    var rating: Int
    
    init?(name: String, photo: UIImage?, rating: Int) {
        
        // The name must not be empty
           guard !name.isEmpty else {
               return nil
           }
           
           // The rating must be between 0 and 5 inclusively
           guard (rating >= 0) && (rating <= 5) else {
               return nil
           }
           
           // Initialize stored properties.
           self.name = name
           self.photo = photo
           self.rating = rating
    }
    
    
    
    
}
