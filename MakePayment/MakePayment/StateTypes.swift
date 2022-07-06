//
//  StateTypes.swift
//  MakePayment
//
//  Created by Davin Henrik on 7/6/22.
//

import SwiftUI

class StateType: ObservableObject {
    @Published var tcInfoBox: Bool = false
    @Published var tcFooterMessage: Bool = false
    @Published var reviewPayBtn: Bool = true
    @Published var acctName: String = "Start Position"
    @Published var acctPerson: String = "Start Position"
    @Published var acctAge: String = "Start Position"
    @Published var acceptTCStatus: Bool {
        didSet {
            UserDefaults.standard.set(acceptTCStatus, forKey: "acceptTCStatus")
        }}
    @Published var acceptNeutralStatus: Bool {
        didSet {
            UserDefaults.standard.set(acceptNeutralStatus, forKey: "acceptNeutralStatus")
        }}
    @Published var acceptResetStatus: Bool {
        didSet {
            UserDefaults.standard.set(acceptResetStatus, forKey: "acceptResetStatus")
        }}
    @Published var acceptString: String = "Start Position"
    @Published var modelData = [StateData]()
    @Published var newModelData = StateData()
    @Published var tcActive: Bool = false
    @Published var neutralActive: Bool = false
    @Published var resetActive: Bool = false
    
    init() {
        self.acceptTCStatus = UserDefaults.standard.object(forKey: "acceptTCStatus") as? Bool ?? false
        self.acceptNeutralStatus = UserDefaults.standard.object(forKey: "acceptNeutralStatus") as? Bool ?? false
        self.acceptResetStatus = UserDefaults.standard.object(forKey: "acceptResetStatus") as? Bool ?? false
    }
}

struct DisplayTypes: View {
    var body: some View {
        StateTypes(viewModel: StateType())
    }
}

struct StateTypes: View {
    @ObservedObject var viewModel = StateType()
    @State var testActive = ""
    
    
    
    var body: some View {
        VStack {
            Text("\(viewModel.acctName)")
                .padding()
            Text("\(viewModel.acctPerson)")
            Text("\(viewModel.acctAge)")
            Text("\(viewModel.acceptString)")
            
        HStack {
            Button("tc", action: {
                getAcctType(acctType: .tc)
                viewModel.tcActive = true
                testActive = "tcActive"
            })
            Button("neutral", action: {
                getAcctType(acctType: .neutral)
                viewModel.neutralActive = true
                testActive = "neutralActive"
            })
            Button("reset", action: {
                getAcctType(acctType: .reset)
                viewModel.resetActive = true
                testActive = "resetActive"
            })
        }
        .padding(.bottom)
            
        VStack {
            
            Button("Accepted") {
                if testActive == "tcActive" {
                    getActiveType(activeType: .tcActive)
                } else if testActive == "neutralActive" {
                    getActiveType(activeType: .neutralActive)
                } else if testActive == "resetActive" {
                    getActiveType(activeType: .resetActive)
                }
            }
        }
    }
    }
    enum ActiveType {
        case tcActive
        case neutralActive
        case resetActive
    }
    
    func getActiveType(activeType: ActiveType) {
        switch activeType {
        case .tcActive:
            viewModel.acceptTCStatus.toggle()
        case .neutralActive:
            viewModel.acceptNeutralStatus.toggle()
        case .resetActive:
            viewModel.acceptResetStatus.toggle()
        }
        }
    
    enum AcctType {
        case tc
        case neutral
        case reset
    }

    func getAcctType(acctType: AcctType) {
        switch acctType {
        case .tc:
            viewModel.tcInfoBox = true
            viewModel.tcFooterMessage = true
            viewModel.reviewPayBtn = false
            viewModel.acctName = "Terms & Conditions"
            viewModel.acctAge = viewModel.newModelData.age[0]
            viewModel.acctPerson = viewModel.newModelData.names[0]
            viewModel.acceptString = viewModel.acceptTCStatus ? "True" : "False"
            
            
        case .neutral:
            viewModel.tcInfoBox = false
            viewModel.tcFooterMessage = false
            viewModel.acctName = "Standard"
            viewModel.acctAge = viewModel.newModelData.age[1]
            viewModel.acctPerson = viewModel.newModelData.names[1]
            viewModel.acceptString = viewModel.acceptNeutralStatus ? "True" : "False"
            
        case .reset:
            viewModel.tcInfoBox = false
            viewModel.tcFooterMessage = false
            viewModel.acctName = "Checking"
            viewModel.acctAge = viewModel.newModelData.age[2]
            viewModel.acctPerson = viewModel.newModelData.names[2]
            viewModel.acceptString = viewModel.acceptResetStatus ? "True" : "False"
        }
    }

}

struct StateData {
    let names = ["Mark", "Sue", "Carl"]
    let age = ["32", "46", "67"]
    var accept = ["", "", ""]
}
