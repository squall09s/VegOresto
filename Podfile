platform :ios, '10.0'
use_frameworks!

# plugin cocoapods-keys (via gem install), see github for details
plugin 'cocoapods-keys', {
    :project => "VegOresto",
    :keys => [
        "apiBaseUrl",
        "apiClientId",
        "apiClientSecret",
    ]
}

target 'VegOresto' do
    pod 'SVPulsingAnnotationView'
    pod 'SwiftGen'
    pod 'MGSwipeTableCell'
    pod 'SwiftSpinner'
    pod 'MapleBacon'
    pod 'VTAcknowledgementsViewController'
    pod 'LNRSimpleNotifications'
    pod 'MarqueeLabel'
    pod 'PromiseKit'

    # Webservices
    pod 'Alamofire'
    pod 'ObjectMapper'
    pod 'JSONWebToken'
    pod 'PromiseKit/Alamofire'
    pod 'AlamofireNetworkActivityIndicator', '~> 2.2'
    pod 'AlamofireNetworkActivityLogger', '~> 2.0'

    # Captcha
    pod 'ReCaptcha'

    #UX/UI
    pod 'MBProgressHUD', '~> 1.0.0'
    pod 'DGElasticPullToRefresh'
    pod 'FaveButton'
    pod 'ImagePicker', '~> 3.0.0'
    pod 'SkyFloatingLabelTextField'
    pod 'SDWebImage'
    pod 'BEMCheckBox'
    
    # Firebase + Fabric
    pod 'Firebase/Core'
    pod 'Fabric', '~> 1.7.2'
    pod 'Crashlytics', '~> 3.9.3'
end

post_install do |installer|
    # List of Pods to use as Swift 4.0
    swift40Targets = ['ImagePicker']

    installer.pods_project.targets.each do |target|
        if swift40Targets.include? target.name
            target.build_configurations.each do |config|
                config.build_settings['SWIFT_VERSION'] = '4.0'
            end
        end
    end
end
