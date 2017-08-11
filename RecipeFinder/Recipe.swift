//
//  Recipe.swift
//  RecipeFinder
//
//  Created by BMGH SRL on 11/08/2017.
//  Copyright © 2017 BMAGH SRL. All rights reserved.
//

import Foundation

enum SerializationError: Error {
    case missing(String)
    case invalid(String, Any)
}


struct Recipe {
    
    // MARK: Properties
    
    public let title: String!
    public let ingredients: String!
    public let url: String!
    public let thumbnailUrl: String!
    
    public init(title: String, ingredients: String, url: String, thumbnailUrl: String) {
        self.title = title
        self.ingredients = ingredients
        self.url = url
        self.thumbnailUrl = thumbnailUrl
    }
    
    
    
    // MARK: - CustomStringConvertible Protocol
    public var description: String {
        get {
            return "Recipe: \(title).\nIngredients: \(ingredients).\nURL: \(url). \nthumbnail: \(thumbnailUrl)"
        }
    }
    
    
}

extension Recipe {
    
    init(json: [String: AnyObject]) throws {
        
        // Extract name
        guard let title = json["title"] as? String else {
            throw SerializationError.missing("name")
        }
        
        // Extract ingredients
        guard let ingredients = json["ingredients"] as? String else {
            throw SerializationError.missing("ingredients")
        }
        
        // Extract url
        guard let url = json["href"] as? String else {
            throw SerializationError.missing("href")
        }
        
        // Extract thumbnailUrl
        guard let thumbnailUrl = json["thumbnail"] as? String else {
            throw SerializationError.missing("thumbnail")
        }
        
        
        self.title = title
        self.ingredients = ingredients
        self.url = url
        self.thumbnailUrl = thumbnailUrl
        
        
    }
    
}


