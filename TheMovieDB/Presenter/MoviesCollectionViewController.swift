//
//  MoviesCollectionViewController.swift
//  TheMovieDB
//
//  Created by Backup Admin on 4/21/22.
//

import UIKit

private let reuseIdentifier = "Cell"

class MoviesCollectionViewController: UICollectionViewController {
    
    var movies = [Movie]()
    var imageLoadTasks: [IndexPath: Task<Void, Never>] = [:]
    var alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.barTintColor = UIColor.black
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.red]
        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.red]
        
        Task.init {
            do {
                let movies = try await MovieController.shared.fetchMovies()
                updateUI(with: movies)
            } catch {
                displayError(error, title: "Failed to Fetch Movies")
            }
        }
    }
    
    func updateUI(with movies: [Movie]) {
        self.movies = movies
        self.collectionView.reloadData()
    }
    
    func displayError(_ error: Error, title: String) {
        guard let _ = viewIfLoaded?.window else { return }
        
        let alert = UIAlertController(title: title, message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }

    @IBSegueAction func showMovieItem(_ coder: NSCoder, sender: Any?) -> MovieDetailViewController? {
        
        guard let cell = sender as? MovieCollectionViewCell, let indexPath = collectionView.indexPath(for: cell) else {
            return nil
        }
        
        let movie = movies[indexPath.item]
        
        return MovieDetailViewController(coder: coder, movie: movie)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */
    
//    private func generateLayout() -> UICollectionViewLayout {
//        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
//        let item = NSCollectionLayoutItem(layoutSize: itemSize)
//
//        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(70.0))
//        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
//
//        let section = NSCollectionLayoutSection(group: group)
//
//        let layout = UICollectionViewCompositionalLayout(section: section)
//
//        return layout
//    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return movies.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MovieCollectionViewCell
    
        configure(cell, forItemAt: indexPath)
    
        return cell
    }
    
    func configure(_ cell: MovieCollectionViewCell, forItemAt indexPath: IndexPath) {
        let movie = movies[indexPath.item]
        
        cell.imageView.image = UIImage(systemName: "photo.on.rectangle")

        imageLoadTasks[indexPath] = Task.init {
            if let image = try? await MovieController.shared.fetchImage(from: movie.imagePath) {
                if let currentIndexPath = self.collectionView.indexPath(for: cell), currentIndexPath == indexPath {
                    cell.imageView.image = image
                }
            }
            imageLoadTasks[indexPath] = nil
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        // Cancel the image fetching task if it's no longer needed
        imageLoadTasks[indexPath]?.cancel()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        //Cancel image fetching tasks before all the tasks finish loading the images
        imageLoadTasks.forEach { key, value in value.cancel() }
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
