//
//  FormView.swift
//  
//
//  Created by Jevon Levin on 08/04/23.
//

import SwiftUI

struct FormView: View {
    var text: String
    @Binding var isModalVisible: Bool
    var field: AnyView
    var body: some View {
        VStack{
            HStack{
                Text(text)
                    .font(Font.custom("Take Coffee", size: 32))
                    .foregroundColor(Color("SecondaryDark")) 
                Button{
                    withAnimation{
                        isModalVisible = true
                    }
                }label: {
                    Image(systemName: "info.circle")
                        .foregroundColor(Color("SecondaryDark"))
                }
            }
            field
//            TextField("", text: $nameTxt)
//                .font(Font.custom("Take Coffee", size: 24))
//                .padding() 
//                .foregroundColor(.white)
//                .colorMultiply(Color("SecondaryDark"))
//                .border(Color("SecondaryDark"), width: 8)
//                .cornerRadius(12, antialiased: true)
        }
    }
}

struct FormView_Previews: PreviewProvider {
    static var previews: some View {
        FormView(text: "halo", isModalVisible: .constant(false), field: AnyView(Text("tes")))
    }
}
