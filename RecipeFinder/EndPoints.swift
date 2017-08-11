//
//  EndPoints.swift
//  RecipeFinder
//
//  Created by BMGH SRL on 11/08/2017.
//  Copyright © 2017 BMAGH SRL. All rights reserved.
//

import Foundation

struct API {
    static let baseUrl = "http://www.recipepuppy.com/api/?"
}

enum Endpoints {
    
    struct OptParameters {
        static let MultipleIngredients = "i"
        static let NormalQuery = "q"
        static let Page = "p"
    }
    
    struct Nodes {
        static let results = "results"
    }
    
    
}
