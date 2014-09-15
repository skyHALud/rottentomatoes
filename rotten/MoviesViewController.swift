//
//  MoviesViewController.swift
//  rotten
//
//  Created by Swaroop Butala on 9/11/14.
//  Copyright (c) 2014 Swaroop Butala. All rights reserved.
//

import UIKit

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    @IBOutlet weak var networkErrorLabel: UILabel!
    @IBOutlet weak var moviesSearchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!

    var movies: [NSDictionary] = []
    var lastIndexRowRequestedForTableView = -1
    var searchBarHidden = false;
    var isPreviousDirectionscrollUp = true;
    var scrollDirectionChanged = false;
    var doThisOnceFlag = true;
    var refreshControl:UIRefreshControl!
//    var loadingOverlayViewController:LoadingOverlayViewController = LoadingOverlayViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        // Show the loading screen here.
        // FCOverlay.presentOverlayWithViewController(self.loadingOverlayViewController, windowLevel: UIWindowLevelAlert, animated: false, completion: nil)

        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), {
            self.loadMovies(false)
            
            dispatch_async(dispatch_get_main_queue(), {
                MBProgressHUD.hideHUDForView(self.view, animated: true)
                return
            })
        })
            
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refersh")
        self.refreshControl.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(self.refreshControl)

        // self.loadingOverlayViewController.transitioningDelegate = self.transitioningDelegate;
    }
    
    func loadMovies(isRefreshing: Bool) {
        // Do any additional setup after loading the view.
        var url = "http://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json?apikey=axku2sndnpg2d6dhjw59wj3d&limit=20&country=us"
        var request = NSURLRequest(URL: NSURL(string: url))
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()){ (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            if ((error) != nil) {
                self.moviesSearchBar.hidden = true
                self.networkErrorLabel.hidden = false
                if (isRefreshing) {
                    self.refreshControl.endRefreshing()
                }
            } else {
                var object = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as NSDictionary
                self.movies = object["movies"] as [NSDictionary]
                self.tableView.reloadData()
                if (isRefreshing) {
                    self.refreshControl.endRefreshing()
                }
                self.moviesSearchBar.hidden = false
                self.networkErrorLabel.hidden = true
            }
//            self.loadingOverlayViewController.closeOverlay()
        }

    }

    func refresh() {
        loadMovies(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func handleSwipeEvent(gesture: UISwipeGestureRecognizer) {
        
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count;
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var movieDetailViewController: MovieDetailViewController = segue.destinationViewController as MovieDetailViewController
        var movieIndex = tableView.indexPathForSelectedRow()!.row
        var selectedMovie = self.movies[movieIndex]
        movieDetailViewController.movie = selectedMovie
        self.view.endEditing(true);
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        println("Hello I am at row \(indexPath.row) and section \(indexPath.section)")
        var cell = tableView.dequeueReusableCellWithIdentifier("MovieCell") as MovieCell
        
        var movie = movies[indexPath.row]
        cell.titleLabel.text = movie["title"] as? String
        cell.synopsisLabel.text = movie["synopsis"] as? String
        
        var posters = movie["posters"] as NSDictionary
        var posterUrl = posters["thumbnail"] as String
        var ratings = movie["ratings"] as NSDictionary
        var criticsRating = ratings["critics_rating"] as NSString
        var criticsScore = ratings["critics_score"] as NSInteger
        var range = criticsRating.rangeOfString("Fresh") as NSRange
        var tomatoIcon: String
        if (range.location != NSNotFound) {
            tomatoIcon = "freshTomato.png"
        } else {
            tomatoIcon = "splashTomato.png"
        }

        cell.posterView.setImageWithURL(NSURL(string: posterUrl))
        cell.tomatoIconView.image = UIImage(named: tomatoIcon)
        cell.rottenScoreLabel.text = "\(criticsScore)%"
        cell.ratingLabel.text = movie["mpaa_rating"] as? String

        return cell
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {


        var translation = scrollView.panGestureRecognizer.translationInView(scrollView)
        self.view.endEditing(true);
        if(translation.y > 0) {
            NSLog("Did Scroll down");
            // react to dragging down
            if self.searchBarHidden {
                UIView.animateWithDuration(0.4, animations: {
                    // Move the search bar up by its height, and hide it
                    var moviesSearchBarFrame = self.moviesSearchBar.frame
                    moviesSearchBarFrame.origin.y += moviesSearchBarFrame.height
                    self.moviesSearchBar.frame = moviesSearchBarFrame
                    self.moviesSearchBar.alpha = 1.0
                    
                    // Increase the size of the table view
                    var moviesTableViewFrame = self.tableView.frame
                    moviesTableViewFrame.origin.y += moviesSearchBarFrame.height
                    self.tableView.frame = moviesTableViewFrame
                    self.searchBarHidden = false;
                })
            }
        } else {
            NSLog("Did Scroll up");
            // react to dragging up
            // User is scrolling down, and hence animate to hide the search bar
            if !self.searchBarHidden {
                UIView.animateWithDuration(0.4, animations: {
                    // Move the search bar up by its height, and hide it
                    var moviesSearchBarFrame = self.moviesSearchBar.frame
                    moviesSearchBarFrame.origin.y -= moviesSearchBarFrame.height
                    self.moviesSearchBar.frame = moviesSearchBarFrame
                    self.moviesSearchBar.alpha = 0.0
                    
                    // Increase the size of the table view
                    var moviesTableViewFrame = self.tableView.frame
                    moviesTableViewFrame.origin.y -= moviesSearchBarFrame.height
                    self.tableView.frame = moviesTableViewFrame
                    self.searchBarHidden = true;
                })
            }
        }
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
