//
//  ShowImageViewController.swift
//  Debug App
//
//  Created by Priyank on 18/05/16.
//  Copyright © 2016 com. All rights reserved.
//

import Foundation
import UIKit

class ShowImageViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    var imageURL:String?
    override func viewDidLoad() {
        super.viewDidLoad()
        print(imageURL!)
        
        NSURLConnection.sendAsynchronousRequest(NSURLRequest(URL: NSURL(string: imageURL!)!), queue: NSOperationQueue.mainQueue()) { (response, data, error) -> Void in
            if (error == nil) {
                self.imageView.image = UIImage(data: data!)
            }
        }

    }
}