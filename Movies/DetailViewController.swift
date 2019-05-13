//
//  DetailViewController.swift
//  Movies
//
//  Created by Selay Soysal on 9.05.2019.
//  Copyright © 2019 Selay Turkmen. All rights reserved.
//

import UIKit
import MBProgressHUD

class DetailViewController: UIViewController {

    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var voteLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var favButton: UIButton!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    let imageSession = URLSession(configuration: .ephemeral)
    let cache = NSCache<NSURL, UIImage>()
    
    var favorite = Favorite()
    var movieList = [Movie()]
    var index: Int = 0
    var isMovieFav: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setView()
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        self.view.addGestureRecognizer(swipeLeft)
        // Do any additional setup after loading the view.
    }
    
    func setView() {
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        titleLabel.text = movieList[index].title
        voteLabel.text = String(format:"Votes: %.1f /10", movieList[index].vote_average!)
        dateLabel.text = String(format:"Release date: %@", movieList[index].release_date!)
        descriptionTextView.text = movieList[index].overview
        UIImage().loadImage(from: String(format:"https://image.tmdb.org/t/p/w200%@",movieList[index].poster_path ?? "")) {
            self.posterImage.image = $0
             hud.hide(animated: true)
        }
        isMovieFav(movieList[index].id!)
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
   
    @IBAction func saveFavClicked(_ sender: Any) {
        if (isMovieFav) {
            isMovieFav = false
            self.favButton.setImage(UIImage(named: "NotFavoriteImage"), for: UIControl.State.normal)
            favorite.removeMovieFromCoreData(movieList[index])
            
        } else {
            isMovieFav = true
            self.favButton.setImage(UIImage(named: "FavoriteImage"), for: UIControl.State.normal)
            favorite.saveMovieToCoreData(movieList[index])
        }
    }
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizer.Direction.right:
                print("Swiped right")
                if index != 0 {
                    index -= 1
                } else {
                    return
                }
            case UISwipeGestureRecognizer.Direction.left:
                print("Swiped left")
                if index == movieList.count-1{
                    return
                } else {
                    index += 1
                }
            default:
                break
            }
            setView()
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
