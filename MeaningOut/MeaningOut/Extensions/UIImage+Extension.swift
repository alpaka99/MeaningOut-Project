//
//  CGSize+Extension.swift
//  MeaningOut
//
//  Created by user on 6/15/24.
//

import UIKit

extension UIImage {
    func resizeImage(withSize size: CGSize) -> UIImage {
        let image = UIGraphicsImageRenderer(size: size).image { _ in
            draw(in: CGRect(
                origin: .zero,
                size: size
            ))
        }
        
        return image.withRenderingMode(self.renderingMode)
    }
}
