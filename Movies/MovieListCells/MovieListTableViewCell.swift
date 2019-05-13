//
//  MovieListTableViewCell.swift
//  Movies
//
//  Created by Selay Soysal on 9.05.2019.
//  Copyright © 2019 Selay Turkmen. All rights reserved.
//

import UIKit

class MovieListTableViewCell: UITableViewCell {

    @IBOutlet weak var favButton: UIButton!
    @IBOutlet weak var cellPosterImage: UIImageView!
    @IBOutlet weak var titleView: UILabel!
    
    var isMovieFav : Bool = false
    var favorite = Favorite()
    var movie = Movie ()
   
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
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
    
    @IBAction func FavButtonClicked(_ sender: Any) {
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
    

    func displayData(title:String, imageURL:String, movieId:Int, cellMovie:Movie) {
        self.titleView.text = title
        self.titleView.numberOfLines = 0
        UIImage().loadImage(from: imageURL) {
            self.cellPosterImage.image = $0
        }
        isMovieFav(movieId)
        movie = cellMovie
    }
    
     override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
