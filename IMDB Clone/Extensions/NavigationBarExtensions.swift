//
//  NavigationBarExtensions.swift
//  IMDB Clone
//
//  Created by Konstantin Kostadinov on 18.07.21.
//

import Foundation
import UIKit

extension UINavigationBar {
    func setNavigationStyle(style: UIBarStyle) {
        self.barStyle = style
        self.shadowImage = UIImage()
        self.setBackgroundImage(UIImage(), for: UIBarMetrics.default)

        switch style {
        case .black:
            self.barTintColor = UIColor.gray
            self.tintColor = .gray

        case .default:
            self.barTintColor = UIColor.gray
            self.tintColor = .gray

        default: break
        }
    }

    func applyHorizontalGragient(colors: [CGColor], startPoint: CGPoint, endPoint: CGPoint, locations: [NSNumber]? = nil) {
        self.setNavigationStyle(style: .black)
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors

        var bounds = self.bounds
        bounds.size.height += UIApplication.shared.statusBarFrame.size.height
        bounds.size.height = bounds.size.height.rounded(.up)
        gradientLayer.frame = bounds

        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        gradientLayer.locations = locations

        if let image = UIImage.getImageFrom(gradientLayer: gradientLayer) {
            self.setBackgroundImage(image, for: .default)
        }
        self.layer.borderWidth = 0
    }

    func applyHorizontalGradientForPatientDetails() {
        let leftColor = UIColor(named: "Yasen Alexandrite Left") ?? UIColor.yellow
        let rightColor = UIColor(named: "Yasen Alexandrite Right") ?? UIColor.yellow
        self.applyHorizontalGragient(colors: [leftColor.cgColor, rightColor.cgColor],
                                     startPoint: CGPoint(x: 0.0,y: 0.5),
                                     endPoint: CGPoint(x: 1,y: 0.5),
                                     locations: [NSNumber(value: 0.5), NSNumber(value: 1.0)])
    }

}
