//
//  UIView.swift
//  Test Enaza
//
//  Created by Andrew Krotov on 17/04/2019.
//  Copyright © 2019 Andrew Krotov. All rights reserved.
//

import UIKit

extension UIView {
    @discardableResult
    public func fillInContainer(_ padding: CGFloat = 0) -> UIView {
        return self.top(padding).bottom(padding).left(padding).right(padding)
    }
    
    @discardableResult
    public func centerInContainer() -> UIView {
        return self.centerVertically().centerHorizontally()
    }
    
    @discardableResult
    public func left(_ padding: CGFloat = 0) -> UIView {
        guard let superview = superview else { return self }
        
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            superview.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: padding)
        ])
        
        return self
    }
    
    @discardableResult
    public func right(_ padding: CGFloat = 0) -> UIView {
        guard let superview = superview else { return self }
        
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            superview.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: padding)
        ])
        
        return self
    }
    
    @discardableResult
    public func top(_ padding: CGFloat = 0) -> UIView {
        guard let superview = superview else { return self }
        
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            superview.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: padding)
            ])
        
        return self
    }
    
    @discardableResult
    public func bottom(_ padding: CGFloat = 0) -> UIView {
        guard let superview = superview else { return self }
        
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            superview.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: padding)
        ])
        
        return self
    }
    
    @discardableResult
    public func centerVertically() -> UIView {
        guard let superview = superview else { return self }
        
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            superview.centerYAnchor.constraint(equalTo: centerYAnchor)
            ])
        
        return self
    }
    
    @discardableResult
    public func centerHorizontally() -> UIView {
        guard let superview = superview else { return self }
        
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            superview.centerXAnchor.constraint(equalTo: centerXAnchor)
            ])
        
        return self
    }
    
    @discardableResult
    public func squareAspect() -> UIView {
        heightAnchor.constraint(equalTo: widthAnchor).isActive = true
        
        return self
    }
    
    @discardableResult
    public func height(_ padding: CGFloat = 0) -> UIView {
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: padding)
        ])
        
        return self
    }
}
