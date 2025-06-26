//
//  WrappingHStack.swift
//  Cellar
//
//  Created by Dani on 24/6/24.
//

import SwiftUI

//struct WrappingHStack<Content: View>: View {
//    @ViewBuilder var content: Content
//    
//    @State private var totalHeight: CGFloat = .infinity
//
//    var body: some View {
//        VStack {
//            GeometryReader { geometry in
//                self.generateContent(in: geometry)
//            }
//        }
//        .frame(maxHeight: totalHeight)
//    }
//
//    private func generateContent(in g: GeometryProxy) -> some View {
//        var width = CGFloat.zero
//        var height = CGFloat.zero
//
//        return ZStack(alignment: .topLeading) {
//            Group(subviewsOf: self.content) { subviews in
//                ForEach(Array(zip(subviews.indices, subviews)), id: \.0) { i, view in
//                    view
//                        .padding([.horizontal, .vertical], 4)
//                        .alignmentGuide(.leading, computeValue: { d in
//                            if (abs(width - d.width) > g.size.width)
//                            {
//                                width = 0
//                                height -= d.height
//                            }
//                            let result = width
//                            if i == self.content.count - 1 {
//                                width = 0 //last item
//                            } else {
//                                width -= d.width
//                            }
//                            return result
//                        })
//                        .alignmentGuide(.top, computeValue: { d in
//                            let result = height
//                            if i == self.content.count - 1 {
//                                height = 0 // last item
//                            }
//                            return result
//                        })
//                }
//            }
//        }.background(viewHeightReader($totalHeight))
//    }
//
//    private func viewHeightReader(_ binding: Binding<CGFloat>) -> some View {
//        return GeometryReader { geometry -> Color in
//            let rect = geometry.frame(in: .local)
//            DispatchQueue.main.async {
//                binding.wrappedValue = rect.size.height
//            }
//            return .clear
//        }
//    }
//}
//
//#Preview {
//    WrappingHStack {
//        Text("Hello")
//        Text("This is a test")
//        
//        ForEach(["This", "is", "very", "cool"], id: \.self) { string in
//            Text(string)
//        }
//    }
//    .previewLayout(.fixed(width: 100, height: 100))
//}
