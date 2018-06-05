// Run on macOS Mojave Beta (10.14+)

import NaturalLanguage

let text = <#language string#> // example string: "একটি মহান পাহাড় আরোহণ করার পরে, শুধুমাত্র এক যে আরো অনেক পাহাড় আরোহণ আছে খুঁজে পাওয়া যায় নি।"

func findDominantlanguage(for text: String) -> NLLanguage? {
    let naturalLanguageRecognizer = NLLanguageRecognizer()
    naturalLanguageRecognizer.processString(text)
    return naturalLanguageRecognizer.dominantLanguage
}

func tokenize(string text: String, using unit: NLTokenUnit) -> [String: NLTokenizer.Attributes] {
    let tokenizer = NLTokenizer(unit: unit)
    tokenizer.string = text
    var tokensAndAttributes = [String: NLTokenizer.Attributes]()
    tokenizer.enumerateTokens(in: text.startIndex..<text.endIndex) { tokenRange, attributes in
        tokensAndAttributes[String(text[tokenRange])] = attributes
        return true
    }
    return tokensAndAttributes
}

findDominantlanguage(for: text)
tokenize(string: text, using: .word)

