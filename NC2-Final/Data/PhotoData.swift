//
//  userdefaultData.swift
//  NC2-Final
//
//  Created by 김하준 on 6/19/24.
//

import Foundation

struct PhotoData: Identifiable {
    var id: UUID = UUID()
    var name: String
    var label: SelectedPerson
}
