//
//  VerticalSourceView.swift
//  psychoheads
//
//  Created by Ryan Pavlovicz on 6/26/25.
//


//
//  VerticalSourceView.swift
//  psychoheads
//
//  Created by Ryan Pavlovicz on 7/9/23.
//

import SwiftUI

struct VerticalSourceView: View {
    
    var source: Source?
    
    var body: some View {
        VStack {
            Image(uiImage: source?.imageThumb ?? UIImage(named: "broken_image_link")!)
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
            Text(source?.title ?? "")
                .font(.headline)
            if let issue = source?.issue, !issue.isEmpty {
                Text(issue)
                    .font(.subheadline)
            }
            Text(source?.dateString ?? "")
                .font(.subheadline)

        }
    }
}

//struct VerticalSourceView_Previews: PreviewProvider {
//    static var previews: some View {
//        VerticalSourceView(source: Source(title: "Playboy", year: "1994", month: "February"))
//    }
//}
