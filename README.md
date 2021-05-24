<a href="https://www.simform.com/"><img src="https://github.com/SimformSolutionsPvtLtd/SSToastMessage/blob/master/simformBanner.png"></a>
# SSNaturalLanguage
The SSNaturalLanguage framework let you provide a variety of natural language processing functionality with support for many different languages and scripts. Use SSNaturalLanguage framework to segment natural language text into paragraphs, sentences or words and tag information about those segments such as part of speech, lexical class, lemma, script and language.

<p align="left">
<a href="https://developer.apple.com/swift"><img src="https://img.shields.io/badge/Swift_5-compatible-4BC51D.svg?style=flat" alt="Swift 5 compatible" /></a>
<img src="https://img.shields.io/badge/platform-iOS-blue.svg?style=flat" alt="Platform iOS" />
<a href="https://raw.githubusercontent.com/maxsokolov/tablekit/master/LICENSE"><img src="http://img.shields.io/badge/license-MIT-blue.svg?style=flat" alt="License: MIT" /></a>
</p>

# Requirements
  - iOS 13.0+
  - Xcode 11+
 
# Installation
#### CocoaPods
 
- You can use CocoaPods to install SSNaturalLanguage by adding it to your Podfile:

       use_frameworks!
       pod 'SSNaturalLanguage'

- import SSNaturalLanguage

#### Manually
-   Download and drop **SSNaturalLanguage** folder in your project.
-   Congratulations!

