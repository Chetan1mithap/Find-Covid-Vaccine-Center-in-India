//
//  ContentView.swift
//  Find Vaccine Slot
//
//  Created by Dev01 on 16/06/21.
//

import SwiftUI
import Combine

struct ContentView: View {
    @State private var pincode: String = ""
    @State var selectedDate = Date()
    @State var ageLimit : String = "All"
    @State var feeType : String = "All"
    @State var showAlert = false
    
    @State var slotDataArray = [Session]()
    @State var filterDataArray = [Session]()
    
    let textLimit = 6

    var body: some View {
        
        VStack{
            ScrollView {
                Text("Find Covid Vaccine Center \nin India 🇮🇳").font(.title).fontWeight(.medium)
                    //.padding(.top)
                    .multilineTextAlignment(.center)
                
                ZStack(){
                    Rectangle()
                        .fill(Color.black).opacity(0.7)
                        .cornerRadius(5)
                        .shadow(radius:2)
                       // .frame(height: 290)
                    
                    VStack{
                        HStack {
                            Text("Enter Pincode:").bold()
                                .font(.title3)
                                .foregroundColor(.white)
                            Spacer()
                           
                            TextField("pincode", text: $pincode)
                                .keyboardType(.numberPad)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .multilineTextAlignment(.trailing)
                                .onReceive(Just(pincode)) { _ in limitText(textLimit) } //For max length of pincode
                                .frame(width: 120)
                        }.padding(.top, 15)
                        
                        HStack(spacing: 25) {
                            Text("Select Date:").bold().foregroundColor(.white)
                                .font(.title3)
                            Spacer()
                            DatePicker("", selection: $selectedDate, displayedComponents: .date)
                                .accentColor(.black)
                                .background(RoundedRectangle(cornerRadius: 5).fill(Color.white))
                                .frame(width: 120)
                                .cornerRadius(5)
                                .clipped()
                        }.padding(.top, 8)
                        
                        HStack(spacing: 5) {
                            Text("Age:").bold().foregroundColor(.white)
                                .font(.title3)
                            Spacer()
                            
                            HStack{
                                RadioButtonField(
                                    id: "15",
                                    label: "15+",
                                    color:.white,
                                    bgColor: .white,
                                    isMarked: $ageLimit.wrappedValue == "15" ? true : false,
                                    callback: { selected in
                                        self.ageLimit = selected
                                        self.feeType = "All"
                                        print("Selected age is: \(selected)")
                                        filterDataArray = slotDataArray.filter({$0.minAgeLimit == 15})
                                    }
                                )
                                
                                RadioButtonField(
                                    id: "18",
                                    label: "18+",
                                    color:.white,
                                    bgColor: .white,
                                    isMarked: $ageLimit.wrappedValue == "18" ? true : false,
                                    callback: { selected in
                                        self.ageLimit = selected
                                        self.feeType = "All"
                                        print("Selected age is: \(selected)")
                                        filterDataArray = slotDataArray.filter({$0.minAgeLimit == 18})
                                    }
                                )
                                
                                RadioButtonField(
                                    id: "45",
                                    label: "45+",
                                    color:.white,
                                    bgColor: .white,
                                    isMarked: $ageLimit.wrappedValue == "45" ? true : false,
                                    callback: { selected in
                                        self.ageLimit = selected
                                        self.feeType = "All"
                                        print("Selected age is: \(selected)")
                                        filterDataArray = slotDataArray.filter({$0.minAgeLimit == 45})
                                    }
                                )
                                
                                RadioButtonField(
                                    id: "All",
                                    label: "All",
                                    color:.white,
                                    bgColor: .white,
                                    isMarked: $ageLimit.wrappedValue == "All" ? true : false,
                                    callback: { selected in
                                        self.ageLimit = selected
                                        print("Selected age is: \(selected)")
                                        filterDataArray = slotDataArray
                                    }
                                )
                            }
                        }.padding(.top, 10)
                        
                        HStack(spacing: 25) {
                            Text("Fee:").bold().foregroundColor(.white)
                                .font(.title3)
                            Spacer()
                            
                            HStack{
                                RadioButtonField(
                                    id: "Free",
                                    label: "Free",
                                    color:.white,
                                    bgColor: .white,
                                    isMarked: $feeType.wrappedValue == "Free" ? true : false,
                                    callback: { selected in
                                        self.feeType = selected
                                        self.ageLimit = "All"
                                        print("Selected feeType is: \(selected)")
                                        filterDataArray = slotDataArray.filter({$0.feeType == "Free"})
                                    }
                                )
                                
                                RadioButtonField(
                                    id: "Paid",
                                    label: "Paid",
                                    color:.white,
                                    bgColor: .white,
                                    isMarked: $feeType.wrappedValue == "Paid" ? true : false,
                                    callback: { selected in
                                        self.feeType = selected
                                        self.ageLimit = "All"
                                        print("Selected feeType is: \(selected)")
                                        filterDataArray = slotDataArray.filter({$0.feeType == "Paid"})
                                    }
                                )
                                
                                RadioButtonField(
                                    id: "All",
                                    label: "All",
                                    color:.white,
                                    bgColor: .white,
                                    isMarked: $feeType.wrappedValue == "All" ? true : false,
                                    callback: { selected in
                                        self.feeType = selected
                                        self.ageLimit = "All"
                                        print("Selected feeType is: \(selected)")
                                        filterDataArray = slotDataArray
                                    }
                                )
                            }
                        }.padding(.top, 1)
                        
                        Button(action: {
                            if pincode != ""{
                                hideKeyboard()
                                self.callApiToGetAllCenter(pincode: self.pincode, date: self.selectedDate)
                            }
                        }) {
                            HStack(spacing: 10) {
                                Image(systemName: "magnifyingglass")
                                Text("Search")
                                .font(.headline)
                            }
                        }
                        .alert(isPresented: $showAlert) {
                                            Alert(title: Text(""), message: Text("No data found on this location, please try again"), dismissButton: .default(Text("OK")))
                                        }
                        .frame(width: 120, height: 40)
                        .background(Color.blue)
                        .foregroundColor(Color.white)
                        .cornerRadius(5)
                        .shadow(radius:2)
                        .padding(.top, 15)
                        .padding(.bottom, 15)
                    }.padding(.horizontal)
                    Spacer()
                }.padding()
                
                ScrollView { // Showing Api Data in List
                    ForEach(filterDataArray) { data in
                        ZStack(){
                            Rectangle()
                                .fill(Color.black).opacity(0.72)
                                .cornerRadius(5)
                                .shadow(radius:2)
                            
                            SlotData(data: data)
                        }}
                }.padding()
            }
            .padding(.top)
            .background(
                Image("vaccine")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .edgesIgnoringSafeArea(.all)
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
            .onTapGesture {
                hideKeyboard()
            }
            .onAppear{
                if self.pincode != ""{
                self.callApiToGetAllCenter(pincode: self.pincode, date: self.selectedDate)
                }
            }
        }
    }
    
    //Function to keep text length in limits
    func limitText(_ upper: Int) {
        if pincode.count > upper {
            pincode = String(pincode.prefix(upper))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
