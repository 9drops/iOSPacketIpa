# iOSPacketIpa
xcode项目命令行打ipa包(企业账号In-hourse模式)

使用说明
1.将build.sh和autobuild拷贝到xcode项目根目录下（即和.xcodeproj同一目录）
2.将.mobileprovision文件拷贝到autobuild下
3.配置autobuild下build.conf中的 
ProvisionFileRelease=DropsAppsDistribute.mobileprovision
CodesignRelease="iPhone Distribution: Yunnan Yundian Tongfang Technology Co.,   Ltd./"

4.在xcode项目根目录下运行sh build.sh ipaName bundleName version，ipa包生成在桌面上

