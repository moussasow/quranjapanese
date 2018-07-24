//
//  Helper.swift
//  Japanese Quran Translation
//
//  Created by Sow Moussa on 2018/01/10.
//  Copyright © 2018 Sow Moussa. All rights reserved.
//

import Foundation
import UIKit

class Helper {
    
    static func loadImage(imageView: UIImageView, url: String) -> Void {
        DispatchQueue.main.async {
            let image_url = URL(string: url)
            if let data = try? Data(contentsOf: image_url!) {
                let image: UIImage = UIImage(data: data)!
                imageView.image = image
            }
        }
    }
}
