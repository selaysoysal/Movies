//
//  ListViewController.swift
//  Movies
//
//  Created by Selay Soysal on 9.05.2019.
//  Copyright © 2019 Selay Turkmen. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD

class ListViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    var movieList = [Movie()]
    var offset:Int = 0
    var page:Int = 1
    let apiKey = "fd2b04342048fa2d5f728561866ad52a"
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let nibTableCell = UINib.init(nibName: "MovieListTableViewCell", bundle: nil)
        self.tableView.register(nibTableCell, forCellReuseIdentifier: "movieListTableCell")
        
        let nibCollectionCell = UINib.init(nibName: "MovieListCollectionViewCell", bundle: nil)
        self.collectionView.register(nibCollectionCell, forCellWithReuseIdentifier: "movieListCollectionCell")
        movieList.removeAll()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.isHidden = true;
        self.loadMorePages()
        
        let changeLayoutButton : UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "grid"), style: .plain, target:self, action: #selector(changeLayoutOrientation))
        navigationItem.rightBarButtonItem = changeLayoutButton
        navigationItem.title = "Popular Movies"

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tableView.reloadData()
        self.collectionView.reloadData()
    }
    
    @objc
    func changeLayoutOrientation() {
        if (tableView.isHidden) {
            tableView.isHidden = false
            collectionView.isHidden = true
        } else {
            tableView.isHidden = true
            collectionView.isHidden = false

        }
    }
    
    
    func loadMorePages() {
        guard let url = URL(string: String(format:"https://api.themoviedb.org/3/movie/popular?language=en-US&api_key=%@&page=%d",apiKey,page))
        else {
            return
        }
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        
        Alamofire.request(url)
            .response{ response in
                let decoder = JSONDecoder()
                do {
                    let posts = try decoder.decode(MovieList.self, from: response.data!)
                    print(posts)
                    self.movieList.append(contentsOf: posts.results)
                } catch let error {
                    print ("error parsing get logs: \(error)")
                }
                hud.hide(animated: true)
                self.page = self.page + 1
                self.tableView.reloadData()
                self.collectionView.reloadData()
        }
    }
    
    func openDetailView(_ indexPath: IndexPath){
        if let movieDetailViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController {
            movieDetailViewController.movieList = movieList
            movieDetailViewController.index = indexPath.row
            if let navigator = navigationController {
                navigator.pushViewController(movieDetailViewController, animated: true)
            }
        }
    }
    // MARK: - UITableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:MovieListTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "movieListTableCell") as! MovieListTableViewCell
        let movie = movieList[indexPath.row]
        cell.displayData(title: movie.title ?? "", imageURL:String(format:"https://image.tmdb.org/t/p/w200%@",movie.poster_path ?? ""), movieId:movie.id ?? 0 , cellMovie:movie)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.openDetailView(indexPath)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (indexPath.row == movieList.count - 1) {
            self.loadMorePages()
        }
    }
    // MARK: - UICollectionView

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: MovieListCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "movieListCollectionCell", for: indexPath) as! MovieListCollectionViewCell
        cell.backgroundColor = .white
        let movie:Movie = movieList[indexPath.row]
        cell.displayData(title: movie.title ?? "", imageURL:String(format:"https://image.tmdb.org/t/p/w200%@",movie.poster_path ?? ""), movieId:movie.id ?? 0 , cellMovie:movie)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.openDetailView(indexPath)
    }
    
    func  collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if (indexPath.row == movieList.count - 1) {
            self.loadMorePages()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 2 - 1

        return CGSize(width: width, height: 1.56*width)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    func maximumNumberOfColumns(for collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout) -> Int {
        let numColumns: Int = Int(2.0)
        return numColumns
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

extension UIImage {
    func loadImage(from imageUrl: String, completion: @escaping (UIImage) -> Void)
    {
        var image: UIImage? = nil
        let cache = NSCache<NSURL, UIImage>()
        let imageSession = URLSession(configuration: .ephemeral)
        let url = URL(string:imageUrl)
        image = UIImage(named:"placeholder")
        if let chachedImage = cache.object(forKey: url! as NSURL)
        {
            image = chachedImage
            completion(image!)
        }
        else
        {
            let task = imageSession.dataTask(with: url!) { (imageData, _, error) in
                DispatchQueue.main.async {
                    if error == nil {
                        if let imageData = imageData {
                            if let imageToPresent = UIImage(data: imageData) {
                                image = imageToPresent
                                cache.setObject(image!, forKey: url! as NSURL)
                            } else {
                                image = UIImage(named:"placeholder")
                            }
                        } else {
                            image = UIImage(named:"placeholder")
                        }
                        completion(image!)
                    }
                }
            }
            task.resume()
        }
    }
}