#### Swift Package Manager
-   When using Xcode 11 or later, you can install `SSNaturalLanguage` by going to your Project settings > `Swift Packages` and add the repository by providing the GitHub URL. Alternatively, you can go to `File` > `Swift Packages` > `Add Package Dependencies...`
```swift
dependencies: [
    .package(url: "https://github.com/mobile-simformsolutions/SSNaturalLanguage.git", from: "0.1.0")
]
```
####  Carthage
-   [Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks. You can install Carthage with [Homebrew](http://brew.sh/) using the following command:
```bash
$ brew update
$ brew install carthage
```
To integrate `SSNaturalLanguage` into your Xcode project using Carthage, add the following line to your `Cartfile`:

```ogdl
github "mobile-simformsolutions/SSNaturalLanguage"
```
Run `carthage` to build and drag the `SSNaturalLanguage`(Sources/SSNaturalLanguage) into your Xcode project.

# How It Works
- SSNaturalLanguage framework let you help with language related stuffs like tokenisation, lemmatization, languageIdentification, spellCorrection, partOfSpeech, sentimental score, neighboringWord, uniqueTagsFromSentense, etc... with just a single function call.

#### 1. Split Text
- SSNaturalLanguage can split a string into chunks of words, sentences, characters or paragraphs. These segmented texts can then be processed together or separately, depending on the use case. To split string, the `NLTokenizer` class is used.
```swift
import SSNaturalLanguage
var text = "How are you? Where were you?"
let arrSplitText = text.splitInto(unit: .sentence)
```
- `splitInto` function will return array of unit passed in input param.

#### 2. Base Form
- SSNaturalLanguage can convert a word into its base form. For example "assumed" and "assuming" will convert into "assume".
- It is commonly used in word tagging and fuzzy matching (which identifies misspelled words, like what you'd see in a Google search).
```swift
var text = "I am running late for the 10 km marathon run that was scheduled for today. Can we reschedule the meeting?"
let arrBaseForm = text.toBaseForm()
```
- It will return array of tuple with word and its baseForm.
```
I - I
am - be
running - run
late - late
for - for
the - the
marathon - marathon
run - run
that - that
was - be
scheduled - schedule
for - for
today - today
Can - can
we - we
reschedule - reschedule
the - the
meeting - meeting
```
#### 3. Language Identification
- `identifyLanguage` function helps us determine a piece of text language from a string. It returns language code from the text's context.
```swift
var text = "Gracias"
let languageCode = text.identifyLanguage()
print(languageCode) ==> "es"
```
- identifyLanguage will return language code. we can now convert it to particular language name with:
```swift
Locale.current.localizedString(forIdentifier: languageCode)) ==> "Spanish"
```
#### 4. Predicted Language
- Following `predictedLanguage` function returns the top 2 predicted languages and return array of tuple with languageCode and its confidence.
```swift
var text = "Mart Goorsqu'ent avainq ce mennoci faucte. pirrin to l'onçair-là der mosepe, qués, audeu! of therci; this asiblio whot fore; Mme jecome de da vidger. Cohe witid-hus joir."
let arrPredictedLangs = text.predictedLanguage(maxPredictCount: 2)
```
#### 5. Spell Correction
- Spell Checking and correction is another very important and popular application that has real-world value for any text-based apps that you might build.
- The biggest example of this is Google search itself. it tries to correct our spelling to make sure we get the right results for your query.
- `correctSpell` function will help you to correct spelling from the text.
```swift
let text = """
I started my schooling as the majority did in my area, at the local primarry school. I then
went to the local secondarry school and recieved grades in English, Maths, Phisics,
Biology, Geography, Art, Graphical Comunication and Philosophy of Religeon. I'll not
bore you with the 'A' levels and above.
"""
let correctText = text.correctSpell()
```
**Result**: I started my schooling as the majority did in my area, at the local `primary` school. I then went to the local `secondary` school and received grades in English, Maths, `Physics`, Biology, Geography, Art, Graphical Communication and Philosophy of Religion. I'll not bore you with the 'A' levels and above.

#### 6. Part Of Speech (POS) Tagging
- Every word in a sentence is associated with a Part Of Speech (POS) tag - noun, verbs, adjectives, adverbs, etc.
- POS tags are widely used for text analytics as they encompass additional information of the text data at hand.
- `partOfSpeech` function will diagnosis input text and return array of tuple with word and its tag.
```swift
let text = "Hello world, I am a data scientist. I work with machine learning!"
let pos = text.partOfSpeech()

Result: 
Hello - Interjection
world - Noun
I - Pronoun
am - Verb
a - Determiner
data - Noun
scientist - Noun
I - Pronoun
work - Verb
with - Preposition
machine - Noun
learning - Noun
```
#### 7. Identify person Entity
- Following `recognizePersonName` will return array of identified personName from given text.
```swift
let text = "Jackie, are you leaving so soon?"
let arrPersonName = text.recognizePersonName()

Result:
["Jackie"]
```
#### 8. Identify placeName
- Following `recognizePlaceName` will return array of identified placeName from given text.
```swift
let text = "Apple is looking at buying U.K. startup for $1 billion."
let arrPlaceName = text.recognizePlaceName()

Result:
["U.K."]
```
#### 9. Identify Organization Name
- Following `recognizeOrganizationName` will return array of identified organizationName from given text.
```swift
let text = "Apple is looking at buying U.K. startup for $1 billion."
let arrOrganizationName = text.recognizeOrganizationName()

Result:
["Apple"]
```
#### 10. Sentimental Analysis
- Sentiment Analysis is when we try to predict the sentiment of a given piece of text: is it positive, negative or neutral?
- `sentimentalScore` function will return sentimental score from given text.
- The range of sentimental score is `[-1.0, 1.0]`. A score of `1.0` is the most positive, a score of `-1.0` is the most negative, and a score of 0.0 is neutral.
- Sentiment analysis feature is supports 7 languages: English, Spanish, French, Italian, German, Portuguese, Simplified Chinese.
```swift
let text = "I hate this apple pie."
let sentimentalScore = text.sentimentalScore()
print(sentimentalScore) ==> -0.6
```
#### 11. Word Embedding
![Alt text](https://github.com/mobile-simformsolutions/SSNaturalLanguage/blob/feature/Readme_setup/Attachments/Vectors.png)
- `neighboringWords` function will find similar kinds of word from given word. Ex. Let's say we type "king". Off the top of my head, we would want words like "prince", "crown", "throne" etc...
```swift
let word = "cheese"
let arrSimilarWords = word.neighboringWords(maximumResult: 5)

Result:
[(word: "mozzarella", distance: 0.631902277469635), (word: "cheddar", distance: 0.6747748851776123), (word: "provolone", distance: 0.6827872395515442), (word: "ricotta", distance: 0.6940725445747375), (word: "focaccia", distance: 0.7102253437042236)]
```
#### 11. Unique Tags
- To find unique word from given string, `findUniqueTag` will help.
```swift
let text = "I love machine learning and I work as a Data Scientist in India."
let arrUniqueWord = text.findUniqueTag()

Result:
["Machine", "Learning", "Scientist", "India", "Data"]
```
## Find this library useful? :heart:
Support it by joining __[stargazers](https://github.com/SimformSolutionsPvtLtd/SSNaturalLanguage/stargazers)__ for this repository. :star:
# License
- SSNaturalLanguage is available under the MIT license. See the LICENSE file for more info.
