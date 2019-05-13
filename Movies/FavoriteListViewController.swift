//
//  FavoriteListViewController.swift
//  Movies
//
//  Created by Selay Soysal on 9.05.2019.
//  Copyright © 2019 Selay Turkmen. All rights reserved.
//

import UIKit

class FavoriteListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var favMoviesList: [Movie] = []
    var index:IndexPath?
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nibTableCell = UINib.init(nibName: "FavMovieCell", bundle: nil)
        self.tableView.register(nibTableCell, forCellReuseIdentifier: "favMovieCell")
        navigationItem.title = "Favorite Movies"
        self.tableView.dataSource = self
        self.tableView.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        favMoviesList = Favorite().getAllSavedMovies() as! [Movie]
        tableView.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favMoviesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:FavMovieCell = self.tableView.dequeueReusableCell(withIdentifier: "favMovieCell") as! FavMovieCell
        let movie = favMoviesList[indexPath.row]
        index = indexPath
        cell.displayData(title: movie.title ?? "", imageURL: String(format:"https://image.tmdb.org/t/p/w200%@",movie.poster_path ?? ""), movieId: movie.id ?? 0, cellMovie: movie)
        cell.unFavButton.addTarget(self, action: #selector(unFavButtonClicked), for: .touchUpInside)
        return cell
    }

    @objc
    func unFavButtonClicked(){
        Favorite().removeMovieFromCoreData(favMoviesList[(index?.row)!])
        favMoviesList = Favorite().getAllSavedMovies() as! [Movie]
        tableView.reloadData()
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
