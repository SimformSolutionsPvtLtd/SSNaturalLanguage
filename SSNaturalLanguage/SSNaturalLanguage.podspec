#
# Be sure to run `pod lib lint SSNaturalLanguage.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SSNaturalLanguage'
  s.version          = '0.1.0'
  s.summary          = 'Exploring word embedding and text catalogs with SSNaturalLanguage framework.'

  s.description      = <<-DESC
'SSNaturalLanguage framework let you help with language related stuffs like tokenisation, lemmatization, languageIdentification, spellCorrection, partOfSpeech, sentimental score, neighboringWord, uniqueTagsFromSentense, etc... with just a single function call.'
                       DESC

  s.homepage         = 'https://github.com/Abhi Makadiya/SSNaturalLanguage'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Abhi Makadiya' => 'abhi.m@simformsolutions.com' }
  s.source           = { :git => 'https://github.com/Abhi Makadiya/SSNaturalLanguage.git', :tag => s.version.to_s }

  s.ios.deployment_target = '13.0'

  s.source_files = 'Classes/**/*'
  
  s.swift_version = '5.0'
  
  s.platforms = {
      "ios": "13.0"
  }
  
end
