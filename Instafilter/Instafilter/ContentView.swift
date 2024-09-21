//
//  ContentView.swift
//  Instafilter
//
//  Created by Kesavan Yogeswaran on 9/11/24.
//

import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins
import PhotosUI
import StoreKit

struct ContentView: View {
    @State private var selectedItem: PhotosPickerItem?
    @State private var processedImage: Image?
    @AppStorage("filterCount") var filterCount = 0
    @Environment(\.requestReview) var requestReview
    @State private var showingFilters = false
    @State private var filterIntensity = 0.5
    @State private var filterRadius = 0.5
    @State private var currentFilter: CIFilter = CIFilter.sepiaTone()
    let context = CIContext()
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                PhotosPicker(selection: $selectedItem, matching: .images) {
                    if let processedImage {
                        processedImage
                            .resizable()
                            .scaledToFill()
                    } else {
                        ContentUnavailableView("No picture", image: "photo.badge.plus", description: Text("Tap to import a photo"))
                    }
                }
                .buttonStyle(.plain)
                
                Spacer()
                VStack {
                    if currentFilter.inputKeys.first(where: { element in
                        [kCIInputIntensityKey, kCIInputScaleKey].contains(element)
                    }) != nil {
                        HStack {
                            Text("Intensity")
                                .foregroundStyle(selectedItem != nil ? .primary : .secondary)
                            Slider(value: $filterIntensity)
                                .onChange(of: filterIntensity, applyProcessing)
                            
                        }
                    }
                    if currentFilter.inputKeys.contains(kCIInputRadiusKey) {
                        HStack {
                            Text("Radius")
                                .foregroundStyle(selectedItem != nil ? .primary : .secondary)
                            Slider(value: $filterRadius)
                                .onChange(of: filterRadius, applyProcessing)
                            
                        }
                    }
                }
                .padding(.vertical)
                .disabled(selectedItem == nil)
                
                HStack {
                    Button("Change Filter", action: changeFilter)
                        .disabled(selectedItem == nil)
                    Spacer()
                    if let processedImage {
                        ShareLink(item: processedImage, preview: SharePreview("Instafilter image", image: processedImage))
                    }
                }
            }
            .padding([.horizontal, .bottom])
            .navigationTitle("Instafilter")
            .onChange(of: selectedItem, loadImage)
            .confirmationDialog("Select a filter", isPresented: $showingFilters) {
                Button("Bloom") { setFilter(CIFilter.bloom()) }
                Button("Bokeh") { setFilter(CIFilter.bokehBlur()) }
                Button("Crystallize") { setFilter(CIFilter.crystallize()) }
                Button("Dither") { setFilter(CIFilter.dither()) }
                Button("Edges") { setFilter(CIFilter.edges()) }
                Button("Gaussian Blur") { setFilter(CIFilter.gaussianBlur()) }
                Button("Pixellate") { setFilter(CIFilter.pixellate()) }
                Button("Sepia Tone") { setFilter(CIFilter.sepiaTone()) }
                Button("Unsharp Mask") { setFilter(CIFilter.unsharpMask()) }
                Button("Vignette") { setFilter(CIFilter.vignette()) }
                Button("Cancel", role: .cancel) { }
            }
        }
    }
    
    func loadImage() {
        Task {
            guard let imageData = try await selectedItem?.loadTransferable(type: Data.self) else { return }
            guard let inputImage = UIImage(data: imageData) else { return }
            
            let beginImage = CIImage(image: inputImage)
            currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
            applyProcessing()
        }
    }
    
    func applyProcessing() {
        let inputKeys = currentFilter.inputKeys

        if inputKeys.contains(kCIInputIntensityKey) { currentFilter.setValue(filterIntensity, forKey: kCIInputIntensityKey) }
        if inputKeys.contains(kCIInputRadiusKey) { currentFilter.setValue(filterRadius * 200, forKey: kCIInputRadiusKey) }
        if inputKeys.contains(kCIInputScaleKey) { currentFilter.setValue(filterIntensity * 10, forKey: kCIInputScaleKey) }
        
        guard let outputImage = currentFilter.outputImage else { return }
        guard let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else { return }
        
        let uiImage = UIImage(cgImage: cgImage)
        processedImage = Image(uiImage: uiImage)
    }
    
    func changeFilter() {
        showingFilters = true
    }
    
    @MainActor func setFilter(_ filter: CIFilter) {
        currentFilter = filter
        loadImage()
        
        filterCount += 1
        if filterCount >= 20 {
            requestReview()
        }
    }
}

#Preview {
    ContentView()
}
