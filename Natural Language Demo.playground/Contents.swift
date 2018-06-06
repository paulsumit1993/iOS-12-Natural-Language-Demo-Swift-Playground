// Run on macOS Mojave Beta (10.14+)
import NaturalLanguage

let text = <#test_string#> // example string: "একটি মহান পাহাড় আরোহণ করার পরে, শুধুমাত্র এক যে আরো অনেক পাহাড় আরোহণ আছে খুঁজে পাওয়া যায় নি।"

/// Finds the most likely language for the text provided as input.
///
/// - Parameter text: The text to analyze.
/// - Returns: The most likely language of the text.
func findDominantlanguage(for text: String) -> NLLanguage? {
    let naturalLanguageRecognizer = NLLanguageRecognizer()
    naturalLanguageRecognizer.processString(text)
    return naturalLanguageRecognizer.dominantLanguage
}

/// Breaks the input string into tokens based on the inputs
///
/// - Parameters:
///   - text: The text to be tokenized.
///   - unit: The linguistic unit that this tokenizer uses. https://developer.apple.com/documentation/naturallanguage/nltokenizer/2998450-unit
/// - Returns: A dictionary of the token and hints about the contents of the string for the tokenizer.
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

/// Function to classify nouns, verbs, adjectives, and other parts of speech in a string.
///
/// - Parameters:
///   - text: The text to be classified.
///   - tagSchemes: The tag schemes configured for this linguistic tagger.
///   - tagOptions: Constants for linguistic tagger enumeration specifying which tokens to omit and whether to join names.
/// - Returns: A dictionary of the token and noun, verb, adjective, and other parts of speech in the token.
func determinePartsofSpeech(of text: String, with tagSchemes: [NLTagScheme], and tagOptions: NLTagger.Options) -> [String: String] {
    let tagger = NLTagger(tagSchemes: tagSchemes)
    tagger.string = text
    let options = tagOptions
    var dict = [String: String]()
    tagger.enumerateTags(in: text.startIndex..<text.endIndex, unit: .word, scheme: tagSchemes.first!, options: options) { tag, tokenRange in
        if let tag = tag {
            dict[tag.rawValue] = String(text[tokenRange])
        }
        return true
    }
    return dict
}

func namedEntity(in text: String, with tagSchemes: [NLTagScheme], tagOptions: NLTagger.Options, and tags: [NLTag]) -> [String: String] {
    let tagger = NLTagger(tagSchemes: tagSchemes)
    tagger.string = text
    let options = tagOptions
    let tags = tags
    var dict = [String: String]()
    tagger.enumerateTags(in: text.startIndex..<text.endIndex, unit: .word, scheme: tagSchemes.first!, options: options) { tag, tokenRange in
        if let tag = tag, tags.contains(tag) {
            dict[tag.rawValue] = String(text[tokenRange])
        }
        return true
    }
    return dict
}

findDominantlanguage(for: text)
tokenize(string: text, using: .word)

