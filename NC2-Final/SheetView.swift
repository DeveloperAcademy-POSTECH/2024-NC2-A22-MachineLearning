//
//  SheetView.swift
//  NC2-Final
//
//  Created by 조민  on 6/17/24.
//

import SwiftUI

struct SheetView: View {
    @State private var name: String = ""  // 입력 가능한 텍스트 필드를 위한 상태 변수
    
    var body: some View {
        ZStack {
            Color(.systemGray6)
            VStack {
                Spacer().frame(height: 87)
                Image("11") // 여기에 받아올 이미지 생성
                    .resizable()
                    .frame(width: 361, height: 361)
                    .aspectRatio(contentMode: .fill)
                    .clipShape(RoundedRectangle(cornerRadius: 9))
                Spacer().frame(height: 20)
                
                Button {
                    // 다시 촬영하기 액션
                } label: {
                    Text("다시 촬영하기")
                        .font(.system(size: 16))
                        .fontWeight(.regular)
                        .foregroundStyle(Color("Primary"))
                }
                .frame(width: 361, height: 56)
                .background(Color.clear)
                .overlay(RoundedRectangle(cornerRadius: 9)
                    .stroke(Color("Primary"), lineWidth: 1))
                
                List {
                    Section {
                        HStack {
                            Text("이름")
                            Spacer()
                            TextField("이름을 입력해주세요", text: $name)
                                .textFieldStyle(DefaultTextFieldStyle())
                                .foregroundStyle(Color.gray)
                                .multilineTextAlignment(.trailing)
                        }
                        HStack {
                            Text("유사도")
                            Spacer()
                            Text("89%")
                                .textFieldStyle(DefaultTextFieldStyle())
                                .foregroundStyle(Color.gray)
                        }
                    }
                }
                .listStyle(.automatic)
                
                Button {
                    // 완료 액션
                } label: {
                    Text("완료")
                        .font(.system(size: 16))
                        .fontWeight(.regular)
                        .foregroundStyle(Color("Secondary"))
                }
                .frame(width: 361, height: 56)
                .background(Color("Primary"))
                .clipShape(RoundedRectangle(cornerRadius: 9))
                
                Spacer().frame(height: 43)
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    SheetView()
}

