# NOTE: This resource requires WMF5 and PsDscRunAsCredential
$currentPath = Split-Path -Parent $MyInvocation.MyCommand.Path
Write-Verbose -Message "CurrentPath: $currentPath"

# Load Common Code
Import-Module $currentPath\..\..\xHyperVHelper.psm1 -Verbose:$false -ErrorAction Stop

function Get-TargetResource
{
	[CmdletBinding()]
	[OutputType([System.Collections.Hashtable])]
	param
	(
		[parameter(Mandatory = $true)]
		[System.String]
		$Name,

		[parameter(Mandatory = $true)]
		[System.Byte]
		$Maximum
	)

    $Maximum = (Get-VMProcessor -VMName $Name).Maximum

	$returnValue = @{
		Name = $Name
        Maximum = $Maximum
	}

	$returnValue
}


function Set-TargetResource
{
	[CmdletBinding()]
	param
	(
		[parameter(Mandatory = $true)]
		[System.String]
		$Name,

		[parameter(Mandatory = $true)]
		[System.Byte]
		$Maximum
	)

    Set-VMProcessor -VMName $Name -Maximum $Maximum

    if(-not(Test-TargetResource @PSBoundParameters))
    {
        throw New-TerminatingError -ErrorType TestFailedAfterSet -ErrorCategory InvalidResult
    }
}


function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
	param
	(
		[parameter(Mandatory = $true)]
		[System.String]
		$Name,

		[parameter(Mandatory = $true)]
		[System.Byte]
		$Maximum
	)

    $result = ((Get-TargetResource @PSBoundParameters).Maximum -eq $Maximum)
	
	$result
}

Export-ModuleMember -Function *-TargetResource
