//
//  FavMovieCell.swift
//  Movies
//
//  Created by Selay Soysal on 9.05.2019.
//  Copyright © 2019 Selay Turkmen. All rights reserved.
//

import UIKit

class FavMovieCell: UITableViewCell {

    @IBOutlet weak var unFavButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var moviePoster: UIImageView!
    var movie = Movie ()
    
    let imageSession = URLSession(configuration: .ephemeral)
    let cache = NSCache<NSURL, UIImage>()
    override func awakeFromNib() {
        super.awakeFromNib()
        self.unFavButton.setImage(UIImage(named: "FavoriteImage"), for: UIControl.State.normal)
        // Initialization code
    }

    
  
    
    func displayData(title:String, imageURL:String, movieId:Int, cellMovie:Movie) {
        self.titleLabel.text = title
        self.titleLabel.numberOfLines = 0
        UIImage().loadImage(from: imageURL) {
            self.moviePoster.image = $0
        }
        movie = cellMovie
    }
    
   
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
