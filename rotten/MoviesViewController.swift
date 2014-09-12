//
//  MoviesViewController.swift
//  rotten
//
//  Created by Swaroop Butala on 9/11/14.
//  Copyright (c) 2014 Swaroop Butala. All rights reserved.
//

import UIKit

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var moviesSearchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var movies: [NSDictionary] = []
    var lastIndexRowRequestedForTableView = -1
    var searchBarHidden = false;
    var isPreviousDirectionscrollUp = true;
    var scrollDirectionChanged = false;
    var doThisOnceFlag = true;

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        // Show the loading screen here..

        // Do any additional setup after loading the view.
        var url = "http://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json?apikey=axku2sndnpg2d6dhjw59wj3d&limit=20&country=us"
        var request = NSURLRequest(URL: NSURL(string: url))
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()){ (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            var object = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as NSDictionary
            self.movies = object["movies"] as [NSDictionary]


            // Hide the laoding screen here

            self.tableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count;
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

        if (lastIndexRowRequestedForTableView == 0 && indexPath.row == 4) {
            return cell
        }
        // I want to hide the search bar when the user is trying to scroll up, but show the search 
        // bar when the user is trying to scroll down. I can potentially figure that out by 
        // checking what was requested last. Based on that I can figure out if the user is 
        // scrolling up or down.
        if (indexPath.row > lastIndexRowRequestedForTableView) {
            if (isPreviousDirectionscrollUp) {
                scrollDirectionChanged = false
            } else {
                scrollDirectionChanged = true
            }
            isPreviousDirectionscrollUp = true;
        } else {
            if (isPreviousDirectionscrollUp) {
                scrollDirectionChanged = true
            } else {
                scrollDirectionChanged = false
            }
            isPreviousDirectionscrollUp = false
        }

        if (isPreviousDirectionscrollUp && scrollDirectionChanged) {
            // User is scrolling down, and hence animate to hide the search bar
            UIView.animateWithDuration(0.4, animations: {
                // Move the search bar up by its height, and hide it
                var moviesSearchBarFrame = self.moviesSearchBar.frame
                moviesSearchBarFrame.origin.y -= moviesSearchBarFrame.height
                self.moviesSearchBar.frame = moviesSearchBarFrame
                self.moviesSearchBar.alpha = 0.0
                self.searchBarHidden = true;

                // Increase the size of the table view
                var moviesTableViewFrame = self.tableView.frame
                moviesTableViewFrame.origin.y -= moviesSearchBarFrame.height
                
                var bound = CGRectMake(0, moviesTableViewFrame.origin.y, moviesTableViewFrame.width, moviesTableViewFrame.height + moviesSearchBarFrame.height)
                self.tableView.frame = bound
            })
        } else if (!isPreviousDirectionscrollUp && scrollDirectionChanged){
            // User is scrolling up, its a swipe down, and hence animate to show the search bar
            UIView.animateWithDuration(0.4, animations: {
                // Move the search bar down by its height, and show it
                var moviesSearchBarFrame = self.moviesSearchBar.frame
                moviesSearchBarFrame.origin.y += moviesSearchBarFrame.height
                self.moviesSearchBar.frame = moviesSearchBarFrame
                self.moviesSearchBar.alpha = 1.0
                self.searchBarHidden = false;
                
                // Reduce the size of the table view
                var moviesTableViewFrame = self.tableView.frame
                moviesTableViewFrame.origin.y += moviesSearchBarFrame.height
                
                var bound = CGRectMake(0, moviesTableViewFrame.origin.y, moviesTableViewFrame.width, moviesTableViewFrame.height - moviesSearchBarFrame.height)
                self.tableView.frame = bound
            })
        }
        lastIndexRowRequestedForTableView = indexPath.row
        if (indexPath.row == 4 && doThisOnceFlag) {
            println("heyhey")
            lastIndexRowRequestedForTableView = 0
            isPreviousDirectionscrollUp = false
            doThisOnceFlag = false
        }
        return cell
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
