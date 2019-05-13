//
//  Favorite.swift
//  Movies
//
//  Created by Selay Soysal on 10.05.2019.
//  Copyright © 2019 Selay Turkmen. All rights reserved.
//

import UIKit
import CoreData

class Favorite: NSObject {
    
   
    
    func getAllSavedMovies() -> Array<Any> {
        var favoriteMovieList :Array<Movie> = []
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate!.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Movie")
        do {
            let favMovieList = try managedContext.fetch(fetchRequest)
            for data in favMovieList as! [NSManagedObject] {
                let movie = Movie()
                movie.id = data.value(forKey: "id") as? Int
                movie.original_language = data.value(forKey: "original_language") as? String
                movie.vote_average = data.value(forKey:  "vote_average") as? Double
                movie.vote_count = data.value(forKey: "vote_count") as? Int
                movie.title = data.value(forKey: "title") as? String
                movie.popularity = data.value(forKey: "popularity") as? Double
                movie.poster_path = data.value(forKey: "poster_path") as? String
                movie.original_title = data.value(forKey: "original_title") as? String
                movie.overview = data.value(forKey: "overview") as? String
                movie.release_date = data.value(forKey: "release_date") as? String
                favoriteMovieList.append(movie)
            }
        } catch {
              print("Cannot get the list of Favorite Movies")
        }
        return favoriteMovieList
    }
    
    func removeMovieFromCoreData(_ favMovie:Movie) {
       let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate!.persistentContainer.viewContext
       
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Movie")
        fetchRequest.predicate = NSPredicate (format: "id = %d", favMovie.id!)
        do {
            let favMovieList = try managedContext.fetch(fetchRequest)
            let deletedObject = favMovieList[0] as! NSManagedObject
            managedContext.delete(deletedObject)
            do {
                try managedContext.save()
            } catch {
                print(error)
            }
        } catch {
            print("Cannot delete selected Item, %@",favMovie)
        }
    }
    
    func saveMovieToCoreData(_ favMovie:Movie) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate!.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Movie",
                                                in: managedContext)!
        let movieData = NSManagedObject(entity: entity,
                                    insertInto: managedContext)
        movieData.setValue(favMovie.id, forKey: "id")
        movieData.setValue(favMovie.vote_average, forKey: "vote_average")
        movieData.setValue(favMovie.vote_count, forKey: "vote_count")
        movieData.setValue(favMovie.title, forKey: "title")
        movieData.setValue(favMovie.popularity, forKey: "popularity")
        movieData.setValue(favMovie.poster_path, forKey: "poster_path")
        movieData.setValue(favMovie.original_title, forKey: "original_title")
        movieData.setValue(favMovie.original_language, forKey: "original_language")
        movieData.setValue(favMovie.overview, forKey: "overview")
        movieData.setValue(favMovie.release_date, forKey: "release_date")
    
        do {
            try managedContext.save()
        } catch {
            print("Failed saving")
        }
        
        let list = getAllSavedMovies()
        print(list)
    }
    
}
