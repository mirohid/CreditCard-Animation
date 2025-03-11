import SwiftUI
import RealmSwift

// Define the Realm model for credit cards
class CreditCard: Object, Identifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var cardNumber: String = ""
    @Persisted var expiryDate: String = ""
    @Persisted var cvv: String = ""
    @Persisted var cardholderName: String = ""
    @Persisted var dateAdded: Date = Date()
    
    convenience init(cardNumber: String, expiryDate: String, cvv: String, cardholderName: String) {
        self.init()
        self.id = ObjectId.generate()
        self.cardNumber = cardNumber
        self.expiryDate = expiryDate
        self.cvv = cvv
        self.cardholderName = cardholderName
    }
}

// Main ContentView with TabView
struct ContentView: View {
    var body: some View {
        TabView {
            AddCardView()
                .tabItem {
                    Label("Add Card", systemImage: "creditcard.and.123")
                }
            
            SavedCardsView()
                .tabItem {
                    Label("Saved Cards", systemImage: "wallet.pass")
                }
        }
    }
}

#Preview{
    ContentView()
}
