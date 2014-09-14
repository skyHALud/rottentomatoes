//
//  MovieDetailViewController.swift
//  rotten
//
//  Created by Swaroop Butala on 9/13/14.
//  Copyright (c) 2014 Swaroop Butala. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {

    @IBOutlet weak var posterImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        posterImageView.setImageWithURL(NSURL(string: "http://content7.flixster.com/movie/11/17/88/11178889_tmb.jpg"))
        posterImageView.setImageWithURL(NSURL(string: "http://content7.flixster.com/movie/11/17/88/11178889_ptr.jpg"))

        var request = NSURLRequest(URL: NSURL(string: "http://content7.flixster.com/movie/11/17/88/11178889_tmb.jpg"))

//        var cachedThumbnail = AFImageCache.cachedImageForRequest(request)
//        posterImageView.setImageWithURL(NSURL(string: "http://content7.flixster.com/movie/11/17/88/11178889_ptr.jpg"), cachedThumbnail)
/*//        posterImageView.setImageWithURL(NSURL(string: "http://content7.flixster.com/movie/11/17/88/11178889_ptr.jpg"))
        posterImageView.setImageWithURL(url: NSURL(string: "http://content7.flixster.com/movie/11/17/88/11178889_ptr.jpg"), placeholderImage: AFImageCache.cachedImageForRequest(request))
//        posterImageView.setImageWithURL(NSURL(string: "http://content7.flixster.com/movie/11/17/88/11178889_ptr.jpg"), AFImageCache.cachedImageForRequest(request))
*/


//        AFImageCache.cachedImageForRequest(request)
        // Do any additional setup after loading the view.
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
