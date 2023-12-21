//
//  ContentView.swift
//  amatta
//
//  Created by 박준형 on 12/13/23.
//

import SwiftUI
import SwiftData
import CoreData

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
                        .fontWeight(.bold)
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

                ScrollView {
                    VStack(spacing: 10) {
                        if alarms.isEmpty {
                            Text("아직 생성된 알림이 없습니다.")
                                .font(.system(size: 16))
                                .foregroundColor(.gray)
                        } else {
                            ForEach(alarms, id: \.self) { alarm in
                                AlarmRow(alarm: alarm)
                                    .frame(maxWidth: 360)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top, 10)
                }
                .padding(.horizontal)

                Spacer()

                NavigationLink(destination: AddAlarmView()) {
                    HStack {
                        Image(systemName: "plus")
                        Text("새로운 알림 추가")
                    }
                    .padding()
                    .frame(maxWidth: 360)
                    .background(Color(red: 82 / 255, green: 182 / 255, blue: 154 / 255))
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding()
                }
                .sheet(isPresented: $showingAdd) {
                    AddAlarmView()
                }
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .onAppear(perform: requestNotificationPermission)
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
}

struct AlarmRow: View {
    let alarm: Alarm
    @State private var isExpanded: Bool = false
    @State private var showingDeleteAlert = false
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(alarm.name ?? "알림")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                Spacer()
                Text(alarm.formattedTime)
                    .font(.subheadline)
                    .foregroundColor(.primary)
            }
            .padding()

            // 알림 상세 정보
            if isExpanded {
                ForEach(alarm.itemsArray, id: \.self) { item in
                    HStack {
                        Text(item.name ?? "")
                            .font(.subheadline)
                            .foregroundColor(.primary)
                        
                        if item.isContainer {
                            ForEach(item.childrenArray, id: \.self) { child in
                                Text(child.name ?? "")
                                    .font(.footnote)
                                    .foregroundColor(.gray)
                                    .padding(.leading, 1)
                            }
                        }
                    }
                }
                .padding([.leading, .trailing])

                HStack {
                    Spacer()
                    Text("\(alarm.weekdays)")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding([.leading, .trailing])

                VStack(spacing: 0) {
                    Divider() // 상단 구분선

                    HStack {
                        Button(action: {
                            // 삭제 로직
                        }) {
                            HStack {
                                Spacer()
                                Text("삭제")
                                    .foregroundColor(.red)
                                Spacer()
                            }
                        }
                        .frame(width: 155, height: 40, alignment: .center)
                        .background(Color.clear)

                        Divider()
                        
                        Button(action: {
                            // 편집 로직
                        }) {
                            HStack {
                                Spacer()
                                Text("편집")
                                Spacer()
                            }
                        }
                        .frame(width: 155, height: 40, alignment: .center)
                        .background(Color.clear)
                        .alert(isPresented: $showingDeleteAlert) {
                                                    Alert(
                                                        title: Text("알림 삭제"),
                                                        message: Text("정말로 알림을 삭제하시겠어요?"),
                                                        primaryButton: .destructive(Text("삭제")) {
                                                            // CoreData 및 알림 스케줄러에서 알림 삭제 로직
                                                        },
                                                        secondaryButton: .cancel()
                                                    )
                                                }
                    }
                }


            }
        }
        .background(colorScheme == .dark ? Color(white: 0.2) : Color(red: 249 / 255, green: 249 / 255, blue: 249 / 255))
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.gray, lineWidth: 1)
        )
        .onTapGesture {
            withAnimation {
                isExpanded.toggle()
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
    
    var weekdays: String {
        var days = [String]()
        if monday { days.append("월") }
        if tuesday { days.append("화") }
        if wednesday { days.append("수") }
        if thursday { days.append("목") }
        if friday { days.append("금") }
        if saturday { days.append("토") }
        if sunday { days.append("일") }
        return days.joined(separator: ", ")
    }

    var itemsArray: [Items] {
        let set = items as? Set<Items> ?? []
        return set.sorted {
            $0.name ?? "" < $1.name ?? ""
        }
    }
}

extension Items {
    var childrenArray: [Items] {
        let set = children as? Set<Items> ?? []
        return set.sorted {
            $0.name ?? "" < $1.name ?? ""
        }
    }
}

// 프리뷰
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
