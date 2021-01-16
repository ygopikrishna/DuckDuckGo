//
//  ContentDetailViewController.swift
//  DuckDuckGo
//
//  Created by Gopi Krishna on 11/19/19.
//  Copyright © 2019 iCreditWorks. All rights reserved.
//

import UIKit

class ContentDetailViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    
    let device = UIDevice.current.userInterfaceIdiom
    
    var content: ContentObject! {
        didSet {
            if device == .pad {
                configureView()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if device == .phone {
            configureView()
        }
    }
    
    func configureView() {
        if let imageUrl = URL(string: content.Icon.URL) {
            imageView.image = UIImage(url: imageUrl)
        } else {
            imageView.image = UIImage(named: "PlaceHolder")
        }
        titleLabel.text = content.Text
        descLabel.text = content.Result
    }

}

extension UIImage {
    convenience init?(url: URL?) {
        guard let url = url else { return nil }
        
        do {
            let data = try Data(contentsOf: url)
            self.init(data: data)
        } catch {
            print("Cannot load image from url: \(url) with error: \(error)")
            return nil
        }
    }
}
