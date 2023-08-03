//
//  SearchResultImage.swift
//  Livesport-assignment
//
//  Created by Alex Solonevich on 02.08.2023.
//

import SwiftUI

struct SearchResultImage: View {
    let image: Image
    let backgroundColor: Color = .white
    var height: CGFloat = 34
    
    var body: some View {
        image
            .resizable()
            .scaledToFit()
            .padding(2)
            .background(backgroundColor)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .strokeBorder(.gray.opacity(0.5), lineWidth: 0.5)
            )
            .frame(height: height)
    }
}

struct SearchResultImageNotAvailable: View {
    var width: CGFloat = 34
    var height: CGFloat = 34
    
    var body: some View {
        HStack {
            Text("n/a")
                .bold()
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .frame(width: width, height: height)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(.gray.opacity(0.5))
        )
    }
}
