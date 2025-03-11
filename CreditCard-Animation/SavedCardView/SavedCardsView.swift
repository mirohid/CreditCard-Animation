import SwiftUI
import RealmSwift

struct SavedCardsView: View {
    @ObservedResults(CreditCard.self) var savedCards
    @State private var selectedCard: CreditCard?
    @State private var isCardFlipped = false
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        NavigationView {
            ZStack {
                // Background
                (colorScheme == .dark ? Color.black : Color(hex: "F8F9FA"))
                    .edgesIgnoringSafeArea(.all)
                
                if savedCards.isEmpty {
                    EmptyStateView()
                } else {
                    CardListView(savedCards: savedCards, selectedCard: $selectedCard)
                }
                
                if let selectedCard = selectedCard {
                    CardDetailView(
                        card: selectedCard,
                        isFlipped: $isCardFlipped,
                        onDismiss: { self.selectedCard = nil }
                    )
                    .transition(.opacity)
                    .animation(.easeInOut, value: selectedCard)
                }
            }
            .navigationTitle("Saved Cards")
        }
    }
}

// MARK: - Extracted Subviews

struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "creditcard.trianglebadge.exclamationmark")
                .font(.system(size: 70))
                .foregroundColor(.gray)
            
            Text("No Cards Saved")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Add a card in the 'Add Card' tab")
                .foregroundColor(.gray)
        }
    }
}

struct CardListView: View {
    var savedCards: Results<CreditCard>
    @Binding var selectedCard: CreditCard?

    var body: some View {
        List {
            ForEach(savedCards) { card in
                CardRowView(card: card, selectedCard: $selectedCard)
            }
        }
        .listStyle(PlainListStyle())
        .background(Color(hex: "F8F9FA"))
    }
}

struct CardRowView: View {
    var card: CreditCard
    @Binding var selectedCard: CreditCard?

    var body: some View {
        CardListItem(card: card)
            .onTapGesture {
                selectedCard = card
            }
            .listRowSeparator(.hidden)
            .listRowBackground(Color.clear)
            .listRowInsets(EdgeInsets(top: 10, leading: 16, bottom: 10, trailing: 16))
            .swipeActions(edge: .trailing) {
                Button(role: .destructive) {
                    if let thawedCard = card.thaw() {
                        try? thawedCard.realm?.write {
                            thawedCard.realm?.delete(thawedCard)
                        }
                    }
                } label: {
                    Label("Delete", systemImage: "trash")
                }
            }
    }
}
