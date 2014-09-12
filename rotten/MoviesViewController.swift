//
//  MoviesViewController.swift
//  rotten
//
//  Created by Swaroop Butala on 9/11/14.
//  Copyright (c) 2014 Swaroop Butala. All rights reserved.
//

import UIKit

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var movies: [NSDictionary] = []

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
        //cell.posterView.setImageWithURL(NSURL(string: posterUrl))
        cell.tomatoIconView.image = UIImage(named: tomatoIcon)
        cell.rottenScoreLabel.text = "\(criticsScore)%"
        cell.ratingLabel.text = movie["mpaa_rating"] as? String

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
