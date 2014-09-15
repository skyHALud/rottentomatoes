//
//  LoadingOverlayViewController.swift
//  rotten
//
//  Created by Swaroop Butala on 9/14/14.
//  Copyright (c) 2014 Swaroop Butala. All rights reserved.
//

import UIKit

class LoadingOverlayViewController: UIViewController {

    var loadingImageView: UIImageView!
    var images: [UIImage] = [UIImage(named: "freshTomato.png"), UIImage(named: "freshTomatoSmall.png")]

    override func viewDidLoad() {
        super.viewDidLoad()

        self.loadingImageView = UIImageView(image: UIImage(named: "freshTomato.png"))
        self.view.addSubview(loadingImageView)

        NSLog("I am here in loading  view")
        self.view.alpha = 0.8
        self.view.backgroundColor = UIColor(red: 102.0/255.0, green: 102.0/255.0, blue: 102.0/255.0, alpha: 1.0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        NSLog("I am here in loading subviews")
        var size: CGSize = self.view.bounds.size;
        var frame: CGRect;

        frame = self.loadingImageView.frame;
        frame.origin.x = floor((size.width - frame.size.width) / 2);
        frame.origin.y = floor((size.height - frame.size.height) / 2);
        self.loadingImageView.frame = frame;

        
//        frame = CGRectMake(floor((size.width - 70) / 2), floor((size.height - 70) / 2), 70, 70);
  //      self.loadingImageView = UIImageView(frame: frame)
        
        self.loadingImageView.alpha = 1.0

       /* loadingImageView.animationImages = images;
        loadingImageView.animationDuration = 1
        loadingImageView.animationRepeatCount = 3*/

//        self.view.addSubview(self.loadingImageView)
  //      loadingImageView.startAnimating()*/
        
      //  self.loadingImageView = UIImageView(image: UIImage(named: "freshTomato.png"))
    //    self.view.addSubview(self.loadingImageView)
        UIView.animateWithDuration(5, animations: {
            // Move the search bar up by its height, and hide it
//            self.loadingImageView.layer.zPosition = -100
        })
        

        
        UIView.animateWithDuration(0.5, animations: {
            var degrees = 45.0;
            var radians = CGFloat(degrees/180.0) * CGFloat(M_PI);
            self.loadingImageView.transform = CGAffineTransformMakeRotation(radians);
        })
        


    }

    func closeOverlay() {
/*            self.dismissViewControllerAnimated(true, completion: {})
            self.dismissViewControllerAnimated(TRUE, completion: <#(() -> Void)?##() -> Void#>
*/
        FCOverlay.dismissAllOverlays()
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
