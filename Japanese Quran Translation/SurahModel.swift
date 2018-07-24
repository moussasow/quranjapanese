//
//  SurahModel.swift
//  Japanese Quran Translation
//
//  Created by Sow Moussa on 2018/01/05.
//  Copyright © 2018 Sow Moussa. All rights reserved.
//

import Foundation

class SurahModel: NSObject {
    var number: Int
    var name: String
    var nameKana: String
    var duration: String
    var surahDescription: String
    var imageUrl: String
    var audioUrl: String
    var videoUrl: String
    
    init(number: Int, name: String, nameKana: String, duration: String, surahDescription: String, imageUrl: String, audioUrl: String, videoUrl: String) {
        self.number = number
        self.name = name
        self.nameKana = nameKana
        self.duration = duration
        self.surahDescription = surahDescription
        self.imageUrl = imageUrl
        self.audioUrl = audioUrl
        self.videoUrl = videoUrl
    }
}
