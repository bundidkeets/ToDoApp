//
//  GradientView.swift
//  ToDoApp
//
//  Created by Bundid on 26/11/2565 BE.
//

import UIKit

@IBDesignable
class GradientView: UIView {

    @IBInspectable var startColor: UIColor = UIColor.clear {
        didSet {
            updateView()
        }
    }

    @IBInspectable var endColor: UIColor = UIColor.clear {
        didSet {
            updateView()
        }
    }

    @IBInspectable var isHorizontal: Bool = true {
        didSet {
            updateView()
        }
    }

    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }

    func updateView() {
        guard let layer = layer as? CAGradientLayer else {
            return
        }

        layer.colors = [startColor, endColor].map { $0.cgColor }
        if self.isHorizontal {
            layer.startPoint = CGPoint(x: 0, y: 0.5)
            layer.endPoint = CGPoint(x: 1, y: 0.5)
        } else {
            layer.startPoint = CGPoint(x: 0.5, y: 0)
            layer.endPoint = CGPoint(x: 0.5, y: 1)
        }
    }
}
