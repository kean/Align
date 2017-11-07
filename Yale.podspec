Pod::Spec.new do |s|
    s.name             = "Yale"
    s.version          = "0.1"
    s.summary          = "Auto Layout"

    s.homepage         = "https://github.com/kean/Yale"
    s.license          = "MIT"
    s.author           = "Alexander Grebenyuk"
    s.social_media_url = "https://twitter.com/a_grebenyuk"
    s.source           = { :git => "https://github.com/kean/Yale.git", :tag => s.version.to_s }

    s.ios.deployment_target = "10.0"
    s.tvos.deployment_target = "10.0"

    s.source_files  = "Sources/**/*"
end
