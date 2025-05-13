import SwiftUI

struct Quote: Codable, Identifiable {
    var id = UUID()
    var text: String
    var author: String?
}

struct ContentView: View {
    @State private var quote = Quote(text: "Loading...", author: "")

    var body: some View {
        VStack {
            Text(quote.text)
                .font(.title)
                .padding()
            Text(quote.author ?? "Unknown")
                .font(.subheadline)
                .foregroundColor(.gray)
            Button("New Quote") {
                fetchQuote()
            }
            .padding()
        }
        .onAppear(perform: fetchQuote)
    }

    func fetchQuote() {
        let url = URL(string: "https://type.fit/api/quotes")!
        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data, let quotes = try? JSONDecoder().decode([Quote].self, from: data) {
                DispatchQueue.main.async {
                    quote = quotes.randomElement() ?? Quote(text: "No quote", author: nil)
                }
            }
        }.resume()
    }
}
