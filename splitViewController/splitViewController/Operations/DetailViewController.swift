//
//  DetailViewController.swift
//  splitViewController
//
//  Created by Pia Muñoz on 11/1/17.
//  Copyright © 2017 iOSWorkshops. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    //MARK: - IBOutlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var switchView: UISwitch!
    @IBOutlet weak var textView: UITextView!
    
    //MARK: - Stored properties
    var rowNumber: CLong? = nil

    //MARK: - UIViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        textView.setContentOffset(CGPoint.zero, animated: false)
        textView.scrollRangeToVisible(NSMakeRange(0, 0))
    }
    
    //MARK: - Configure UI
    func configureView() {
        // Update the user interface for the detail item.
        if let text = self.textItem,
            let textView = self.textView {
            textView.text = text
            textView.font = UIFont.systemFont(ofSize: 16)
        }
        
        if let image = self.imageItem,
            let imageView = self.imageView {
            imageView.image = image
        }
        
        if let switchValue = self.switchItem,
            let switchView = self.switchView {
            switchView.isHidden = false
            switchView.setOn(switchValue, animated: false)
        }
    }
    
    var textItem: String? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }
    
    var imageItem: UIImage? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }
    
    var switchItem: Bool? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }
}

extension DetailViewController: SynchroDelegate {
    func switchValueChangedTo(_ value: Bool) {
        switchView.setOn(value, animated: true)
    }
}
