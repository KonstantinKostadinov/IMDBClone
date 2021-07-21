//
//  UIImageViewExtensions.swift
//  IMDB Clone
//
//  Created by Konstantin Kostadinov on 21.07.21.
//

import Foundation
import UIKit

extension UIImageView {
    func addOverlay() {
        let overlay: UIView = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.size.width + 15, height: self.frame.size.height))
        overlay.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.5)
        let playImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        playImage.center = overlay.center
        playImage.image = UIImage(named: "playIcon")
        overlay.addSubview(playImage)
        self.addSubview(overlay)
        
    }
}
