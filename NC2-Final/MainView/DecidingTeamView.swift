//
//  DecidingTeamView.swift
//  NC2-Final
//
//  Created by 김하준 on 6/18/24.
//

import SwiftUI
import UIKit

struct DecidingTeamView: View {
    @State private var animationAmount = 0.0
    @Binding var photos: [PhotoData]
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        ZStack {
            Image("resultviewbg")
                .resizable()
                .scaledToFill()
            ZStack {
//                Image("Ellipse 7")
//                    .resizable()
//                    .scaledToFit()
//                    .frame(width: 226, height: 226)
//                    .offset(x: -120, y:-50)
//                
//                Image("Group 14")
//                    .resizable()
//                    .scaledToFit()
//                    .frame(width: 212, height: 244)
//                    .offset(x: 100, y: 200)
//                
                VStack {
                    Spacer()
                    if let lastPhoto = photos.last {
                        Text("\(lastPhoto.name)의\n팀을 결정했어요")
                            .font(.system(size: 26))
                            .fontWeight(.bold)
                            .foregroundStyle(Color.white)
                            .multilineTextAlignment(.center)
                            .padding(.vertical, 20)
                        Text("왜냐면 당신은 \(extractName(from: lastPhoto.label))를 닮았거든요:)")
                            .font(.system(size: 16))
                            .fontWeight(.regular)
                            .foregroundStyle(Color(.lightGray))
                    }
                    
                    Spacer().frame(height: 100)
                    
                    Button(action: {
                        withAnimation(.interpolatingSpring(stiffness: 5, damping: 2)) {
                            self.animationAmount += 360
                        }
                    }) {
                        ZStack {
                            BlurView(style: .light)
                                .blur(radius: 30, opaque: true)
                                .opacity(0.8)
                                .background(.ultraThinMaterial)
                                .opacity(0.3)
                                .frame(width: 237, height: 328)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .overlay(RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.white.opacity(0.2), lineWidth: 2))
                                .blur(radius: 10)
                            LinearGradient(gradient: Gradient(colors: [Color.black.opacity(0.1), Color.white.opacity(0.2)]),
                                           startPoint: .topTrailing, endPoint: .bottomLeading)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .frame(width: 237, height: 328)
                            
                            if let lastPhoto = photos.last {
                                VStack {
                                    Spacer().frame(height: 10)
                                    
                                    Text("\(lastPhoto.label.name)")
                                        .font(.system(size: 12))
                                        .fontWeight(.bold)
                                        .foregroundStyle(Color.white)
                                        .multilineTextAlignment(.center)
                                        .opacity(0.8)
                                    
                                    Spacer().frame(height: 10)
                                    
                                    if lastPhoto.label == .dirini {
                                        Image("Dirini")//디리니
                                            .resizable()
                                            .frame(width: 179, height: 220)
                                            .aspectRatio(contentMode: .fit)
                                            .clipShape(RoundedRectangle(cornerRadius: 12))
                                    } else {
                                        Image("Sasha")//사샤
                                            .resizable()
                                            .frame(width: 179, height: 220)
                                            .aspectRatio(contentMode: .fit)
                                            .clipShape(RoundedRectangle(cornerRadius: 12))
                                    }
                                    
                                    Spacer().frame(height: 20)
                                    
                                    Text("\(lastPhoto.name)")
                                        .font(.system(size: 23))
                                        .fontWeight(.bold)
                                        .foregroundStyle(Color.white)
                                    
                                    Spacer().frame(height: 20)
                                }
                            }
                        }
                        .rotation3DEffect(
                            .degrees(animationAmount),
                            axis: (x: 0.0, y: 1.0, z: 0.0)
                        )
                        .onAppear {
                            withAnimation(.interpolatingSpring(stiffness: 5, damping: 2)) {
                                self.animationAmount += 360
                            }
                        }
                    }
                    Spacer()
                    
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss() // This will dismiss the view and navigate back to ContentView
                    }) {
                        Text("홈으로 가기")
                            .font(.system(size: 16))
                            .fontWeight(.bold)
                            .foregroundStyle(Color("PrimaryBlue"))
                    }
                    .frame(width: 361, height: 56)
                    .background(Color("PrimaryBlack"))
                    .clipShape(RoundedRectangle(cornerRadius: 9))
                    
                    Spacer().frame(height: 43)
                }
            }
        }.ignoresSafeArea()
    }
    
    func extractName(from label: SelectedPerson) -> String {
        switch label {
        case .sasha:
            return "사샤"
        case .dirini:
            return "디리니"
        }
    }
}

// Define a new struct named BlurView, which conforms to UIViewRepresentable. This allows SwiftUI to use UIViews.
struct BlurView: UIViewRepresentable {
    let style: UIBlurEffect.Style
    
    init(style: UIBlurEffect.Style) {
        self.style = style
    }
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        let blurEffect = UIBlurEffect(style: style)
        let blurView = UIVisualEffectView(effect: blurEffect)
        return blurView
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
}
