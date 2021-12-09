//
//  Helper.swift
//  Find Vaccine Slot
//
//  Created by Dev01 on 16/06/21.
//

import Foundation
import SwiftUI

let showLog = false//true

func timeFormat(time: String) -> String{
    let dateAsString = time
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "HH:mm:ss"
    
    let date = dateFormatter.date(from: dateAsString)
    dateFormatter.dateFormat = "h:mm a"
    let Date12 = dateFormatter.string(from: date!)
    return Date12
}

func print(msg : String){
    if showLog{
        print(msg)
    }
}
//#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
//#endif
extension Color {
    init(hex: UInt, alpha: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 08) & 0xff) / 255,
            blue: Double((hex >> 00) & 0xff) / 255,
            opacity: alpha
        )
    }
}

//MARK:- Radio Button Field
struct RadioButtonField: View {
    let id: String
    let label: String
    let size: CGFloat
    let color: Color
    let bgColor: Color
    let textSize: CGFloat
    let isMarked:Bool
    let callback: (String)->()
    
    init(
        id: String,
        label:String,
        size: CGFloat = 20,
        color: Color = Color.black,
        bgColor: Color = Color.black,
        textSize: CGFloat = 18,
        isMarked: Bool = false,
        callback: @escaping (String)->()
        ) {
        self.id = id
        self.label = label
        self.size = size
        self.color = color
        self.bgColor = bgColor
        self.textSize = textSize
        self.isMarked = isMarked
        self.callback = callback
    }
    
    var body: some View {
        Button(action:{
            self.callback(self.id)
        }) {
            HStack(alignment: .center, spacing: 5) {
                Image(systemName: self.isMarked ? "largecircle.fill.circle" : "circle")
                    .clipShape(Circle())
                    .foregroundColor(self.bgColor)
                Text(label)
                    .font(Font.system(size: textSize))
                    .fontWeight(.medium)
               // Spacer()
            }.foregroundColor(self.color)
        }
        .foregroundColor(Color.white)
    }
}

//Function to keep text length in limits
func limitText(_ upper: Int, pincode: String) -> String {
    var pin = pincode
    if pin.count > upper {
        pin = String(pin.prefix(upper))
        return pincode
    }
    return ""
}

extension Text {
    func mediumWhiteText() -> Text {
        self
            .fontWeight(.medium)
            .foregroundColor(Color.white)
            .font(.system(size: 19))
    }
    
    func boldWhiteText() -> Text {
        self
            .fontWeight(.bold)
            .foregroundColor(Color.white)
            .font(.system(size: 24))
    }
}
