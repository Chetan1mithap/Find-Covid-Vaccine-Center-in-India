//
//  SlotData.swift
//  Find Vaccine Slot
//
//  Created by Dev01 on 16/06/21.
//

import Foundation
import SwiftUI

struct SlotData: View {
    var data: Session
    var body: some View {
        ZStack{
            VStack(alignment: .leading, spacing: 10){
                Text("\(data.name ?? "")").boldWhiteText().lineLimit(nil)
                Text("\(data.address ?? "")").mediumWhiteText().lineLimit(nil)
                
                Text("\(data.blockName ?? ""), \(data.districtName ?? ""), \(data.stateName ?? "")").mediumWhiteText().lineLimit(nil)
                
                Text("Date: \(data.date ?? "")").mediumWhiteText()
                Text("Timing: \(timeFormat(time: data.from ?? "")) - \(timeFormat(time: data.to ?? ""))").mediumWhiteText()
                
                HStack{
                    Text("Fee Type: \(data.feeType ?? "")").mediumWhiteText()
                    Spacer()
                    Text("Fee: ₹\(data.fee ?? "0")").mediumWhiteText()
                }.frame(maxWidth: .infinity)
                
                Text("Age: \(data.minAgeLimit ?? 0)+").mediumWhiteText()
                Text("Vaccine: \(data.vaccine ?? "")").mediumWhiteText()
                
                Text("Available Capacity: \(data.availableCapacity ?? 0)").mediumWhiteText()
                HStack{
                    HStack{
                        Text("Dose 1:").mediumWhiteText()
                        Text("\(data.availableCapacityDose1 ?? 0)").font(.headline)
                            .foregroundColor(changeTextColor(numOfDose: data.availableCapacityDose1 ?? 0))
                    }
                    Spacer()
                    HStack{
                        Text("Dose 2:").mediumWhiteText()
                        Text("\(data.availableCapacityDose2 ?? 0)").font(.headline)
                            .foregroundColor(changeTextColor(numOfDose: data.availableCapacityDose2 ?? 0))
                    }
                }.frame(maxWidth: .infinity)
            }.cornerRadius(2)
        }.padding()
    }
    
    func changeTextColor(numOfDose: Int) -> Color
    {
        if(numOfDose == 0)
        {
            return Color.red;
        }
        else
        {
            return Color.green;
        }
    }
}
