//
//  Movie.swift
//  Movies
//
//  Created by Selay Soysal on 9.05.2019.
//  Copyright © 2019 Selay Turkmen. All rights reserved.
//

import UIKit


class Movie: Codable {
    var vote_count:Int?
    var id:Int?
    var vote_average:Double?
    var title:String?
    var popularity:Double?
    var poster_path:String?
    var original_language:String?
    var original_title:String?
    var overview:String?
    var release_date:String?

    enum CodingKeys:String,CodingKey {
        case vote_count
        case id
        case vote_average
        case title
        case popularity
        case poster_path
        case original_language
        case original_title
        case overview
        case release_date
    }
}

