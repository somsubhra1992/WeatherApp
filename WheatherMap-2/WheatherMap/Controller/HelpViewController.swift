//
//  HelpViewController.swift
//  WheatherMap
//
//  Created by Somsubhra Dasgupta on 12/04/21.
//  Copyright © 2021 Somsubhra. All rights reserved.
//

import UIKit
import WebKit

class HelpViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.loadWebView()
        
    }
    
    func loadWebView()
    {
        if let htmlPath = Bundle.main.path(forResource: "help", ofType: "html")
        {
            let url = URL.init(fileURLWithPath: htmlPath)
            let request = URLRequest.init(url: url)
            webView.load(request)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

class LocationDetailsCellView: UITableViewCell
{
    @IBOutlet weak var placeName: UILabel!
    @IBOutlet weak var placeLat: UILabel!
    @IBOutlet weak var placeLong: UILabel!
    @IBOutlet weak var deleteBookmark: UIButton!
}
