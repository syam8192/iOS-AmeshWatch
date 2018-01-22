//
//  AmeshAPI.swift
//  AmeshWatch
//
//  Created by 山上 忍 on 2018/01/22.
//

import UIKit

class AmeshAPI: NSObject {

    // http://tokyo-ame.jwa.or.jp/mesh/000/201801221110.gif

    static let scheme: String = "http"
    static let domain: String = "tokyo-ame.jwa.or.jp"
    static let path: String = "/mesh/000"
    
    static let mapBGURL: URL! = URL(string: "http://tokyo-ame.jwa.or.jp/map/map000.jpg")
    static let mapInfoURL: URL! = URL(string: "http://tokyo-ame.jwa.or.jp/map/msk000.png")


    func roundedDateTimeString(for date: Date) -> String {
        let originalMin: Int = Calendar.current.component(.minute, from: date);
        let min: Int = (originalMin / 5) * 5
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = "yyyyMMddHH"
        return dateFormatter.string(from: date) + String(format:"%02d", min)
    }

    func url(for date: Date) -> URL? {
        guard let url = URL(string: "\(AmeshAPI.scheme)://\(AmeshAPI.domain)\(AmeshAPI.path)/\(roundedDateTimeString(for: date)).gif") else {
            print("Can't generate URL. - date = \(date)")
            return nil;
        }
        return url
    }

}
