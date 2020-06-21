Pod::Spec.new do |s|
    s.name             = "Align"
    s.version          = "2.4.1"
    s.summary          = "An intuitive and powerful Auto Layout library"

    s.homepage         = "https://github.com/kean/Align"
    s.license          = "MIT"
    s.author           = "Alexander Grebenyuk"
    s.social_media_url = "https://twitter.com/a_grebenyuk"
    s.source           = { :git => "https://github.com/kean/Align.git", :tag => s.version.to_s }

    s.swift_versions = ['5.1', '5.2']

    s.ios.deployment_target = '11.0'
    s.osx.deployment_target = '10.13'
    s.tvos.deployment_target = '11.0'

    s.source_files  = "Sources/**/*"
end
