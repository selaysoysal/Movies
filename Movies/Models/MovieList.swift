//
//  MovieList.swift
//  Movies
//
//  Created by Selay Soysal on 9.05.2019.
//  Copyright © 2019 Selay Turkmen. All rights reserved.
//

import UIKit

class MovieList: Codable {
    var page:Int
    var total_results: Int
    var total_pages:Int
    var results:[Movie]
    
    enum CodingKeys:String,CodingKey {
        case page
        case total_results
        case total_pages
        case results
    }
}
