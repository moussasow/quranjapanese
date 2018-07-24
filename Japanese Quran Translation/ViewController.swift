//
//  ViewController.swift
//  Japanese Quran Translation
//
//  Created by Sow Moussa on 2018/01/03.
//  Copyright © 2018 Sow Moussa. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var surahTableView: UITableView!
    
    var mSurahList = [SurahModel]()
    var elements = ["Al-Fatiha", "ALBaqarah", "AlImran", "An-nisa"];
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        RestApiManager.sharedInstance.getSurahList { (surahList) in
            for surah in surahList {
                self.elements.append(surah.name)
            }
            
            self.mSurahList = surahList
            self.refreshTableView()
        }
    }

    func refreshTableView() -> Void {
        DispatchQueue.main.async {
            self.surahTableView.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //________________________________________________________________________________________
    // For TableView
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return mSurahList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60;
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "surahCell") as! SurahCustomTableViewCell
        
        let surah = mSurahList[indexPath.row] as SurahModel
        cell.surahName.text = surah.name + "(" + surah.nameKana + ")"
        cell.durationTime.text = surah.duration
        loadImage(imageView: cell.surahImage, url: surah.imageUrl)

        return cell
    }

    func loadImage(imageView: UIImageView, url: String) -> Void {
        DispatchQueue.main.async {
            let image_url = URL(string: url)
            if let data = try? Data(contentsOf: image_url!) {
                let image: UIImage = UIImage(data: data)!
                imageView.image = image
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showPlayer", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? PlayerViewController {
            destination.surahInfo = mSurahList[(surahTableView.indexPathForSelectedRow?.row)!]
        }
    }
}

