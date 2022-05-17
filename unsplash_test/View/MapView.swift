import SwiftUI
import MapKit

struct AnnotationItem: Identifiable {
    var coordinate: CLLocationCoordinate2D
    let id = UUID()
}

struct MapView: View {
    var coordinate: CLLocationCoordinate2D
    @State private var region = MKCoordinateRegion()
    @State private var annotations = [AnnotationItem(coordinate: CLLocationCoordinate2D(latitude: 0, longitude: 0))]
    var body: some View {
        Map(coordinateRegion: $region, annotationItems: annotations) { item in
            MapPin(coordinate: item.coordinate, tint: .blue)
        }
        .onAppear {
            setRegion(coordinate)
            
        }
    }
    
    private func setRegion(_ coordinate: CLLocationCoordinate2D) {
        region = MKCoordinateRegion(
            center: coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        )
        annotations = [AnnotationItem(coordinate: coordinate)]
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(coordinate: CLLocationCoordinate2D(latitude: 34.011_286, longitude: -116.166_868))
    }
}
