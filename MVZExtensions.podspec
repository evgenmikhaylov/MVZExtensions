Pod::Spec.new do |s|

s.name                = "MVZExtensions"
s.version             = "0.0.1"
s.summary             = "iOS useful categories"
s.homepage            = "https://github.com/medvedzzz/MVZExtensions"
s.license             = 'MIT'
s.author              = { "Evgeny Mikhaylov" => "evgenmikhaylov@gmail.com" }
s.source              = { :git => "https://github.com/medvedzzz/MVZExtensions.git", :tag => "0.0.1" }
s.platform            = :ios, '8.0'
s.requires_arc        = true
s.source_files        = 'MVZExtensions/*.{h,m}'

s.dependency            'ReactiveCocoa', '~> 2.5'

end
