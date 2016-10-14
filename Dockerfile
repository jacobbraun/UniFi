FROM microsoft/windowsservercore 

MAINTAINER azcii

# Download the needed files
ADD http://javadl.oracle.com/webapps/download/AutoDL?BundleId=211999 C:/Downloads/jre-8u101-windows-x64.exe
ADD http://javadl.oracle.com/webapps/download/AutoDL?BundleId=211997 C:/Downloads/jre-8u101-windows-i586.exe
ADD http://www.7-zip.org/a/7z1604-x64.exe C:/Downloads/7z1604-x64.exe
ADD http://dl.ubnt.com/unifi/5.2.9/UniFi-installer.exe C:/Downloads/UniFi-installer.exe

# Installing Java
RUN powershell start-process -filepath C:\Downloads\jre-8u101-windows-x64.exe -passthru -wait -argumentlist "/s,INSTALLDIR=c:\Java\jre1.8.0_101-x64,/L,install64.log"
RUN powershell start-process -filepath C:\Downloads\jre-8u101-windows-i586.exe -passthru -wait -argumentlist "/s,INSTALLDIR=c:\Java\jre1.8.0_101-x86,/L,install86.log"
RUN REG ADD "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v Path /t REG_EXPAND_SZ /d "c:\Java\jre1.8.0_101-x86\bin;c:\Java\jre1.8.0_101-x64\bin;%PATH%" /f

# Installing and Using 7-zip
RUN C:\Downloads\7z1604-x64.exe /S /D=C:\7-Zip
RUN C:\7-Zip\7z.exe x C:/Downloads/UniFi-installer.exe -y -oC:\UniFi

# Cleanup after install
RUN rd C:\Downloads /s /q

# Get UniFi to run as Windows Service
RUN powershell Set-Location C:\UniFi; java -jar lib\ace.jar installsvc
# RUN net start "UniFi Controller" 

# The UniFi Controller service is starting.
# The UniFi Controller service could not be started. 
# A service specific error occurred: 1.
# More help is available by typing NET HELPMSG 3547.
# C:\UniFi>NET HELPMSG 3547 -> A service specific error occurred: ***.

# docker run -it azcii/unifi cmd -p 8080:8080 -p 8443:8443 -p 8843:8843 -p 8880:8880 -p 3478:3478 cmd