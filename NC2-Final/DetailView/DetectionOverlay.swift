//
//  DetectionOverlay.swift
//  NC2-Final
//
//  Created by 김하준 on 6/17/24.
//

import SwiftUI
import Vision

struct DetectionOverlay: View {
    let objects: [VNRecognizedObjectObservation]
    let selectedObjects: [RecognizedObject]
    let imageSize: CGSize
    var onTap: (VNRecognizedObjectObservation) -> Void
    
    var body: some View {
        GeometryReader { geometry in
            ForEach(Array(objects.enumerated()), id: \.element.uuid) { index, object in
                let rect = VNImageRectForNormalizedRect(object.boundingBox, Int(imageSize.width), Int(imageSize.height))
                let scaleX = geometry.size.width / imageSize.width
                let scaleY = geometry.size.height / imageSize.height
                let scaledRect = CGRect(x: rect.origin.x * scaleX, y: geometry.size.height - (rect.origin.y + rect.size.height) * scaleY, width: rect.size.width * scaleX, height: rect.size.height * scaleY)
                
                ZStack {
                    // 객체 인식을 위한 사각형 그리기
                    Rectangle()
                        .path(in: scaledRect)
                        .stroke(selectedObjects.first { $0.object.uuid == object.uuid }?.color ?? Color.red, lineWidth: 2)
                        .onTapGesture {
                            onTap(object)
                        }
                }
            }
        }
    }
}

struct RecognizedObject: Identifiable {
    let id = UUID()
    var object: VNRecognizedObjectObservation
    var label: String
    var notes: String = ""
    var color: Color
}
