//
//  CMTime+Duration.swift
//  Japanese Quran Translation
//
//  Created by Sow Moussa on 2018/01/13.
//  Copyright © 2018 Sow Moussa. All rights reserved.
//

import Foundation
import AVFoundation

extension CMTime {
    var durationText:String {
        let totalSeconds = CMTimeGetSeconds(self)
        let hours:Int = Int(totalSeconds.truncatingRemainder(dividingBy: 86400) / 3600)
        let minutes:Int = Int(totalSeconds.truncatingRemainder(dividingBy: 3600) / 60)
        let seconds:Int = Int(totalSeconds.truncatingRemainder(dividingBy: 60))
        
        return String(format: "%i:%02i:%02i", hours, minutes, seconds)
    }
    
    var durationSeconds:Float {
        return Float(CMTimeGetSeconds(self))
    }
    
}
