

import SwiftUI
import SDWebImageSwiftUI
struct CircleImage: View {
    var url: String
    
    var body: some View {
        WebImage(url:  DetailViewModel.createCirclePhotoUrl(url: self.url))
            .scaledToFit()
            .frame(width: 180, height: 180, alignment: .center)
            .clipShape(Circle())
            .overlay {
                Circle().stroke(.white, lineWidth: 4)
            }
            .shadow(radius: 7)
    }
}
