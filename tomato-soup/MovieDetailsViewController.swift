//
//  MovieDetailsViewController.swift
//  tomato-soup
//
//  Created by Beau Breedlove on 8/30/15.
//  Copyright (c) 2015 Tumblr. All rights reserved.
//

import UIKit

class MovieDetailsViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var synopsisLabel: UILabel!
    
    var movie: NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.text = movie["title"] as? String
        synopsisLabel.text = movie["synopsis"] as? String
        
        let imageUrlString = movie.valueForKeyPath("posters.thumbnail") as! String
        
        let url = NSURL(string: imageUrlString)!
        
        println(url)
        
        imageView.setImageWithURL(url)
        
        loadLargerPoster(imageUrlString)
    }
    
    func loadLargerPoster(imageUrlString: String) {
        var range = imageUrlString.rangeOfString(".*cloudfront.net/", options: .RegularExpressionSearch)
        if let range = range {
            println("trying this")
            var imageUrlString = imageUrlString.stringByReplacingCharactersInRange(range, withString: "https://content6.flixster.com/")
            
            println(imageUrlString)
            
            let url = NSURL(string: imageUrlString)!
            
            imageView.setImageWithURL(url)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
