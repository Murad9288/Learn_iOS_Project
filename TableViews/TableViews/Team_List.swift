//
//  Team_List.swift
//  TableViews
//
//  Created by Md Murad Hossain on 7/8/22.
//

import SwiftUI

struct Team_List: View {
    var teamToinvite: [Team]
    var body: some View {
        NavigationView{
            List(teamToinvite){
                Team in ListRow(eachTeam: Team)
            }.navigationTitle(Text("Team Members"))
        }
    }
}
struct ListRow: View {
    
    var eachTeam: Team
    var body: some View{
        HStack{
            Text(eachTeam.name)
            Spacer()
            Image("img")
            
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: 40)
        }
    }
}


var myteam = [
    Team(id: 1, name: "Murad"),
    Team(id: 2, name: "Faysal"),
    Team(id: 3, name: "Kashem"),
    Team(id: 4, name: "Rubel"),
    Team(id: 5, name: "Shuvo"),
    Team(id: 6, name: "Kawsar"),
    Team(id: 7, name: "Masum"),
    Team(id: 8, name: "Mofajjol"),
    Team(id: 9, name: "Imran"),
    Team(id: 10, name: "Rana"),
    Team(id: 11, name: "Fahim"),
    Team(id: 12, name: "Saberul"),
    Team(id: 13, name: "Masud"),
    Team(id: 14, name: "Monir"),
    Team(id: 15, name: "Jony")
    
    

]


struct Team_List_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            Team_List(teamToinvite: myteam)
                .previewLayout(.device)
            .previewDevice("iPhone 13 Pro Max")
            Team_List(teamToinvite: myteam)
                .previewLayout(.device)
                .previewDevice("iPhone 13 Pro Max")
                .previewInterfaceOrientation(.portrait)
        }
    }
}
