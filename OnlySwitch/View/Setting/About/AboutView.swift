//
//  AboutView.swift
//  OnlySwitch
//
//  Created by Jacklandrin on 2021/12/11.
//

import SwiftUI

struct AboutView: View {
    @StateObject var aboutVM = AboutVM()
    var body: some View {
        HStack {
            VStack {
                Image("only_switch")
                    .resizable()
                    .scaledToFit().frame(width: 100, height: 100)
                Spacer().frame(height:50)
                HStack(alignment:.bottom) {
                    Text("Only Switch")
                        .fontWeight(.bold)
                        .font(.system(size: 30))
                    Text("v\(SystemInfo.majorVersion as! String)")
                        .foregroundColor(Color(NSColor.lightGray))
                        .font(.system(size: 22))
                }
                HStack {
                    Text("Copyright @ 2021-2022 ")
                        .font(.system(size: 15))
                    Link(destination: URL(string: "https://www.jacklandrin.com")!, label: {
                        Text("Jacklandrin")
                            .font(.system(size: 15))
                    })
                }
                HStack {
                    Link(destination: URL(string: "https://github.com/jacklandrin/OnlySwitch")!, label: {
                        Text("GitHub Repo")
                    })
                    if aboutVM.downloadCount > 0 {
                        Text("%@ downloads".localizeWithFormat(arguments: formatDownloadCount))
                    }
                }
                HStack {
                    Text("Join:".localized())
                    Link(destination: URL(string: "https://t.me/OnlySwitchforMac")!, label: {
                        Text("Telegram Group")
                    })
                }
            }.offset(y:20)
            VStack {
                Text("Version History:".localized())
                    .fontWeight(.bold)
                    .padding(.top, 10)
                ScrollView {
                    Text(aboutVM.updateHistoryInfo)
                        .padding(.trailing, 10)
                }.frame(width:Layout.settingWindowWidth / 2 - 140)
            }.padding(.leading, 70)
            
        }
        .onAppear {
            aboutVM.requestReleases()
        }
    }
    
    var formatDownloadCount:String {
        let number = NSNumber(value: aboutVM.downloadCount)
        let numberFormatter = NumberFormatter()
        numberFormatter.usesGroupingSeparator = true
        numberFormatter.groupingSeparator = ","
        numberFormatter.groupingSize = 3
        let format = numberFormatter.string(from: number)
        return format!
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
