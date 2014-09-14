//
//  MovieDetailViewController.swift
//  rotten
//
//  Created by Swaroop Butala on 9/13/14.
//  Copyright (c) 2014 Swaroop Butala. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    @IBOutlet weak var movieDetailView: UIView!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var synopsisLabel: UILabel!
    @IBOutlet weak var tomatoScoreLabel: UILabel!
    var movie: NSDictionary?
    
    var movieDetailViewTrayOpen = false
    var movieDetailViewOriginalPosition = 0

    @IBOutlet var movieTitleTapRecognizer: UITapGestureRecognizer!
    @IBOutlet var swipeUpGestureRecognizer: UISwipeGestureRecognizer!

    @IBOutlet var swipeDownGestureRecognizer: UISwipeGestureRecognizer!


    override func viewDidLoad() {
        super.viewDidLoad()

//        var request = NSURLRequest(URL: NSURL(string: "http://content7.flixster.com/movie/11/17/88/11178889_tmb.jpg"))

//        var cachedThumbnail = AFImageCache.cachedImageForRequest(request)
//        posterImageView.setImageWithURL(NSURL(string: "http://content7.flixster.com/movie/11/17/88/11178889_ptr.jpg"), cachedThumbnail)
/*//        posterImageView.setImageWithURL(NSURL(string: "http://content7.flixster.com/movie/11/17/88/11178889_ptr.jpg"))
        posterImageView.setImageWithURL(url: NSURL(string: "http://content7.flixster.com/movie/11/17/88/11178889_ptr.jpg"), placeholderImage: AFImageCache.cachedImageForRequest(request))
//        posterImageView.setImageWithURL(NSURL(string: "http://content7.flixster.com/movie/11/17/88/11178889_ptr.jpg"), AFImageCache.cachedImageForRequest(request))
*/


//        AFImageCache.cachedImageForRequest(request)
        // Do any additional setup after loading the view.
        
        // Set all the information about the movies
        var posters = self.movie!["posters"] as NSDictionary
        var posterUrl = posters["thumbnail"] as String
        let originalUrl = posterUrl.stringByReplacingOccurrencesOfString("tmb", withString: "ori")
        
        posterImageView.setImageWithURL(NSURL(string: originalUrl))

        var movieTitle = self.movie!["title"] as? String
        movieTitleLabel.text = movieTitle
        ratingLabel.text = self.movie!["mpaa_rating"] as? String
        synopsisLabel.text = self.movie!["synopsis"] as? String
        synopsisLabel.numberOfLines = 0
        synopsisLabel.sizeToFit()
        var ratings = movie!["ratings"] as NSDictionary
        var criticsScore = ratings["critics_score"] as NSInteger
        var audienceScore = ratings["audience_score"] as NSInteger
        tomatoScoreLabel.text = "Critics Score: \(criticsScore) Audience Score: \(audienceScore)"
        movieTitleTapRecognizer.addTarget(self, action: "tappedMovieTitleView")
        swipeUpGestureRecognizer.addTarget(self, action: "tappedMovieTitleView")
        swipeDownGestureRecognizer.addTarget(self, action: "tappedMovieTitleView")
        
        NSLog("hey hey \(movieTitle!)")
        self.navigationController!.navigationItem.title = "hey hey"
        self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor(red: 218.0/255.0, green: 165.0/255.0, blue: 32.0/255.0, alpha: 1.0)]
        
    }

    func tappedMovieTitleView() {
        UIView.animateWithDuration(0.4, animations: {
            // Move the search bar up by its height, and hide it
            var movieDetailViewFrame = self.movieDetailView.frame
            if (!self.movieDetailViewTrayOpen) {
                self.movieDetailViewOriginalPosition = Int(movieDetailViewFrame.origin.y)
                movieDetailViewFrame.origin.y = 60
                self.movieDetailViewTrayOpen = true
            } else {
                movieDetailViewFrame.origin.y = CGFloat(self.movieDetailViewOriginalPosition)
                self.movieDetailViewTrayOpen = false
            }
            self.movieDetailView.frame = movieDetailViewFrame
        })
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
