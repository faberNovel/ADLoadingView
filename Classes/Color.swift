//
//  Color.swift
//  ADLoadingViewSample
//
//  Created by Edouard Siegel on 03/03/16.
//
//

import UIKit

extension UIColor {
    static var mainApplidiumColor: UIColor {
        return colorWithString(ADTargetSettings.shared().applidium_blue1)
    }

    private static func colorWithString(_ hexColor: String) -> UIColor {
        var color:CUnsignedInt = 0
        let scanner = Scanner(string: hexColor)
        scanner.scanHexInt32(&color)
        NSLog("scanned : \(color)")
        let divider:Float = 255
        return UIColor(red: CGFloat(((Float)((color & 0xFF0000) >> 16)) / divider),
            green: CGFloat(((Float)((color & 0xFF00) >> 8)) / divider),
            blue: CGFloat(((Float)((color & 0xFF))) / divider),
            alpha: 1.0)
    }
}
