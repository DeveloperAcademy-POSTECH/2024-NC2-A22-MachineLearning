//
//  GalleryResultView.swift
//  NC2-Final
//
//  Created by 김하준 on 6/18/24.
//

import SwiftUI
import Vision

struct GalleryResultView: View {
    @Binding var image: UIImage?
    @Binding var photos: [PhotoData]
    @Binding var navigateDecidingTeamView: Bool
    @Binding var isPresented: Bool
    @State private var name: String = ""
    @State private var recognizedObjects: [VNRecognizedObjectObservation] = []
    @State private var classifications: [VNClassificationObservation] = []
    @State private var selectedObjects: [RecognizedObject] = []
    @State private var selectedObjectDetailsID: UUID?
    @Environment(\.presentationMode) var presentationMode
    @State private var isNavigationActive: Bool = false

    @State var selectedLabel: String = ""
    private let objectDetector = ObjectDetector()
    
    var body: some View {
        ZStack {
            Color("PrimaryBlack").ignoresSafeArea()
            VStack {
                Spacer().frame(height: 50)
                
                Text("본인의 얼굴을 선택해주세요")
                    .font(.system(size: 24))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                if let selectedImage = image {
                    Image(uiImage: selectedImage)
                        .resizable()
                        .scaledToFit()
                        .aspectRatio(contentMode: .fit)
                        .overlay(
                            DetectionOverlay(
                                objects: recognizedObjects,
                                selectedObjects: selectedObjects,
                                imageSize: selectedImage.size,
                                onTap: handleObjectTap
                            )
                        )
                        .frame(height: 300)
                } else {
                    Text("사진을 선택해주세요")
                        .padding()
                }
                
                Spacer().frame(height: 20)
                
                List {
                    Section {
                        HStack {
                            Text("이름")
                            Spacer()
                            TextField("이름을 입력해주세요", text: $name)
                                .multilineTextAlignment(.trailing)
                        }
                    }
                    Section {
                        if let selectedObjectDetailsID = selectedObjectDetailsID,
                           let selectedObjectDetails = selectedObjects.first(where: { $0.id == selectedObjectDetailsID }) {
                            HStack {
                                Text("당신의 팀")
                                Spacer()
                                Text(selectedObjectDetails.label == "김하준" ? "Team 샤샤" : selectedObjectDetails.label == "조민" ? "Team 디리니" : "얼굴을 선택해주세요")
                            }
                        } else {
                            HStack {
                                Text("당신의 팀")
                                Spacer()
                                Text("빨간 상자가 안나오면\n다른 사진을 골라주세요")
                                    .foregroundColor(Color(.systemGray))
                            }
                        }
                    }
                }
                .listStyle(InsetGroupedListStyle())
                .frame(height: 200)
                Button(action: {
                    isPresented = true
                }) {
                    Text("다시 선택하기")
                        .font(.system(size: 16))
                        .fontWeight(.regular)
                        .foregroundColor(Color("PrimaryBlue"))
                        .frame(width: 361, height: 56)
                        .overlay(RoundedRectangle(cornerRadius: 9)
                            .stroke(Color("PrimaryBlue"), lineWidth: 1))
                }
                Button(action: {
                    savePhoto(name: name, label: selectedLabel)
                    self.isPresented = false
                    self.navigateDecidingTeamView = true
                }) {
                    Text("결정하기")
                        .font(.system(size: 16))
                        .fontWeight(.bold)
                        .foregroundColor(Color("PrimaryBlack"))
                        .frame(width: 361, height: 56)
                        .background(Color("PrimaryBlue"))
                        .cornerRadius(9)
                }
                Spacer().frame(height: 43)
            }
            .sheet(isPresented: $isPresented) {
                ImagePicker(isCamera: false, image: $image, onImagePicked: { image in
                    self.image = image
                    self.detectObjects(in: image)
                })
            }
        }
        .onAppear {
            if let image = image {
                self.detectObjects(in: image)
            }
        }
    }
    
    private func handleObjectTap(_ object: VNRecognizedObjectObservation) {
        if recognizedObjects.contains(where: { $0.uuid == object.uuid }) {
            let index = recognizedObjects.firstIndex(where: { $0.uuid == object.uuid })!
            let label = classifications.indices.contains(index) ? classifications[index].identifier : "Unknown"
            let recognizedObject = RecognizedObject(object: object, label: label, color: .red)
            if !selectedObjects.contains(where: { $0.id == recognizedObject.id }) {
                selectedObjects.append(recognizedObject)
                selectedObjectDetailsID = recognizedObject.id
                selectedLabel = selectedObjects.first(where: { $0.id == selectedObjectDetailsID })?.label ?? "김하준"
            }
        }
    }
    
    private func detectObjects(in image: UIImage) {
        objectDetector.detectObjects(in: image) { results in
            DispatchQueue.main.async {
                self.recognizedObjects = results ?? []
                self.classifications = []
                self.recognizedObjects.forEach { object in
                    let rect = VNImageRectForNormalizedRect(object.boundingBox, Int(image.size.width), Int(image.size.height))
                    if let croppedImage = self.objectDetector.cropImage(image, toRect: rect) {
                        self.objectDetector.classifyObject(in: croppedImage) { classification in
                            if let classification = classification {
                                DispatchQueue.main.async {
                                    self.classifications.append(classification)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func savePhoto(name: String, label: String) {
        let teamLabel: SelectedPerson = (label == "김하준") ? .sasha : .dirini
        let photo = PhotoData(name: name, label: teamLabel)
        photos.append(photo)
        print(photos)
    }
}
