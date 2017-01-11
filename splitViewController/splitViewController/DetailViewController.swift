//
//  DetailViewController.swift
//  splitViewController
//
//  Created by Pia Muñoz on 11/1/17.
//  Copyright © 2017 iOSWorkshops. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var imageView: UIView! //TODO: Ad image view
    @IBOutlet weak var textView: UIView! //TODO: Add text view
    @IBOutlet weak var switchView: UIView! //TODO:Add switch
    
    func configureView() {
        // Update the user interface for the detail item.
        if let detail = self.detailItem {

            //Use the detail in textView
            
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
        
        //Configure image, text and switch
        imageView.addImage(imageName: "dog")
        textView.addText(text: detailItem!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    var detailItem: String? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }


}

