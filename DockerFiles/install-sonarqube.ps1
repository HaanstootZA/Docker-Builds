$sonarqubeVersion = "sonarqube-7.3"
$javaVersion = "jdk-8u191"
$setupPath = "c:\Setup"

$sonarqubeFile = "$setupPath\$sonarqubeVersion.zip"
$sonarqubeExtract = "$env:ProgramFiles"
$sonarqubeExtractPath = "$sonarqubeExtract\$sonarqubeVersion"
$sonarqubeInstallPath = "$env:ProgramFiles\Sonarqube"

$javaFile = "$setupPath\$javaVersion.exe"
$javaInstallPath = "$env:ProgramFiles\Java\$javaVersion"
$javaInstallArgs = "/s INSTALLDIR=`"$javaInstallPath`" ADDLOCAL=`"ToolsFeature,SourceFeature`""

Add-Type -AssemblyName System.IO.Compression.FileSystem

New-Item -ItemType Directory -Force -Path $setupPath

Write-Host ""
Write-Host "Extracting [`"$sonarqubeFile`" > `"$sonarqubeExtract`" (`"$sonarqubeExtractPath`")]"
[System.IO.Compression.ZipFile]::ExtractToDirectory($sonarqubeFile, $sonarqubeExtract)

Write-Host ""
Write-Host "Installing [`"$sonarqubeExtractPath`" > `"$sonarqubeInstallPath`"]"
Rename-Item -Path $sonarqubeExtractPath -NewName $sonarqubeInstallPath

Write-Host ""
Write-Host "Deleting [`"$sonarqubeFile`"]"
Remove-Item -Path $sonarqubeFile

Write-Host ""
Write-Host "Installing [`"$javaFile`" > `"$javaInstallPath`" ($javaInstallArgs)]"
Start-Process -filepath $javaFile -passthru -wait -argumentlist "$javaInstallArgs"


Write-Host ""
Write-Host "Deleting [`"$javaFile`"]"
Remove-Item -Path $javaFile

if (-not (Test-Path env:JAVA_HOME))
{
    Write-Host ""
    Write-Host "Configuring Environment Variable [JAVA_HOME : `"$javaInstallPath`"]"
    [System.Environment]::SetEnvironmentVariable("JAVA_HOME", $javaInstallPath, 'Machine')
}

if ($env:Path -notlike "*$javaInstallPath*")
{
    $newPath = "$env:Path;$javaInstallPath\bin"
    Write-Host ""
    Write-Host "Configuring Environment Variable [PATH : `"$newPath`"]"
    [System.Environment]::SetEnvironmentVariable("PATH", $newPath, 'Machine')
}