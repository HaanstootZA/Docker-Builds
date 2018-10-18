$sonarqubeVersion = "sonarqube-7.3"
$javaVersion = "jdk-8u191"
$setupPath = "c:\Setup"

$sonarqubeUrl = "https://binaries.sonarsource.com/Distribution/sonarqube/$sonarqubeVersion.zip"
$sonarqubeFile = "$setupPath\$sonarqubeVersion.zip"
$sonarqubeExtractPath = "$env:ProgramFiles\$sonarqubeVersion"
$sonarqubeInstallPath = "$env:ProgramFiles\Sonarqube"

$javaUrl = "http://download.oracle.com/otn-pub/java/jdk/8u191-b12/2787e4a523244c269598db4e85c51e0c/jdk-8u191-windows-x64.exe"
$javaFile = "$setupPath\$javaVersion.exe"
$javaInstallPath = "$env:ProgramFiles\Java\$javaVersion"
$newPath = "$env:Path;JAVA_HOME\bin"

Add-Type -AssemblyName System.IO.Compression.FileSystem

Write-Host "Downloading $sonarqubeUrl to $sonarqubeFile"
Invoke-WebRequest -Uri $sonarqubeUrl -OutFile $sonarqubeFile

Write-Host "Extracting $sonarqubeFile to $sonarqubeExtractPath"
[System.IO.Compression.ZipFile]::ExtractToDirectory($sonarqubeFile, $sonarqubeExtractPath)

Write-Host "Installing $sonarqubeExtractPath in $sonarqubeInstallPath"
Rename-Item -Path $sonarqubeExtractPath -NewName $sonarqubeInstallPath

Write-Host "Deleting $sonarqubeFile"
Remove-Item -Path $sonarqubeFile

Write-Host "Downloading $javaUrl to $javaFile"
Invoke-WebRequest -Uri $javaUrl -OutFile $javaFile

Write-Host "Installing $javaFile in $javaInstallPath"
Start-Process -filepath $javaFile -passthru -wait -argumentlist "/s,INSTALLDIR=$javaInstallPath,/L,install64.log"

Write-Host "Deleting $javaFile"
Remove-Item -Path $javaFile

Write-Host "Configuring JAVA_HOME: $javaInstallPath"
[System.Environment]::SetEnvironmentVariable("JAVA_HOME", $javaInstallPath)
Write-Host "Configuring PATH: $newPath"
[System.Environment]::SetEnvironmentVariable("PATH", $newPath)