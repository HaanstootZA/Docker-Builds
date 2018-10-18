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
Import-Module BitsTransfer

New-Item -ItemType Directory -Force -Path $setupPath

Write-Host "Downloading $sonarqubeUrl to $sonarqubeFile"
Start-BitsTransfer -Source $sonarqubeUrl-Destination $sonarqubeFile

Write-Host "Extracting $sonarqubeFile to $sonarqubeExtractPath"
[System.IO.Compression.ZipFile]::ExtractToDirectory($sonarqubeFile, $sonarqubeExtractPath)

Write-Host "Installing $sonarqubeExtractPath in $sonarqubeInstallPath"
Rename-Item -Path $sonarqubeExtractPath -NewName $sonarqubeInstallPath

Write-Host "Deleting $sonarqubeFile"
Remove-Item -Path $sonarqubeFile

Write-Host "Downloading $javaUrl to $javaFile"
Start-BitsTransfer -Source $javaUrl -Destination $javaFile

Write-Host "Installing $javaFile in $javaInstallPath"
Start-Process -filepath $javaFile -passthru -wait -argumentlist "/s,INSTALLDIR=$javaInstallPath,/L,install64.log"

Write-Host "Deleting $javaFile"
Remove-Item -Path $javaFile

Write-Host "Configuring JAVA_HOME: $javaInstallPath"
[System.Environment]::SetEnvironmentVariable("JAVA_HOME", $javaInstallPath)

if ($env:Path -notlike "*$newPath*")
{
    Write-Host "Configuring PATH: $newPath"
    [System.Environment]::SetEnvironmentVariable("PATH", $newPath)
}
else
{
    [System.Environment]::SetEnvironmentVariable("PATH", "C:\Program Files\Docker\Docker\Resources\bin;%SystemRoot%\system32;%SystemRoot%;%SystemRoot%\System32\Wbem;%SYSTEMROOT%\System32\WindowsPowerShell\v1.0\;C:\Program Files\Git\cmd;C:\Program Files\dotnet\;C:\Program Files\Microsoft SQL Server\130\Tools\Binn\;%JAVA_HOME%\bin")
}