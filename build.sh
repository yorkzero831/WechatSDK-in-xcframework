curl https://dldir1.qq.com/WechatWebDev/opensdk/OpenSDK2.0.0.zip -o wechatsdk.zip
unzip wechatsdk.zip -d wechatsdk

function process {
    L_PATH=$1
    OUTPUT_PATH=$2

    mkdir $L_PATH/lib

    lipo $L_PATH/libWeChatSDK.a -thin arm64 -output $L_PATH/lib/libWeChatSDK-arm64.a
    lipo $L_PATH/libWeChatSDK.a -thin armv7 -output $L_PATH/lib/libWeChatSDK-armv7.a
    lipo $L_PATH/libWeChatSDK.a -thin x86_64 -output $L_PATH/lib/libWeChatSDK-x86_64.a

    mkdir temp
    cd temp

    ar x ../$L_PATH/lib/libWeChatSDK-arm64.a

    ls -al

    for file in *.o; do echo processing $file && arm64-to-sim $file; done;

    ar crv ../$L_PATH/lib/libWeChatSDK-sim-arm64.a *.o

    ls -al

    cd ..

    mkdir $L_PATH/merge

    lipo -create -output $L_PATH/merge/libWeChatSDK-armv7_arm64.a $L_PATH/lib/libWeChatSDK-armv7.a $L_PATH/lib/libWeChatSDK-arm64.a
    lipo -create -output $L_PATH/merge/libWeChatSDK-arm64_x86_64.a $L_PATH/lib/libWeChatSDK-sim-arm64.a $L_PATH/lib/libWeChatSDK-x86_64.a


    mkdir $OUTPUT_PATH
    rm -rf $OUTPUT_PATH/*

    mkdir $L_PATH/headers
    cp $L_PATH/*.h $L_PATH/headers/

    xcodebuild -create-xcframework -library $L_PATH/merge/libWeChatSDK-armv7_arm64.a -headers $L_PATH/headers  -library $L_PATH/merge/libWeChatSDK-arm64_x86_64.a  -headers $L_PATH/headers  -output $OUTPUT_PATH/WeChatSDK.xcframework

    zip -r $OUTPUT_PATH.zip $OUTPUT_PATH 
}

process 'wechatsdk/SDKExport' './output/wechatsdk-withpay'
# process 'alipay-noutdid/iOS' './output/alipay-noutdid'