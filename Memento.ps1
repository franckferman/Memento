<#
.SYNOPSIS
File Renaming Tool using RLO Character for Extension Spoofing.

.DESCRIPTION
This script renames a .exe file by applying the Right-to-Left Override (RLO) character, allowing for visual spoofing of the file extension. It creates a new file name that visually appears to have a different extension, while retaining the original .exe extension.

.PARAMETER OriginalFilePath
Specifies the full path to the original .exe file that needs to be renamed.

.PARAMETER SpoofExtension
Specifies the fake extension to use for spoofing. Valid options are 'pdf', 'png', 'jpeg', and 'txt'.

.PARAMETER ReplaceOriginal
When specified, the original file will be replaced with the renamed file. If not specified, the script will create a new file with the spoofed name, keeping the original file intact.

.REQUIREMENTS
Requires PowerShell 5.0 or later.

.LICENSE
This script is licensed under the GNU Affero General Public License v3.0. Please see the [LICENSE] file on the GitHub repository (https://github.com/franckferman/Memento/blob/main/LICENSE) for the full license details.

.NOTES
Author: Franck Ferman
Version: 1.0.0
This script is part of the Memento project.

.LINK
Project Repository: https://github.com/franckferman/Memento

.EXAMPLE
.\Memento.ps1 -OriginalFilePath ".\path\to\originalfile.exe" -SpoofExtension "pdf"
Description: Renames the file 'originalfile.exe' to appear as a PDF file. The renamed file will be created in the same directory as the original file.

.EXAMPLE
.\Memento.ps1 -OriginalFilePath ".\path\to\originalfile.exe" -SpoofExtension "png" -ReplaceOriginal
Description: Renames and replaces 'originalfile.exe' to appear as a PNG image file.
#>

param(
    [string]$OriginalFilePath,
    [ValidateSet("pdf", "png", "jpeg", "txt")]
    [string]$SpoofExtension,
    [switch]$ReplaceOriginal
)

$BANNER = @"
                                               ___
                                              /   `\
                                              \ // \
  __  __                          _            \  //\ 
 |  \/  | ___ _ __ __   ___ _ __ | |_ ____      \___/ 
 | |\/| |/ _ \ '_ ` _ \ / _ \ '_ \| __/  _ \       |\  
 | |  | |  __/ | | | | |  __/ | | | || (_) |      | \ 
 |_|  |_|\___|_| |_| |_|\___|_| |_|\__\___/       \__|

"@

function Show-Banner {
    Write-Host $BANNER
}

function Show-Help {
    Show-Banner
    Write-Host "Memento - File Renaming Tool using RLO Character for Extension Spoofing"
    Write-Host "============================================================="
    Write-Host "This script renames a .exe file using Right-to-Left Override (RLO)"
    Write-Host "character to visually spoof the file extension."
    Write-Host ""
    Write-Host "Usage:"
    Write-Host "  .\Memento.ps1 -OriginalFilePath <path> [-ReplaceOriginal]"
    Write-Host ""
    Write-Host "Parameters:"
    Write-Host "  -OriginalFilePath    Specifies the full path to the original .exe file."
    Write-Host "  -ReplaceOriginal     Replaces the original file with the renamed file."
    Write-Host "                       If not specified, a new file is created."
    Write-Host ""
    Write-Host "Examples:"
    Write-Host "  .\Memento.ps1 -OriginalFilePath '.\path\to\originalfile.exe' -SpoofExtension 'pdf'"
    Write-Host "  Renames the file 'originalfile.exe' to appear as a PDF file. The renamed file will be created in the same directory as the original file."
    Write-Host ""
    Write-Host "  .\Memento.ps1 -OriginalFilePath '.\path\to\originalfile.exe' -SpoofExtension 'pdf' -ReplaceOriginal"
    Write-Host "  Renames and replaces 'originalfile.exe' to appear as a PNG image file."
    Write-Host ""
}

function Get-NewFileName {
    param(
        [string]$BaseWord,
        [string]$SpoofExtension
    )

    $BaseName = $BaseWord.Substring(0, $BaseWord.Length - 3)
    $RLO = [char]0x202E
    $ReverseFakeExtension = -join ($SpoofExtension.ToCharArray())[-1..-($SpoofExtension.Length)]
    return $BaseName + $RLO + $ReverseFakeExtension + ".exe"
}

$PossibleBaseWords = @("Sexe", "Vexe")

if (-not $PSBoundParameters.ContainsKey('OriginalFilePath') -or -not $PSBoundParameters.ContainsKey('SpoofExtension')) {
    Show-Help
    exit
}

if (-not $PSBoundParameters.ContainsKey('OriginalFilePath')) {
    Write-Host "Error: Original file path is required."
    exit
}

if ([System.IO.Path]::GetExtension($OriginalFilePath) -ne ".exe") {
    Write-Host "Error: Only .exe files are accepted."
    exit
}

$RandomBaseWord = Get-Random -InputObject $PossibleBaseWords
$NewFileName = Get-NewFileName -BaseWord $RandomBaseWord -SpoofExtension $SpoofExtension

if ($ReplaceOriginal) {
    Show-Banner
    Rename-Item -Path $OriginalFilePath -NewName $NewFileName
    Write-Host "File $OriginalFilePath replaced with $RandomBaseWord.$SpoofExtension"
    Write-Host ""
} else {
    Show-Banner
    $NewFilePath = [System.IO.Path]::Combine([System.IO.Path]::GetDirectoryName($RandomBaseWord), $NewFileName)
    Copy-Item -Path $OriginalFilePath -Destination $NewFilePath
    Write-Host "File $OriginalFilePath copied to $RandomBaseWord.$SpoofExtension"
    Write-Host ""
}
