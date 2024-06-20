//
//  ContentView.swift
//  NC2-Final
//
//  Created by 김하준 on 6/18/24.
//

import SwiftUI

enum SelectedPerson: CaseIterable {
    case sasha
    case dirini
    
    var name: String {
        switch self {
        case .sasha: "Team 사샤"
        case .dirini: "Team 디리니"
        }
    }
}

struct ContentView: View {
    @State private var selectedImage: UIImage?
    @State private var isImagePickerPresented = false
    @State private var isCameraPresented = false
    @State private var navigateDecidingTeamView = false
    @State private var selectedPerson: SelectedPerson = .dirini
    @State private var name = ""
    @State private var photos: [PhotoData] = []

    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGray6)
                VStack {
                    Spacer().frame(height: 50)
                    HStack {
                        Text("샤샤와 디리니")
                            .font(.system(size: 28))
                            .fontWeight(.bold)
                            .foregroundStyle(Color.black)
                        Spacer()
                    }
                    HStack {
                        Button {
                            isCameraPresented = true
                        } label: {
                            VStack {
                                Image(systemName: "camera")
                                    .resizable()
                                    .frame(width: 24, height: 19)
                                    .foregroundStyle(Color.blue)
                                Text("카메라로 촬영하기")
                                    .font(.system(size: 14))
                                    .fontWeight(.regular)
                                    .foregroundStyle(Color.blue)
                            }
                            .frame(width: 177, height: 69)
                            .background(Color.clear)
                            .overlay(RoundedRectangle(cornerRadius: 9)
                                .stroke(Color.blue, lineWidth: 1))
                        }
                        NavigationLink(destination: CameraResultView(image: $selectedImage, photos: $photos, navigateDecidingTeamView: $navigateDecidingTeamView, isPresented: $isCameraPresented), isActive: $isCameraPresented) {
                            EmptyView()
                        }
                        Button {
                            isImagePickerPresented = true
                        } label: {
                            VStack {
                                Image(systemName: "photo")
                                    .resizable()
                                    .foregroundStyle(Color.gray)
                                    .frame(width: 24, height: 19)
                                Text("사진에서 불러오기")
                                    .font(.system(size: 14))
                                    .fontWeight(.regular)
                                    .foregroundStyle(Color.gray)
                            }
                            .frame(width: 177, height: 69)
                            .background(Color.blue)
                            .clipShape(RoundedRectangle(cornerRadius: 9))
                        }
                        NavigationLink(destination: GalleryResultView(image: $selectedImage, photos: $photos, navigateDecidingTeamView: $navigateDecidingTeamView, isPresented: $isImagePickerPresented), isActive: $isImagePickerPresented) {
                            EmptyView()
                        }
                    }
                    Spacer()

                    List {
                        Section {
                            Picker("", selection: $selectedPerson) {
                                ForEach(SelectedPerson.allCases, id: \.self) {
                                    Text($0.name)
                                }
                            }
                            .pickerStyle(.segmented)
                            .listRowSeparator(.hidden)
                        }
                        Section(header: Text("당신의 팀")) {
                            ForEach(photos.filter { $0.label == selectedPerson }, id: \.id) { photo in
                                HStack {
                                    if photo.label == .dirini {
                                        Image("photo1")//드리니
                                            .resizable()
                                            .frame(width: 50, height: 50)
                                            .clipShape(RoundedRectangle(cornerRadius: 9))
                                    } else {
                                        Image("minxcode")//사샤
                                            .resizable()
                                            .frame(width: 50, height: 50)
                                            .clipShape(RoundedRectangle(cornerRadius: 9))
                                    }
                                    Text(photo.name)
                                    Spacer()
                                }
                                .swipeActions {
                                    Button(role: .destructive) {
                                        deletePhoto(photo)
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                }
                            }
                        }
                    }
                    .listStyle(.inset)
                    .clipShape(RoundedRectangle(cornerRadius: 9))
                }
                .padding(16)
            }
            .ignoresSafeArea()
            .fullScreenCover(isPresented: $isCameraPresented) {
                CameraResultView(image: $selectedImage, photos: $photos, navigateDecidingTeamView: $navigateDecidingTeamView, isPresented: $isCameraPresented)
            }
            .sheet(isPresented: $isImagePickerPresented) {
                GalleryResultView(image: $selectedImage, photos: $photos, navigateDecidingTeamView: $navigateDecidingTeamView, isPresented: $isImagePickerPresented)
            }
            .navigationDestination(isPresented: $navigateDecidingTeamView) {
                DecidingTeamView(photos: $photos)
            }
        }
        .onAppear {
            print(photos)
        }
    }

    private func deletePhoto(_ photo: PhotoData) {
        photos.removeAll { $0.id == photo.id }
    }
}
