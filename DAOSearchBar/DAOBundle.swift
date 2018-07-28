//
//  DAOBundle.swift
//  DAOSearchBarDemo
//
//  Created by Ray Dan on 2018/7/28.
//  Copyright © 2018年 likeabossapp. All rights reserved.
//

import Foundation
import UIKit

class DAOBundle {
    class func podBundleImage(named: String) -> UIImage? {
        let podBundle = Bundle(for: DAOBundle.self)
        if let url = podBundle.url(forResource: "DAOSearchBar", withExtension: "bundle") {
            let bundle = Bundle(url: url)
            let image = UIImage(named: named, in: bundle, compatibleWith: nil)!.withRenderingMode(.alwaysTemplate)
            return image
        }
        return nil
    }
}
