//
//  VideoViewController.swift
//  Japanese Quran Translation
//
//  Created by Sow Moussa on 2018/01/19.
//  Copyright © 2018 Sow Moussa. All rights reserved.
//

import UIKit
import WebKit

class VideoViewController: UIViewController {

    @IBOutlet weak var webview: WKWebView!
    var videoCode : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        NSLog(videoCode)
        let videoUrl = URL(string: "https://www.youtube.com/embed/" + videoCode)
        let request = URLRequest(url: videoUrl!)
        webview.load(request)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
