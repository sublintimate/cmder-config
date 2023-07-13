# Use this file to run your own startup commands

## Prompt Customization
<#
.SYNTAX
    {PrePrompt}{CMDER DEFAULT}
    PS>{PostPrompt} {repl input}
.EXAMPLE
    {PrePrompt}N:\Documents\src\cmder [master]
    PS>{PostPrompt} |
#>

. "${env:ConEmuDir}\..\cmder-powershell-powerline-prompt\user-profile.ps1"

$newLineSymbol = "`n"
$segment = @{
    isNeeded = $true;
    text = "";
    textColor = "White";
    fillColor = "Magenta";
}

function init() {
    $prefix = if ($segment.isNeeded) { $newLineSymbol } else { "" }
    $user = ${env:USERNAME}
    $hostname = ${env:COMPUTERNAME}

    $segment.text = "${prefix} ${user}@${hostname} "
    $segment.isNeeded = $true
}

[ScriptBlock]$PrePrompt = {
    $Host.UI.RawUI.ForegroundColor = "White"
    Write-Host -NoNewline "$([char]0x200B)"
    init
    Microsoft.PowerShell.Utility\Write-Host $segment.text -NoNewLine -BackgroundColor $segment.fillColor -ForegroundColor $segment.textColor
    # Close PrePrompt
    Microsoft.PowerShell.Utility\Write-Host $arrowSymbol -NoNewLine -BackgroundColor $pathBackColor -ForegroundColor $segment.fillColor
}

# Replace the cmder prompt entirely with this.
[ScriptBlock]$CmderPrompt = {
    $tp = tildaPath($pwd.ProviderPath)
    # Microsoft.PowerShell.Utility\Write-Host "`n" $tp " " -NoNewLine -BackgroundColor $pathBackColor -ForegroundColor $pathForeColor
    Microsoft.PowerShell.Utility\Write-Host " ${tp} "  -NoNewLine -BackgroundColor $pathBackColor -ForegroundColor $pathForeColor

    getGitStatus($pwd.ProviderPath)
    Microsoft.PowerShell.Utility\Write-Host "${newLineSymbol}PS>" -NoNewLine -ForegroundColor "DarkGray"
}

[ScriptBlock]$PostPrompt = {

}

## <Continue to add your own>

# Set-PSReadlineOption -HistoryNoDuplicates
Set-PSReadlineOption -AddToHistoryHandler {
    param ($command)

    switch -regex ($command) {
        <#case#> "^\s.*"   { return $false }
        <#case#> "^[a-z]$" { return $false }
        <#case#> "exit"    { return $false }
    }
    return $true
}
