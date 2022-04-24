//
//  MovieDetailViewController.swift
//  TheMovieDB
//
//  Created by Backup Admin on 4/18/22.
//

import UIKit

class MovieDetailViewController: UIViewController {

    @IBOutlet var detailTextLabel: UILabel!
    @IBOutlet var summaryLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let movie: Movie
    
    init?(coder: NSCoder, movie: Movie) {
        self.movie = movie
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    private func showSpinner() {
        activityIndicator.startAnimating()
        loadingView.isHidden = false
    }

    private func hideSpinner() {
        activityIndicator.stopAnimating()
        loadingView.isHidden = true
    }
    
    func updateUI() {
        titleLabel.text = movie.title
        summaryLabel.text = "Summary"
        detailTextLabel.text = movie.detailText
        
        Task.init {
            showSpinner()
            if let image = try? await MovieController.shared.fetchImage(from: movie.imagePath) {
                imageView.image = image
            }
            self.hideSpinner()
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
