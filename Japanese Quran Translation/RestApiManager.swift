//
//  RestApiManager.swift
//  Audio Streaming
//
//  Created by Sow Moussa on 2018/01/05.
//  Copyright © 2018年 Sow Moussa. All rights reserved.
//

import Foundation

typealias ServiceResponse = (NSData, NSError) -> Void

class RestApiManager: NSObject {
    static let sharedInstance = RestApiManager()
    
    let baseUrl = "http://afrinux.pythonanywhere.com/api/surah/list"

    func getSurahList(completion:@escaping (_ surahList: [SurahModel]) -> Void) {
        let request = NSMutableURLRequest(url: NSURL(string: baseUrl)! as URL)
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            var surahList = [SurahModel]()

            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                let jsonData = json as AnyObject                
                let contents = (jsonData["contents"] as? NSArray)
                
                
                for surah in contents! {
                    let surahData = surah as! NSDictionary
                    let number = (surahData["number"] as? Int)
                    let name = (surahData["name"] as? String)
                    let nameKana = (surahData["name_kana"] as? String)
                    let duration = (surahData["duration"] as? String)
                    let descript = (surahData["description"] as? String)
                    let imageUrl = (surahData["image_url"] as? String)
                    let audioUrl = (surahData["audio_url"] as? String)
                    let videoUrl = (surahData["video_url"] as? String)
                    
                    surahList.append(SurahModel(number: number!, name: name!, nameKana: nameKana!, duration: duration!, surahDescription: descript!, imageUrl: imageUrl!, audioUrl: audioUrl!, videoUrl: videoUrl!))
                    
                }
            } catch {
                print(error)
            }
            
            completion(surahList)
        }
        
        task.resume()
        
    }
}


        
