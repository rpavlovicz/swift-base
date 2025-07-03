//
//  SourceFormView.swift
//  psychoheads
//
//  Created by Ryan Pavlovicz on 6/26/25.
//


//
//  SourceFormView.swift
//  psychoheads
//
//  Created by Ryan Pavlovicz on 5/4/23.
//

import SwiftUI

struct SourceFormView: View {
    
    @ObservedObject var source: Source

    var body: some View {
        HStack {
        
            Image(systemName: "book.circle.fill")
            
            VStack(alignment: .leading) {
                Text(source.title)
                    .font(.headline)
                Text(source.dateString)
                    .font(.subheadline)
            }
            
        }
        
    }

}

//struct SourceFormView_Previews: PreviewProvider {
//    static var previews: some View {
//        SourceFormView(source: Source(title: "People", year: "2007", month: "March", day: "15"))
//    }
//}
