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
    @FetchRequest(
           entity: Alarm.entity(),
           sortDescriptors: [NSSortDescriptor(keyPath: \Alarm.time, ascending: true)]
       ) var alarms: FetchedResults<Alarm>
    
    
    var body: some View {
        NavigationView {
        VStack {
            // 상단 바
                HStack {
                    Text("알림")
                        .font(.largeTitle)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .foregroundColor(Color(red: 82 / 255, green: 182 / 255, blue: 154 / 255))
                        .padding([.leading, .trailing], 40)
                        .padding(.top, 20)

                    Spacer()

                    Button(action: {
                        // 톱니바퀴 버튼 기능
                    }) {
                        Image(systemName: "gear")
                            .foregroundColor(Color(red: 82 / 255, green: 182 / 255, blue: 154 / 255))
                            .padding([.leading, .trailing], 40)
                            .padding(.top, 20)
                    }
                }

                Spacer()

            if alarms.isEmpty {
                                Text("아직 생성된 알림이 없습니다.")
                                    .font(.system(size: 16))
                                    .foregroundColor(.gray)
                            } else {
                                List {
                                    ForEach(alarms, id: \.self) { alarm in
                                        AlarmRow(alarm: alarm)
                                    }
                                }
                            }

                Spacer()

            NavigationLink(destination: AddAlarmView()) {
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
                                AddAlarmView()
                            }
            .padding(.horizontal)
            }
        .onAppear(perform: requestNotificationPermission)
            }

        
    }
}


struct AlarmRow: View {
    let alarm: Alarm
    @State private var isExpanded: Bool = false

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(alarm.name ?? "알림")
                    .font(.title2) // 텍스트 크기 변경
                    .frame(alignment: .leading)

                Spacer()

                Text(alarm.formattedTime)
                    .font(.subheadline)
                    .frame(alignment: .trailing)
            }
            .onTapGesture {
                withAnimation {
                    isExpanded.toggle()
                }
            }

            if isExpanded {
                // 자세한 정보를 여기에 추가
                Text("월, 화, 수, 목, 금")
                Text("가방 - 맥북, 노트, 충전기")
                Text("지갑")
                Text("헤드폰")
                Text("스마트폰")
                // 편집 및 삭제 버튼
                HStack {
                    Button("편집") { /* 편집 로직 */ }
                    Button("삭제") { /* 삭제 로직 */ }
                }
            }
        }
    }
}


extension Alarm {
    var formattedTime: String {
        // 날짜 형식에 맞게 알림 시간을 문자열로 변환
        guard let time = self.time else { return "시간 없음" }
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter.string(from: time)
    }
}


private func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            // 권한 요청 결과 처리
            if granted {
                print("알림 권한 허용됨")
            } else {
                print("알림 권한 거부됨")
            }
        }
    }


// 프리뷰
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
