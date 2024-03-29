//
//  MoviesViewController.swift
//  rotten
//
//  Created by Swaroop Butala on 9/11/14.
//  Copyright (c) 2014 Swaroop Butala. All rights reserved.
//

import UIKit

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UITabBarDelegate {

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    @IBOutlet weak var networkErrorLabel: UILabel!
    @IBOutlet weak var moviesSearchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var moviesTabBarItem: UITabBarItem!
    @IBOutlet weak var dvdsTabBarItem: UITabBarItem!
    @IBOutlet weak var tabBar: UITabBar!

    var movies: [NSDictionary] = []
    var newIndexRowRequestedForTableView = false
    var searchBarHidden = false
    var isPreviousDirectionscrollUp = true;
    var scrollDirectionChanged = false;
    var doThisOnceFlag = true
    var refreshControl:UIRefreshControl!
    var inSearchMode = false
    var searchedMovies: [NSDictionary] = []
    var moviesTabBarSelected = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        moviesSearchBar.delegate = self
        tabBar.delegate = self
        
        // Show the loading screen here.
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), {
            self.loadMovies(false)
            dispatch_async(dispatch_get_main_queue(), {
                MBProgressHUD.hideHUDForView(self.view, animated: true)
                return
            })
        })

        self.refreshControl = UIRefreshControl()
        var attributedString = NSMutableAttributedString(string: "Pull down to refersh")
        attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.grayColor(), range: NSMakeRange(0, attributedString.length))
        self.refreshControl.attributedTitle = attributedString
        self.refreshControl.tintColor = UIColor(red: 218.0/255.0, green: 165.0/255.0, blue: 32.0/255.0, alpha: 1.0)
        self.refreshControl.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(self.refreshControl)

        tabBar.selectedImageTintColor = UIColor(red: 218.0/255.0, green: 165.0/255.0, blue: 32.0/255.0, alpha: 1.0)
        tabBar.selectedItem = moviesTabBarItem
    }
    
    func makeAPIRequest(isRefreshing: Bool, request: NSURLRequest) {
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
        }
    }
    
    func loadMovies(isRefreshing: Bool) {
        // Do any additional setup after loading the view.
        var url = "http://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json?apikey=axku2sndnpg2d6dhjw59wj3d&limit=20&country=us"
        var request = NSURLRequest(URL: NSURL(string: url))
        makeAPIRequest(isRefreshing, request: request)
    }
    
    func loadDvds(isRefreshing: Bool) {
        // Do any additional setup after loading the view.
        var url = "http://api.rottentomatoes.com/api/public/v1.0/lists/dvds/top_rentals.json?apikey=axku2sndnpg2d6dhjw59wj3d&page_limit=20&country=us"
        var request = NSURLRequest(URL: NSURL(string: url))
        makeAPIRequest(isRefreshing, request: request)
    }
    
    func searchMovies(searchTerm: String) {
        // Do any additional setup after loading the view.
        var escapedSearchTerm = searchTerm.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
        var url = "http://api.rottentomatoes.com/api/public/v1.0/movies.json?q=\(escapedSearchTerm!)&page_limit=20&apikey=axku2sndnpg2d6dhjw59wj3d&country=us"
        var request = NSURLRequest(URL: NSURL(string: url))
        makeAPIRequest(false, request: request)
    }
    
    
    func searchBar(searchBar: UISearchBar!, textDidChange searchText: String!){
        if (searchText == "") {
            NSLog("Empty seach text")
            self.inSearchMode = false
            loadMovies(false)
            return
        }
        self.inSearchMode = true

        searchMovies(searchText)
        NSLog(searchText)
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        self.inSearchMode = false
        searchedMovies = []
        self.tableView.reloadData()
        self.view.endEditing(true);
    }
    
    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem!) {
        if (item.title == "Movies") {
            self.moviesTabBarSelected = true
            self.navigationItem.title = "Movies"
            loadMovies(false)
        } else {
            self.moviesTabBarSelected = false
            self.navigationItem.title = "DVDs"
            loadDvds(false)
        }
    }
    
    func refresh() {
        if (self.moviesTabBarSelected) {
            loadMovies(true)
        } else {
            loadDvds(true)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func handleSwipeEvent(gesture: UISwipeGestureRecognizer) {
        
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count;
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var movieDetailViewController: MovieDetailViewController = segue.destinationViewController as MovieDetailViewController
        var movieIndex = tableView.indexPathForSelectedRow()!.row
        self.tableView.deselectRowAtIndexPath(tableView.indexPathForSelectedRow()!, animated: false)
        var selectedMovie = self.movies[movieIndex]
        movieDetailViewController.movie = selectedMovie
        self.view.endEditing(true);
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        println("Hello I am at row \(indexPath.row) and section \(indexPath.section)")
        var cell = tableView.dequeueReusableCellWithIdentifier("MovieCell") as MovieCell

        var loadMovies = self.movies
        var movie = loadMovies[indexPath.row]
        cell.titleLabel.text = movie["title"] as? String
        cell.synopsisLabel.text = movie["synopsis"] as? String
        
        var posters = movie["posters"] as NSDictionary
        var posterUrl = posters["thumbnail"] as String
        var ratings = movie["ratings"] as NSDictionary
        var criticsRating: NSString = ""
        if ((ratings["critics_rating"]) != nil) {
            criticsRating = ratings["critics_rating"]? as NSString
        }

        var criticsScore = ratings["critics_score"] as NSInteger
        var range = criticsRating.rangeOfString("Fresh") as NSRange
        var tomatoIcon: String
        if (range.location != NSNotFound) {
            tomatoIcon = "freshTomato.png"
        } else {
            tomatoIcon = "splashTomato.png"
        }

        cell.posterView.alpha=0
        cell.posterView.setImageWithURL(NSURL(string: posterUrl))

        // Fade in the thumbnail images
        UIView.animateWithDuration(0.3, animations: {
            cell.posterView.alpha = 1
        })
        cell.tomatoIconView.image = UIImage(named: tomatoIcon)
        cell.rottenScoreLabel.text = "\(criticsScore)%"
        cell.ratingLabel.text = movie["mpaa_rating"] as? String

        self.newIndexRowRequestedForTableView = true
        return cell
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        var translation = scrollView.panGestureRecognizer.translationInView(scrollView)
        self.view.endEditing(true);
        if (self.newIndexRowRequestedForTableView) {
            self.newIndexRowRequestedForTableView = false
            if(translation.y > 0) {
                // react to dragging down
                if self.searchBarHidden {
                    self.searchBarHidden = false;
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
                        
                        // Show the tabbar
                        var tabBarFrame = self.tabBar.frame
                        tabBarFrame.origin.y -= tabBarFrame.height
                        self.tabBar.frame = tabBarFrame
                        self.tabBar.alpha = 1.0
                    })
                }
            } else {
                // react to dragging up
                // User is scrolling down, and hence animate to hide the search bar
                if !self.searchBarHidden {
                    self.searchBarHidden = true;
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
                        
                        var tabBarFrame = self.tabBar.frame
                        tabBarFrame.origin.y += tabBarFrame.height
                        self.tabBar.frame = tabBarFrame
                        self.tabBar.alpha = 0.0
                    })
                }
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
