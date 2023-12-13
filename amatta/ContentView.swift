//
//  ContentView.swift
//  amatta
//
//  Created by 박준형 on 12/13/23.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var showingAdd = false
    var body: some View {
        VStack {
            // 상단 바
            HStack {
                Text("알림")
                    .font(.largeTitle)
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .foregroundColor(Color(red: 82 / 255, green: 182 / 255, blue: 154 / 255))

                    .padding()


                Spacer()

                Button(action: {
                    // 톱니바퀴 버튼 기능
                }) {
                    Image(systemName: "gear")
                        .foregroundColor(Color(red: 82 / 255, green: 182 / 255, blue: 154 / 255))
                        .padding()
                }
            }

            Spacer()

            // 중앙 텍스트
            Text("아직 생성된 알림이 없습니다.")
                .font(.system(size:16))
                .foregroundColor(.gray)

            Spacer()

            // 하단 버튼
            Button(action: {
                self.showingAdd = true
            }) {
                HStack {
                    Image(systemName: "plus")
                    Text("새로운 알림 추가")
                }
                .padding()
                .frame(maxWidth: .infinity)
            }
            .background(Color(red: 82 / 255, green: 182 / 255, blue: 154 / 255))
            .foregroundColor(.white)
            .cornerRadius(10)
            .padding()
            .sheet(isPresented: $showingAdd) {
                            AddAlertView()
                        }
        }
        .padding(.horizontal)
    }
}

// 새로운 알림 추가 뷰
struct AddAlertView: View {
    var body: some View {
        VStack {
            Text("알림 추가")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
            Spacer()
        }
    }
}


// 프리뷰
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
