//
//  MovieListCollectionViewCell.swift
//  Movies
//
//  Created by Selay Soysal on 9.05.2019.
//  Copyright © 2019 Selay Turkmen. All rights reserved.
//

import UIKit

class MovieListCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var favButton: UIButton!
    
    var isMovieFav : Bool = false
    var favorite = Favorite()
    var movie = Movie ()
    let imageSession = URLSession(configuration: .ephemeral)
    let cache = NSCache<NSURL, UIImage>()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBAction func favButtonClicked(_ sender: Any) {
        if (isMovieFav) {
            isMovieFav = false
            self.favButton.setImage(UIImage(named: "NotFavoriteImage"), for: UIControl.State.normal)
            favorite.removeMovieFromCoreData(movie)
        } else {
            isMovieFav = true
            self.favButton.setImage(UIImage(named: "FavoriteImage"), for: UIControl.State.normal)
            favorite.saveMovieToCoreData(movie)
        }
    }
    
    func isMovieFav(_ movieId:Int) {
        let favMovieList:Array<Movie> = favorite.getAllSavedMovies() as! Array<Movie>
        if favMovieList.first(where: {$0.id == movieId}) != nil{
            self.favButton.setImage(UIImage(named: "FavoriteImage"), for: UIControl.State.normal)
            isMovieFav = true
        } else {
            self.favButton.setImage(UIImage(named: "NotFavoriteImage"), for: UIControl.State.normal)
            isMovieFav = false
        }
    }
    

    func displayData(title:String, imageURL:String, movieId:Int, cellMovie:Movie) {
        self.titleLabel.text = title
        self.titleLabel.numberOfLines = 0
        UIImage().loadImage(from: imageURL) {
            self.posterImage.image = $0
        }
        isMovieFav(movieId)
        movie = cellMovie
    }
}
