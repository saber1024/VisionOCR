Pod::Spec.new do |s|

s.name         = 'LYCoreMLOCR'
s.version      =  "1.0.0"
s.summary      =  "基于Core ML的身份证OCR库"
s.description  =  <<-DESC

基于Core ML的身份证OCR库
DESC

s.homepage     = "https://github.com/saber1024/VisionOCR"
s.license      = { :type => "MIT", :file => "LICENSE" }
s.author       = {"Jennie的睫毛膏" => "zhushuai19@gmail.com"}
s.platform     = :ios, "11.0"
s.source       = {:git =>"https://github.com/saber1024/VisionOCR.git" :tag => s.version}
s.source_files = "Classes", "TextDetection/LYIDcardOcrHelper.swift"
s.requires_arc = true
end

