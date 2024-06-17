//
//  ContentView.swift
//  NC2-Final
//
//  Created by 조민  on 6/17/24.
//

import SwiftUI

struct SampleView: View {
    
    @State var selectedTab = "샤샤"
    var persons = ["샤샤", "디리니"]
    
    var body: some View {
        ZStack{
            LinearGradient(gradient: Gradient(colors: [Color("GradientColor1"), Color("GradientColor2"), Color("GradientColor3"), Color("GradientColor4")]),
                           startPoint: .top, endPoint: .bottom)
            VStack {
                Spacer().frame(height: 50)
                HStack {
                    Text("샤샤와 디리니")
                        .font(.system(size: 28))
                        .fontWeight(.bold)
                        .foregroundStyle(Color.white)
                    Spacer()
                }
                HStack {
                    Button {//여기에 액션 넣기
                    } label: {
                        VStack {
                            Image(systemName: "camera")
                                .resizable()
                                .frame(width: 24, height: 19)
                                .foregroundStyle(Color("Primary"))
                                .foregroundStyle(.primary)
                            Text("카메라로 촬영하기")
                                .font(.system(size: 14))
                                .fontWeight(.regular)
                                .foregroundStyle(Color("Primary"))
                        }
                        .frame(width: 177, height: 69)
                        .background(Color.clear)
                        .overlay(RoundedRectangle(cornerRadius: 9)
                            .stroke(Color(.primary), lineWidth: 1))
                        
                    }
                    
                    Button {
                        //여기에 액션
                    } label: {
                        VStack {
                            Image(systemName: "photo")
                                .resizable()
                                .foregroundStyle(Color("Secondary"))
                                .frame(width: 24, height: 19)
                            Text("사진에서 불러오기")
                                .font(.system(size: 16))
                                .fontWeight(.regular)
                                .foregroundStyle(Color("Secondary"))
                        }
                        .frame(width: 177, height: 69)
                        .background(Color("Primary"))
                        .clipShape(RoundedRectangle(cornerRadius: 9))
                    }
                }
                Picker("", selection: $selectedTab) {
                    ForEach(persons, id: \.self) {
                        Text($0)
                    }
                }.pickerStyle(.segmented)
                
                List{
                    Section(header: Text("사람별 유사도")) {
                        HStack{
                            Image("11")
                                .resizable()
                                .frame(width: 50, height: 50)
                                .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                            Text("러너이름")
                            Spacer()
                            Text("퍼센트")
                                .multilineTextAlignment(.trailing)
                        }
                    }
                }.listStyle(.plain)
            }.padding(16)
        }.ignoresSafeArea()
    }
}



#Preview {
    SampleView()
}
