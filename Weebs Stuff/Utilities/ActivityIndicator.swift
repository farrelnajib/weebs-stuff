//
//  ActivityIndicator.swift
//  Weebs Stuff
//
//  Created by Farrel Anshary on 08/07/21.
//

import SwiftUI

struct ActivityIndicator: UIViewRepresentable {
    typealias UIViewType = UIActivityIndicatorView
    
    var shouldAnimate: Bool
    
    func makeUIView(context: UIViewRepresentableContext<ActivityIndicator>) -> UIActivityIndicatorView {
        return UIActivityIndicatorView()
    }
    
    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<ActivityIndicator>) {
        if self.shouldAnimate {
            uiView.startAnimating()
        } else {
            uiView.stopAnimating()
        }
    }
}
