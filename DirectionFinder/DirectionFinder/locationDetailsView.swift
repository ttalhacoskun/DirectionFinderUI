//
//  locationDetailsView.swift
//  DirectionFinder
//
//  Created by Talha Coşkun on 11.08.2023.
//

import SwiftUI
import MapKit

struct locationDetailsView: View {
    @Binding var mapSelection: MKMapItem?
    @Binding var show: Bool
    @State private var lookAroundScene: MKLookAroundScene?
    @Binding var getDirections: Bool
    
    var body: some View {
        VStack{
            HStack{
                VStack(alignment: .leading) {
                    Text(mapSelection?.placemark.name ?? "")
                        .font(.title)
                        .fontWeight(.semibold)
                    
                    Text(mapSelection?.placemark.title ?? "")
                        .font(.footnote)
                        .foregroundStyle(.gray)
                        .lineLimit(2)
                        .padding(.trailing)
                }
                
                Spacer()
                
                Button{
                    show.toggle()
                    mapSelection = nil
                
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundStyle(.gray, Color(.systemGray))
                }
            }
            .padding(.horizontal)
            .padding(.top)
            
            if let scene = lookAroundScene {
                LookAroundPreview(initialScene: scene)
                    .frame(height: 200)
                    .cornerRadius(12)
                    .padding()
            } else {
                ContentUnavailableView("No preview available", systemImage: "eye.slahs")
            }
            
            HStack(spacing: 24){
                Button {
                    if let mapSelection{
                        mapSelection.openInMaps()
                    }
                } label: {
                    Text("Open İn Maps")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(width: 170, height: 48)
                        .background(.green)
                        .cornerRadius(12)
                }
                
                Button{
                    getDirections = true
                    show = false
                }label: {
                    Text("Get Directions")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(width: 170, height: 48)
                        .background(.blue)
                        .cornerRadius(12)
                }
            }
            .padding(.horizontal)
        }
        .onAppear {
            print("DEBUG: Did call on appear")
            fetchLookAroundPreview()
        }
        .onChange(of: mapSelection) { oldValue, newValue in
            print("DEBUG: Did call on appear")
            fetchLookAroundPreview()
        }
        .padding()
    }
}
extension locationDetailsView {
    func fetchLookAroundPreview() {
        if let mapSelection {
            Task {
                let request = MKLookAroundSceneRequest(mapItem: mapSelection)
                lookAroundScene = try? await request.scene
            }
        }
    }
}

#Preview {
    locationDetailsView(mapSelection: .constant(nil), show: .constant(false), getDirections: .constant(false))
}
