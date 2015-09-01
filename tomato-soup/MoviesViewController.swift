//
//  MoviesViewController.swift
//  tomato-soup
//
//  Created by Beau Breedlove on 8/30/15.
//  Copyright (c) 2015 Tumblr. All rights reserved.
//

import UIKit

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var movies: [NSDictionary]?
    
    var errorMessage: String?
    
    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "onRefresh", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
        
        self.getMoviesFromServer()
    }
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
    func onRefresh() {
        getMoviesFromServer()
//        delay(2, closure: {
//            self.refreshControl.endRefreshing()
//        })
    }
    
    func getMoviesFromServer() {
        // let url = NSURL(string: "http://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json?limit=20&country=us")!
        
        var urlString = "https://gist.githubusercontent.com/timothy1ee/d1778ca5b944ed974db0/raw/489d812c7ceeec0ac15ab77bf7c47849f2d1eb2b/gistfile1.json"
        
        let url = NSURL(string: urlString)!
        let request = NSURLRequest(URL: url)
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            
            if ((response as! NSHTTPURLResponse).statusCode == 200) {
                let json = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as? NSDictionary
                
                if let json = json {
                    self.movies = json["movies"] as? [NSDictionary]
                }
                
                self.dismissError()
            } else {
                self.showError("There was a network error")
            }
            
            self.refreshControl.endRefreshing()
            
            self.tableView.dataSource = self
            self.tableView.delegate = self
            self.tableView.reloadData()
        }
    }
    
    func showError(errorMessage: String) {
        self.errorMessage = errorMessage
        self.tableView.reloadData()
    }
    
    func dismissError() {
        self.errorMessage = nil
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let  errorCell = tableView.dequeueReusableCellWithIdentifier("ErrorCell") as! ErrorCell
        
        errorCell.backgroundColor = UIColor.cyanColor()
        errorCell.errorLabel.text = errorMessage
        
        return errorCell
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if errorMessage == nil {
            return 0
        } else {
            return 40.0
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let movies = movies {
            return movies.count
        } else {
            return 0;
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("MovieCell", forIndexPath: indexPath) as! MovieCell
        
        let movie = movies![indexPath.row]
        
        cell.titleLabel.text = movie["title"] as? String
        cell.synopsisLabel.text = movie["synopsis"] as? String
        
        let url = NSURL(string: movie.valueForKeyPath("posters.thumbnail") as! String)!
        
        cell.posterView.setImageWithURL(url)
        
        return cell
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        // TODO: This doesn't deselect the cell when the back button is hit from the MovieDetailView
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPathForCell(cell)!
        
        let movie = movies![indexPath.row]
        
        let movieDetailsViewController = segue.destinationViewController as!MovieDetailsViewController
        
        movieDetailsViewController.movie = movie
        
    }

}
