# escape=` (backtick)

FROM microsoft/windowsservercore
ADD sonarqube-7.3.zip c:\Setup\sonarqube-7.3.zip
ADD jdk-8u191.exe c:\Setup\jdk-8u191.exe
ADD install-sonarqube.ps1 c:\temp\install-sonarqube.ps1
RUN powershell.exe "c:\temp\install-sonarqube.ps1"
ENTRYPOINT cmd /W "C:\Program Files\Sonarqube\bin\windows-x86-64\StartSonar.bat"
CMD [ "powershell" ]
