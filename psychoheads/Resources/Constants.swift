//
//  Constants.swift
//  psychoheads
//
//  Created by Ryan Pavlovicz on 6/26/25.
//


//
//  Constants.swift
//  psychoheads
//
//  Created by Ryan Pavlovicz on 3/11/23.
//

import Foundation

struct Constants {
    
    static var clown: String = "🤡"
    static var man: String = "🚹"
    static var woman: String = "🚺"
    static var trans: String = "⚧️"
    static var white: String = "👱‍♂️"
    static var black: String = "👨🏿"
    static var latino: String = "👨🏽"
    static var asian: String = "👲"
    static var indian: String = "👳🏾"
    static var native: String = "🪶"
    static var blackAndWhite: String = "🏁"
    static var lookingUpperLeft: String = "↖️"
    static var lookingUp: String = "⬆️"
    static var lookingUpperRight: String = "↗️"
    static var lookingLeft: String = "⬅️"
    static var lookingFullFace: String = "⏺️"
    static var lookingRight: String = "➡️"
    static var lookingLowerLeft: String = "↙️"
    static var lookingDown: String = "⬇️"
    static var lookingLowerRight: String = "↘️"
    
    let now = Date()
    let calendar = Calendar.current
    let formatter: DateFormatter
    
    
    func getCurrentYear() -> Int {
        return calendar.component(.year, from: now)
    }
    
    init() {
        formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    }
}
