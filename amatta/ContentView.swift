//
//  ContentView.swift
//  amatta
//
//  Created by 박준형 on 12/13/23.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @State private var showingAdd = false
    @FetchRequest(
        entity: Alarm.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Alarm.time, ascending: true)]
    ) var alarms: FetchedResults<Alarm>
    @State private var selectedAlarmID: NSManagedObjectID?
    @State private var isEditing = false
    @EnvironmentObject var alarmManager: AlarmManager
    
    @Environment(\.managedObjectContext) var managedObjectContext

    var body: some View {
        NavigationView {
            VStack {
                // 상단 바
                HStack {
                    Text("알림")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color(red: 82 / 255, green: 182 / 255, blue: 154 / 255))
                        .padding(.leading, UIScreen.main.bounds.width * 0.1)
                        .padding(.top, 20)
                    Spacer()
                    NavigationLink(destination: SettingView()) {
                        Image(systemName: "gear")
                            .foregroundColor(Color(red: 82 / 255, green: 182 / 255, blue: 154 / 255))
                    }
                    .padding(.top, 20)
                    .padding(.trailing, UIScreen.main.bounds.width * 0.1)
                }


                Spacer()

                // 알람 리스트
                ScrollView {
                    VStack(spacing: 10) {
                        if alarms.isEmpty {
                            Spacer() // 상단에 Spacer 추가
                            Text("아직 생성된 알림이 없습니다.")
                            .font(.system(size: 16))
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            Spacer() // 하단에 Spacer 추가
                            } else {
                            ForEach(alarms, id: \.self) { alarm in
                            AlarmRow(alarm: alarm, editAction: { alarmID in
                            self.selectedAlarmID = alarmID
                            self.isEditing = true
                            })
                            .frame(maxWidth: UIScreen.main.bounds.width * 0.8)
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
                    .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)) // 여기에서 패딩 값을 조정합니다.
                    .frame(height: 44) // 버튼의 높이를 지정합니다.
                    .frame(maxWidth: UIScreen.main.bounds.width * 0.8)
                    .background(Color(red: 82 / 255, green: 182 / 255, blue: 154 / 255))
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .contentShape(Rectangle())

                NavigationLink(destination: EditAlarmView(alarmID: selectedAlarmID), isActive: $isEditing) {
                    EmptyView()
                }
                .buttonStyle(PlainButtonStyle())

                NavigationLink(destination: PushAlarmScreenView(alarmData: $alarmManager.alarmData, tappedAlarm: $alarmManager.tappedAlarm), isActive: $alarmManager.tappedAlarm) {
                    EmptyView()
                }
                .buttonStyle(PlainButtonStyle())

            }
            .frame(maxWidth: .infinity, alignment: .center)
            .onAppear {
                requestNotificationPermission()
                loadScheduledNotifications()
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    private func loadScheduledNotifications() {
            UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
                print("현재 스케줄된 알림 수: \(requests.count)")
                for request in requests {
                    print("알림 ID: \(request.identifier), 알림 내용: \(request.content.title)")
                }
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
    var editAction: (NSManagedObjectID) -> Void
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.managedObjectContext) var managedObjectContext

    var body: some View {
        Button(action: {
            self.editAction(self.alarm.objectID)
        }) {
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
                ForEach(alarm.itemsArray, id: \.self) { item in
                        HStack {
                            Text(item.name ?? "물건")
                                .font(.subheadline)
                                .foregroundColor(.primary)
                            
                            if item.isContainer && !item.childrenArray.isEmpty {
                                Text(item.childrenArray.map { $0.name ?? "항목" }.joined(separator: ", "))
                                    .font(.footnote)
                                    .foregroundColor(.gray)
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
                .padding([.leading, .trailing, .bottom])
            }
            .background(colorScheme == .dark ? Color(white: 0.2) : Color(red: 249 / 255, green: 249 / 255, blue: 249 / 255))
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray, lineWidth: 1)
            )
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
