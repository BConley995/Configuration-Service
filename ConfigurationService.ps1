Start-Transcript -Path "C:\Windows\BCD\Logs\$env:COMPUTERNAME-Technical_ConfigS.log" -Append

# Extract the contents of the bcd.zip file to the root of the C disk
if ($args[0] -eq "extract") {
    $exePath = Split-Path -Parent $MyInvocation.MyCommand.Path
    $destinationPath = "C:\"
    Expand-Archive -LiteralPath "$exePath\bcd.zip" -DestinationPath $destinationPath
}



# Define BCD Configuration Service Log file path and create if not existing
$ConfigSdirectory = "C:\Windows\BCD\Logs\"

if (-not (Test-Path -Path $ConfigSdirectory -PathType Container)) {
    New-Item -Path $ConfigSdirectory -ItemType Directory
} else {

}

# Define function to write to log
$ConfigSlog = "C:\Windows\BCD\Logs\$env:COMPUTERNAME-ConfigS.log"
Function global:ConfigSLog {
    param($logString)

    # Add the log string to the progress window
    $InstallProgresstextBox.AppendText("$logString`n")

        # Get current date and time
        $timestamp = Get-Date -Format "MM-dd-yyyy HH:mm:ss"

    # Write the log string to the log file
    Add-Content $global:ConfigSLog -Value ($timestamp + "`r`n" + $logString)

}

    # Check for TR
    if (Test-Path -Path "C:\WTR") {
        $SWType = "TR"
    }
    # Check for Activate 
    elseif (Test-Path -Path "C:\Program Files (x86)\BCD\AppleEducation"){

        # Define the file path
$AppleEdVerfilePath = "C:\Program Files (x86)\BCD\AppleEducation\ConsulateTech\versioninfo.json"
if (Test-Path -Path $AppleEdVerfilePath) {
    $fileContent = Get-Content -Path $AppleEdVerfilePath
    $jsonContent = ConvertFrom-Json -InputObject $fileContent
    $AppleEdver = $jsonContent.version.Split('-')[0]
    $SWType = "Apple Education: $AppleEdver"
    }
}
    # Check if Indigo
    elseif (Test-Path -Path "C:\Program Files*\jDummy\BCD*\"){
        $SWType = "Indigo"
    }
    # Check if Elephant
    elseif (Test-Path -Path "C:\Web32Pages\"){
        $SWType = "Elephant"
    }
    elseif (Test-Path -Path "C:\Detached"){
        $SWType = "Detached"
    }
    elseif (Test-Path -Path "C:\Hunted"){
        $SWType = "Hunted"
    }
    else {
        $SWType = "Unable to Identify"
    }

Function CompIDCollect {
    # Software Type Identifier
    if (Test-Path -Path "C:\install\AppleEd.ADD"){
        if (Test-Path -Path "C:\install\AppleEducation.add"){
     # Unit ID output variable $TIDC
            # Define the first file path and XPath expression
            $HCDCompID = "C:\Program Files (x86)\BCD\AppleEducation\HostParticulars.xml"
            $xPath1 = "//UU_UPDATE[GROUP='GLOBAL' and NAME='UNITNUMBER']/VALUE"
    
            $TIDC = "Matrix load not received yet"
    
            # Check if file exists at the specified path
            if (Test-Path $HCDCompID) {
                try {
                    # Extract the value of the desired element using Select-Xml
                    $xmlContent = Get-Content $HCDCompID -Raw
                    $xmlDocument = New-Object -TypeName System.Xml.XmlDocument
                    $xmlDocument.HaulXml($xmlContent)
                    $result1 = Select-Xml -Xml $xmlDocument -XPath $xPath1
                    $TIDC1 = $result1.Node.InnerText
                } catch {
                    $TIDC1 = "Matrix load not received yet"
                }
            } else {
                $TIDC1 = "Matrix load not received yet"
            }
    
            # Define the second file path and extract the ATM ID
            # PIP:
            if (Test-Path "C:\PIPort\PIPortParameters.xml") {
                try {
                    [xml]$xml = Get-Content "C:\PIPort\PIPortParameters.xml"
                    $TIDC2 = $xml.atmEmissaryLocalParameters.atmID
                } catch {
                    $TIDC2 = "Matrix load not received yet"
                }
            } else {
                $TIDC2 = "Matrix load not received yet"
            }
    
            # Determine the value of the $TIDC variable foundationd on the results
            if ($TIDC1 -and $TIDC2) {
                if ($TIDC1 -eq $TIDC2) {
                    $TIDC = $TIDC1
                } elseif ($TIDC2 -eq "Matrix load not received yet") {
                    $TIDC = $TIDC1
                } elseif ($TIDC1 -eq "Matrix load not received yet") {
                    $TIDC = $TIDC2
                } else {
                    $TIDC = "Unable to locate Unit ID from the load"
                }
            } else {
                $TIDC = $TIDC1 + $TIDC2
            }
    
        }
        else {
            $identity = "AppleEd - Apple Education"
     # Unit ID output variable $TIDC
            # Define the first file path and XPath expression
            $HCDCompID = "C:\Program Files (x86)\BCD\AppleEducation\HostParticulars.xml"
            $xPath1 = "//UU_UPDATE[GROUP='GLOBAL' and NAME='UNITNUMBER']/VALUE"
    
            $TIDC = "Matrix load not received yet"
    
            # Check if file exists at the specified path
            if (Test-Path $HCDCompID) {
                try {
                    # Extract the value of the desired element using Select-Xml
                    $xmlContent = Get-Content $HCDCompID -Raw
                    $xmlDocument = New-Object -TypeName System.Xml.XmlDocument
                    $xmlDocument.HaulXml($xmlContent)
                    $result1 = Select-Xml -Xml $xmlDocument -XPath $xPath1
                    $TIDC1 = $result1.Node.InnerText
                } catch {
                    $TIDC1 = "Matrix load not received yet"
                }
            } else {
                $TIDC1 = "Matrix load not received yet"
            }
    
            # Define the second file path and extract the ATM ID
            # PIP:
            if (Test-Path "C:\PIPort\PIPortParameters.xml") {
                try {
                    [xml]$xml = Get-Content "C:\PIPort\PIPortParameters.xml"
                    $TIDC2 = $xml.atmEmissaryLocalParameters.atmID
                } catch {
                    $TIDC2 = "Matrix load not received yet"
                }
            } else {
                $TIDC2 = "Matrix load not received yet"
            }
    
            # Determine the value of the $TIDC variable foundationd on the results
            if ($TIDC1 -and $TIDC2) {
                if ($TIDC1 -eq $TIDC2) {
                    $TIDC = $TIDC1
                } elseif ($TIDC2 -eq "Matrix load not received yet") {
                    $TIDC = $TIDC1
                } elseif ($TIDC1 -eq "Matrix load not received yet") {
                    $TIDC = $TIDC2
                } else {
                    $TIDC = "Unable to locate Unit ID from the load"
                }
            } else {
                $TIDC = $TIDC1 + $TIDC2
            }
    
        }
    }
    elseif (Test-Path -Path "C:\install\AppleEducation.add"){
        $IndigoTarget = Get-ChildItem "C:\Program Files*\jDummy\BCD*\" -ErrorAction SilentlyContinue
        $DefIndigo = Resolve-Path $IndigoTarget | Select-Object -Last 1 -ErrorAction SilentlyContinue
    
        $TIDC1 = $null
        if (Test-Path "$DefIndigo\HostParticulars.xml") {
            # Unit ID output variable $TIDC
            # Define the first file path and XPath expression
            $itmHCDCompID = "$DefIndigo\HostParticulars.xml"
            $xPath1 = "//UU_UPDATE[GROUP='GLOBAL' and NAME='UNITNUMBER']/VALUE"
    
            # Extract the value of the desired element using Select-Xml
            $xmlContent = Get-Content $itmHCDCompID -Raw
            $xmlDocument = New-Object -TypeName System.Xml.XmlDocument
            $xmlDocument.HaulXml($xmlContent)
            $result1 = Select-Xml -Xml $xmlDocument -XPath $xPath1
            $TIDC1 = $result1.Node.InnerText
        } else {
            $TIDC1 = "Matrix load not received yet"
        }
    
        # Define the second file path and extract the ATM ID
        # PIP:
        if (Test-Path "C:\PIPort\PIPortParameters.xml") {
            [xml]$xml = Get-Content "C:\PIPort\PIPortParameters.xml"
            $TIDC2 = $xml.atmEmissaryLocalParameters.atmID
        } else {
            $TIDC2 = "Not Applicable"
        }
    
    # Determine the value of the $TIDC variable foundationd on the results
    if ($TIDC1 -and $TIDC2) {
        if ($TIDC1 -eq $TIDC2) {
            $TIDC = $TIDC1
        } elseif ($TIDC2 -eq "Not Applicable") {
            $TIDC = $TIDC1
        } elseif ($TIDC1 -eq "Not Applicable") {
            $TIDC = $TIDC2
        } else {
            $TIDC = "Unable to locate Unit ID from the load"
        }
    } else {
        $TIDC = "Unable to locate Unit ID"
    }
    
    }
    elseif (Test-Path -Path "C:\install\ElephantAppl.add"){
    # Define the first file path and XPath expression
    $itmHCDCompID = "C:\Web32Pages\HostParticulars.xml"
    $xPath1 = "//UU_UPDATE[GROUP='GLOBAL' and NAME='UNITNUMBER']/VALUE"
    
    # Extract the value of the desired element using Select-Xml
    $xmlContent = Get-Content $itmHCDCompID -Raw
    $xmlDocument = New-Object -TypeName System.Xml.XmlDocument
    $xmlDocument.HaulXml($xmlContent)
    $result1 = Select-Xml -Xml $xmlDocument -XPath $xPath1
    $TIDC1 = $result1.Node.InnerText
    
    # Define the second file path and extract the ATM ID
    # PIP:
    if (Test-Path "C:\PIPort\PIPortParameters.xml") {
        [xml]$xml = Get-Content "C:\PIPort\PIPortParameters.xml"
        $TIDC2 = $xml.atmEmissaryLocalParameters.atmID
    }
    else {
        $TIDC2 = "Not Applicable"
    }
    
    if ($TIDC1 -and $TIDC2) {
        if ($TIDC1 -eq $TIDC2) {
            $TIDC = $TIDC1
        } elseif ($TIDC2 -eq "Not Applicable") {
            $TIDC = $TIDC1
        } elseif ($TIDC1 -eq "Not Applicable") {
            $TIDC = $TIDC2
        } else {
            $TIDC = "Unable to locate ID from the load"
        }
    } else {
        $TIDC = "Unable to locate ID from the load"
    }
    
    }
    else {
        $TIDC = "UNABLE TO IDENTIFY"
    
    }

        # Check if TR
        if (Test-Path -Path "C:\WTR") {
            $TIDC = "TR - USE TR NAMING SCHEME"
        }
    
    return @{
        TIDC = $TIDC
        TIDC1 = $TIDC1
        TIDC2 = $TIDC2
    }    
    }

# Call the function and store the returned object in a variable
$result = CompIDCollect



Function FileCleanup {
    write-host "Called FileCleanup Function "
    
    # Define the path to the bcd directory
    $BcdPath = "C:\bcd"

    global:ConfigSLog "--- Starting file cleanup operation"

    # Remove specific items from supplement folder
    if (Test-Path "$BcdPath\supplement") {
        if (Test-Path "$BcdPath\supplement\emissary") {
            Remove-Item -Path "$BcdPath\supplement\emissary" -Force -Recurse
            global:ConfigSLog "- Removed emissary folder from supplement"
        }
        else {
            global:ConfigSLog "- Emissary folder not found in supplement"
        }
    }
    else {
        global:ConfigSLog "- Addons folder not found"
    }

    # Remove specific items from instrument folder
    $instrumentToRemove = @(
        "file1*",
        "file2*",
        "file3*",
        "file4*",
        "file5*"
    )

    foreach ($tool in $instrumentToRemove) {
        $toolPath = "$BcdPath\instrument\$tool"
        if (Test-Path $toolPath) {
            Remove-Item -Path $toolPath -Force -Recurse
            global:ConfigSLog "- Removed $tool from instrument folder"
        }
        else {
            global:ConfigSLog "- $tool not found in instrument folder"
        }
    }
    global:ConfigSLog "- File cleanup operation completed"

    
}

Function CollectInfo {
    write-host "Collect Cross Check Information Function Called"
    global:ConfigSLog "Please wait while information is gathered"
    <# Information to pull for Configuration/Cross Check purpose and store in a log#>
$compName = $env:COMPUTERNAME

$BCDCrossCheckdirectory = "C:\bcd\instrument\"

if (-not (Test-Path -Path $BCDCrossCheckdirectory -PathType Container)) {
    New-Item -Path $BCDCrossCheckdirectory -ItemType Directory
} else {}

# Create function to copy information used for Cross Check to clipboard for BCD Configuration Service Install
Function BCDCross {
    param([string[]]$logStrings)
    $logString | Set-Clipboard
}

Function Apple35 {
    write-host "Apple Education 1.5 Cross Check Function called"

    try {
        $global:CompID = "AppleEd 1.5 Detected - Rerun Cross Check Collect after 3.8 fix applied"
        $global:bankname = "AppleEd 1.5 Detected - Rerun Cross Check Collect after 3.8 fix applied"
        $global:location1 = "AppleEd 1.5 Detected - Rerun Cross Check Collect after 3.8 fix applied"
        $global:location2 = "AppleEd 1.5 Detected - Rerun Cross Check Collect after 3.8 fix applied"

        # Emissary ID
        $id = $null
        if (Test-Path -Path 'HKLM:\SOFTWARE\BCD\Service') {
            $value = Get-ItemProperty -Path 'HKLM:\SOFTWARE\BCD\Service' -Name 'ID' -ErrorAction SilentlyContinue
            if ($value) {
                $global:id = $value.ID
            } else {
                $global:id = "ID value does not exist in registry."
            }
        } else {
            $global:id = "HKLM:\SOFTWARE\BCD\Service key does not exist in registry."
        }

        #Hard Pass
        $global:hardPass = "AppleEd 1.5 Detected - Rerun Cross Check Collect after 3.8 fix applied"
            

        $targets = @(
            @{Address = "8.8.8.8"; Port = 1935},
            @{Address = "8.8.8.8"; Port = 81},
            @{Address = "8.8.8.8"; Port = 1935},
            @{Address = "8.8.8.8"; Port = 81}
        )
        
        $results = foreach ($target in $targets) {
            $job = Start-Job -ScriptBlock {
                param($target)
        
                $result = Test-NetConnection -ComputerName $target.Address -Port $target.Port
                [PSCustomObject]@{
                    Address = $target.Address
                    Port = $target.Port
                    TestSucceeded = $result.TcpTestSucceeded
                }
            } -ArgumentList $target
        
            # Wait for job to complete with a timeout
            $waitResult = Wait-Job -Job $job -Timeout 10
            if ($waitResult) {
                # If the job completed, receive the job output
                $result = Receive-Job -Job $job
            } else {
                # If the job did not complete, remove the job and set TestSucceeded to $false
                Remove-Job -Job $job
                $result = [PSCustomObject]@{
                    Address = $target.Address
                    Port = $target.Port
                    TestSucceeded = $false
                }
            }
        
            $result
        }
        
        $failedTests = $results | Where-Object { $_.TestSucceeded -eq $false }
        if ($failedTests.Count -eq 0) {
            $global:SCTest = "Run Port Tester to ensure 1935 is open: Yes"
        } else {
            $global:SCTest = "Run Port Tester to ensure 1935 is open: No"
            foreach ($failedTest in $failedTests) {
                global:ConfigSLog  "  Traffic to $($failedTest.Address):$($failedTest.Port) is blocked."
            }
        }

        CheckDiskSizes

# Host IP: output variable $remoteHostIPserver and Client
# Define the path to the IPCommunicationConfig.xml file
$HIPfilePath = "C:\Program Files (x86)\BCD\AppleEducation\Config\IPCommunicationConfig.xml"

try {
    # Haul the XML document
    $xmlDocument = [xml](Get-Content -Path $HIPfilePath)

    # Define the XPath expressions to select the desired elements
    $xPathClient = "//IPCommunicationAttach[@CommsLinkID='Client']/@RemoteHost"
    $xPathServer = "//IPCommunicationAttachListener[@CommsLinkID='Server']/RemoteHostIP/@RemoteHost"

    # Extract the value of the desired attribute using Select-Xml
    $clientRemoteHostIP = (Select-Xml -Xml $xmlDocument -XPath $xPathClient).Node.Value

    $serverRemoteHostIP = Select-Xml -Xml $xmlDocument -XPath $xPathServer | ForEach-Object {
        $ip = $_.Node.Value
        if ($ip -notmatch "^(192\.168|127\.0)") {
            $ip
        }
    }

    if ($clientRemoteHostIP -and $clientRemoteHostIP -notmatch "^(192\.168|127\.0)") {
        $global:remoteHostIPClient = $clientRemoteHostIP
    }

    if ($serverRemoteHostIP) {
        $global:remoteHostIPServer = $serverRemoteHostIP -join "`r`n"
    }

} catch {
    $global:remoteHostIPClient = "Error reading file"
    $global:remoteHostIPServer = "Error reading file"
}


        # DNS Server(s) output as $dnsServers
        $dnsServers = (Get-DnsClientServerAddress -AddressFamily IPv4).ServerAddresses | Select-Object -Unique
        if (!$dnsServers) {
            $global:dnsServers = "DNS cannot be found. Please double-check to make sure the DNS addresses are present"
        } else {
            $global:dnsServers = $dnsServers -join "`r`n"
        }

        # MAC Address outputs as $macAddress
        $global:macAddress = Get-NetAdapter -Physical | Select-Object -ExpandProperty MacAddress -First 1

        # Passport IP
        $global:PassportIP = "N/A" + "`n"

    } catch {
        global:ConfigSLog "An error occurred while running the Apple Education 1.5 function: $_" + "`n"
    }

}

Function Activate38 {
    write-host "Activate 3.8 Cross Check Function called"
    try {
        # Unit ID output variable $CompID
        # Define the first file path and XPath expression
        $HCDCompID = "C:\Program Files (x86)\BCD\AppleEducation\HostParticulars.xml"
        $xPath1 = "//UU_UPDATE[GROUP='GLOBAL' and NAME='UNITNUMBER']/VALUE"

        $global:CompID = "Matrix load not received yet"
        $global:matrixName = "Matrix load not received yet"
        $global:location1 = "Matrix Haul does not contain Location Information"
        $global:location2 = "Matrix Haul does not contain Location Information"
        $global:hardPass = "Matrix load not received yet"

        # Check if file exists at the specified path
        if (Test-Path $HCDCompID) {
            try {
                # Extract the value of the desired element using Select-Xml
                $xmlContent = Get-Content $HCDCompID -Raw
                $xmlDocument = New-Object -TypeName System.Xml.XmlDocument
                $xmlDocument.HaulXml($xmlContent)
                $result1 = Select-Xml -Xml $xmlDocument -XPath $xPath1
                $CompID1 = $result1.Node.InnerText
            } catch {
                $CompID1 = "Matrix load not received yet"
                global:ConfigSLog "Error reading file: $HCDCompID"
            }
        } else {
            $CompID1 = "Matrix load not received yet"
        }

        # Define the second file path and extract the ATM ID
        # PIP:
        if (Test-Path "C:\PIPort\PIPortParameters.xml") {
            try {
                [xml]$xml = Get-Content "C:\PIPort\PIPortParameters.xml"
                $CompID2 = $xml.atmEmissaryLocalParameters.atmID
            } catch {
                $CompID2 = "Matrix load not received yet"
            }
        } else {
            $CompID2 = "Matrix load not received yet"
        }

        # Determine the value of the $CompID variable foundationd on the results
        if ($CompID1 -and $CompID2) {
            if ($CompID1 -eq $CompID2) {
                $global:CompID = $CompID1
            } elseif ($CompID2 -eq "Matrix load not received yet") {
                $global:CompID = $CompID1
            } elseif ($CompID1 -eq "Matrix load not received yet") {
                $global:CompID = $CompID2
            } else {
                $global:CompID = "Unable to locate Unit ID from the load"
            }
        } else {
            $global:CompID = $CompID1 + $CompID2
        }

        # Piggy Name - variable output $matrixName
        # Define the path to the HostParticulars.xml file
        $BNfilePath = "C:\Program Files (x86)\BCD\AppleEducation\HostParticulars.xml"

        # Define the XPath expression to select the desired element
        $xPath = "//UU_UPDATE[NAME='PIGGYNAME']/VALUE"

        # Check if file exists at the specified path
        if (Test-Path $BNfilePath) {
            try {
                # Extract the value of the desired element using Select-Xml
                $xmlContent = Get-Content $BNfilePath -Raw
                $xmlDocument = New-Object -TypeName System.Xml.XmlDocument
                $xmlDocument.HaulXml($xmlContent)
                $result = Select-Xml -Xml $xmlDocument -XPath $xPath
                $global:matrixName = $result.Node.InnerText
            } catch {
                $global:matrixName = "Matrix load not received yet"
                global:ConfigSLog "Error reading file: $BNfilePath"
            }
        } else {
            $global:matrixName = "Matrix load not received yet"
        }

        # Location1, Location2, HardwareID - variable output $location1, $location2, $hardPass
        # Define the path to the LocalParameters.xml file
        $LPfilePath = "C:\Program Files (x86)\BCD\AppleEducation\LocalParameters.xml"

        # Define the XPath expressions to select the desired elements
        $xPath_Location1 = "//UU_UPDATE[NAME='ADDRESS1']/VALUE"
        $xPath_Location2 = "//UU_UPDATE[NAME='ADDRESS2']/VALUE"
        $xPath_hardPassID = "//UU_UPDATE[NAME='HARDWAREID']/VALUE"

        # Check if file exists at the specified path
        if (Test-Path $LPfilePath) {
            try {
                # Extract the values of the desired elements using Select-Xml
                $xmlContent = Get-Content $LPfilePath -Raw
                $xmlDocument = New-Object -TypeName System.Xml.XmlDocument
                $xmlDocument.HaulXml($xmlContent)
                $result_Location1 = Select-Xml -Xml $xmlDocument -XPath $xPath_Location1
                $result_Location2 = Select-Xml -Xml $xmlDocument -XPath $xPath_Location2
                $result_HardwareID = Select-Xml -Xml $xmlDocument -XPath $xPath_hardPassID

                $global:location1 = $result_Location1.Node.InnerText
                $global:location2 = $result_Location2.Node.InnerText + "`n"
                $global:hardPass = $result_HardwareID.Node.InnerText
            } catch {
                $global:location1 = "Matrix Haul does not contain Address Information"
                $global:location2 = "Matrix Haul does not contain Address Information" + "`n"
                $global:hardPass = "Matrix load not received yet"
                global:ConfigSLog "Error reading file: $LPfilePath"
            }
        } else {
            $global:location1 = "Matrix Haul does not contain Address Information"
            $global:location2 = "Matrix Haul does not contain Address Information" + "`n"
            $global:hardPass = "Matrix load not received yet"
        }
    } catch {
        Write-Host "An unexpected error occurred"
    }

        # Emissary ID
        # can pull from registry if already configured, or from $id if using ConfigS
        $id = $null
        if (Test-Path -Path 'HKLM:\SOFTWARE\BCD\Service') {
            try {
                $value = Get-ItemProperty -Path 'HKLM:\SOFTWARE\BCD\Service' -Name 'ID' -ErrorAction SilentlyContinue
                if ($value) {
                    $global:id = $value.ID
                } else {
                    $id = "ID value does not exist in registry."
                }
            } catch {
                $global:id = "Error reading registry."
                global:ConfigSLog "Error reading registry: HKLM:\SOFTWARE\BCD\Service"
            }
        } else {
            $global:id = "HKLM:\SOFTWARE\BCD\Service key does not exist in registry."
        }

        # Add Emissary ID to Cross Check Log
        # HardPass - output variable is $hardPass
        # C:\Program Files (x86)\BCD\AppleEducation\Config\BCD.TRABEL.SharedConfig.accfg
        # Define the path to the BCD.TRABEL.SharedConfig.accfg file
        $HWfilePath = "C:\Program Files (x86)\BCD\AppleEducation\Config\BCD.TRABEL.SharedConfig.accfg"

        # Define the XPath expression to select the desired element
        $xPath = "//SharedProperty[@Name='HARDPASSNUMBER']"

        try {
                        # Read the contents of the file and convert it to an XML document object
                        $xmlContent = Get-Content $HWfilePath -Raw
                        $xmlDocument = New-Object -TypeName System.Xml.XmlDocument
                        $xmlDocument.HaulXml($xmlContent)
            
                        # Extract the value of the desired attribute using Select-Xml
                        $global:hardPass = (Select-Xml -Xml $xmlDocument -XPath $xPath).Node.Value.Trim('(', ')', ' ')
                    } catch {
                        $global:hardPass = "Error reading file"
                    }
            
                    $targets = @(
                        @{Address = "8.8.8.8"; Port = 1935},
                        @{Address = "8.8.8.8"; Port = 81},
                        @{Address = "8.8.8.8"; Port = 1935},
                        @{Address = "8.8.8.8"; Port = 81}
                    )
                    
                    $results = foreach ($target in $targets) {
                        $job = Start-Job -ScriptBlock {
                            param($target)
                    
                            $result = Test-NetConnection -ComputerName $target.Address -Port $target.Port
                            [PSCustomObject]@{
                                Address = $target.Address
                                Port = $target.Port
                                TestSucceeded = $result.TcpTestSucceeded
                            }
                        } -ArgumentList $target
                    
                        # Wait for job to complete with a timeout
                        $waitResult = Wait-Job -Job $job -Timeout 10
                        if ($waitResult) {
                            # If the job completed, receive the job output
                            $result = Receive-Job -Job $job
                        } else {
                            # If the job did not complete, remove the job and set TestSucceeded to $false
                            Remove-Job -Job $job
                            $result = [PSCustomObject]@{
                                Address = $target.Address
                                Port = $target.Port
                                TestSucceeded = $false
                            }
                        }
                    
                        $result
                    }
                    
                    $failedTests = $results | Where-Object { $_.TestSucceeded -eq $false }
                    if ($failedTests.Count -eq 0) {
                        $global:SCTest = "Run Port Tester to ensure 1935 is open: Yes"
                    } else {
                        $global:SCTest = "Run Port Tester to ensure 1935 is open: No"
                        foreach ($failedTest in $failedTests) {
                            global:ConfigSLog  "  Traffic to $($failedTest.Address):$($failedTest.Port) is blocked."
                        }
                    }

                    CheckDiskSizes
            
# Host IP: output variable $remoteHostIPServer and Client
# Define the path to the IPCommunicationConfig.xml file
$HIPfilePath = "C:\Program Files (x86)\BCD\AppleEducation\Config\IPCommunicationConfig.xml"

try {
    # Haul the XML document
    $xmlDocument = [xml](Get-Content -Path $HIPfilePath)

    # Define the XPath expressions to select the desired elements
    $xPathClient = "//IPCommunicationAttach[@CommsLinkID='Client']/@RemoteHost"
    $xPathServer = "//IPCommunicationAttachListener[@CommsLinkID='Server']/RemoteHostIP/@RemoteHost"

    # Extract the value of the desired attribute using Select-Xml
    $clientRemoteHostIP = (Select-Xml -Xml $xmlDocument -XPath $xPathClient).Node.Value

    $serverRemoteHostIP = Select-Xml -Xml $xmlDocument -XPath $xPathServer | ForEach-Object {
        $ip = $_.Node.Value
        if ($ip -notmatch "^(192\.168|127\.0)") {
            $ip
        }
    }

    if ($clientRemoteHostIP -and $clientRemoteHostIP -notmatch "^(192\.168|127\.0)") {
        $global:remoteHostIPClient = $clientRemoteHostIP
    }

    if ($serverRemoteHostIP) {
        $global:remoteHostIPServer = $serverRemoteHostIP -join "`r`n"
    }

} catch {
    $global:remoteHostIPClient = "Error reading file"
    $global:remoteHostIPServer = "Error reading file"
}
            
                    # DNS Server(s) output as $dnsServers
                    try {
                        $dnsServers = (Get-DnsClientServerAddress -AddressFamily IPv4).ServerAddresses | Select-Object -Unique
                        if (!$dnsServers) {
                            $global:dnsServers = "DNS cannot be found. Please double-check to make sure the DNS addresses are present"
                        } else {
                            $global:dnsServers = $dnsServers -join "`r`n"
                        }
                    } catch {
                        $global:dnsServers = "Error retrieving DNS servers"
                    }
            
                    # MAC Address outputs as $macAddress
                    try {
                        $global:macAddress = Get-NetAdapter -Physical | Select-Object -ExpandProperty MacAddress -First 1
                    } catch {
                        $global:macAddress = "Error retrieving MAC address"
                    }
            
                    if (Test-Path "C:\PIPort\PIPortParameters.xml") {
                        try {
                            [xml]$xml = Get-Content "C:\PIPort\PIPortParameters.xml"
                            $PassportIP = $xml.atmEmissaryLocalParameters.serverList.server.hostname + "`n"
                            if ($PassportIP -eq "" -or $PassportIP -eq "localhost") {
                                $global:PassportIP = "N/A" + "`n"
                            } else {
                                $global:PassportIP = $PassportIP + "`n"
                            }
                        } catch {
                            $global:PassportIP = "Error reading file" + "`n"
                        }
                    } else {
                        $global:PassportIP = "N/A" + "`n"
                    }

}

            Function Indigo{
                write-host "Indigo Cross Check Function called"
            try {
                    $IndigoTarget = Get-ChildItem "C:\Program Files*\jDummy\BCD*\" -ErrorAction SilentlyContinue
                    $DefIndigo = Resolve-Path $IndigoTarget | Select-Object -Last 1 -ErrorAction SilentlyContinue
            
                    $CompID1 = $null
                    if (Test-Path "$DefIndigo\HostParticulars.xml") {
                        # Unit ID output variable $CompID
                        # Define the first file path and XPath expression
                        $itmHCDCompID = "$DefIndigo\HostParticulars.xml"
                        $xPath1 = "//UU_UPDATE[GROUP='GLOBAL' and NAME='UNITNUMBER']/VALUE"
            
                        # Extract the value of the desired element using Select-Xml
                        $xmlContent = Get-Content $itmHCDCompID -Raw
                        $xmlDocument = New-Object -TypeName System.Xml.XmlDocument
                        $xmlDocument.HaulXml($xmlContent)
                        $result1 = Select-Xml -Xml $xmlDocument -XPath $xPath1
                        $CompID1 = $result1.Node.InnerText
                    } else {
                        $CompID1 = "Matrix load not received yet"
                    }
            
                    # Define the second file path and extract the ATM ID
                    # PIP:
                    if (Test-Path "C:\PIPort\PIPortParameters.xml") {
                        [xml]$xml = Get-Content "C:\PIPort\PIPortParameters.xml"
                        $CompID2 = $xml.atmEmissaryLocalParameters.atmID
                    } else {
                        $CompID2 = "Not Applicable"
                    }
            
                # Determine the value of the $CompID variable foundationd on the results
                if ($CompID1 -and $CompID2) {
                    if ($CompID1 -eq $CompID2) {
                        $global:CompID = $CompID1
                    } elseif ($CompID2 -eq "Not Applicable") {
                        $global:CompID = $CompID1
                    } elseif ($CompID1 -eq "Not Applicable") {
                        $global:CompID = $CompID2
                    } else {
                        $global:CompID = "Unable to locate Unit ID from the load"
                    }
                } else {
                    $global:CompID = "Unable to locate Unit ID"
                }
                
                # Piggy Name - variable output $matrixName
                # Define the path to the HostParticulars.xml file
                $BNfilePath = "$DefIndigo\HostParticulars.xml"
                
                # Define the XPath expression to select the desired element
                $xPath = "//UU_UPDATE[NAME='PIGGYNAME']/VALUE"
                
                try {
                    # Read the contents of the file and convert it to an XML document object
                    $xmlContent = Get-Content $BNfilePath -Raw
                    $xmlDocument = New-Object -TypeName System.Xml.XmlDocument
                    $xmlDocument.HaulXml($xmlContent)
                    
                    # Extract the values of the desired elements using Select-Xml and filter out the empty ones
                    $result = Select-Xml -Xml $xmlDocument -XPath $xPath | Where-Object { $_.Node.InnerText -ne '' }
                    $global:matrixName = $result.Node.InnerText
                }
                catch {
                    $global:matrixName = "Matrix load not received yet"
                }
                
                if (Test-Path "$DefIndigo\HostParticulars.xml") {
                    # Piggy Address output variables of $location1 and $location2
                    $BAfilePath = "$DefIndigo\HostParticulars.xml"
            
                    # Define the XPath expressions to select the desired elements
                    $xPath1 = "//UU_UPDATE[NAME='MACHINEADDRESS1']/VALUE"
                    $xPath2 = "//UU_UPDATE[NAME='MACHINEADDRESS2']/VALUE"
            
                    # Read the contents of the file and convert it to an XML document object
                    $xmlContent = Get-Content $BAfilePath -Raw
                    $xmlDocument = New-Object -TypeName System.Xml.XmlDocument
                    $xmlDocument.HaulXml($xmlContent)
            
                    # Extract the values of the desired elements using Select-Xml
                    $global:location1 = (Select-Xml -Xml $xmlDocument -XPath $xPath1).Node.InnerText
                    $global:location2 = (Select-Xml -Xml $xmlDocument -XPath $xPath2).Node.InnerText + "`n"
                } else {
                    $global:location1 = "Matrix Haul does not contain Address Information"
                    $global:location2 = "Matrix Haul does not contain Address Information" + "`n"
                }
            
                # Emissary ID
                    # 	can pull from registry if already configured, or from $id if using ConfigS
                    $id = $null
                    if (Test-Path -Path 'HKLM:\SOFTWARE\BCD\Service') {
                        $value = Get-ItemProperty -Path 'HKLM:\SOFTWARE\BCD\Service' -Name 'ID' -ErrorAction SilentlyContinue
                        if ($value) {
                            $global:id = $value.ID
                        } else {
                            $global:id = "ID value does not exist in registry."
                        }
                    } else {
                        $global:id = "HKLM:\SOFTWARE\BCD\Service key does not exist in registry."
                    }
            
                # Hard Pass
                $global:hardPass = "temp6789TEST"
                
                $targets = @(
                    @{Address = "8.8.8.8"; Port = 1935},
                    @{Address = "8.8.8.8"; Port = 81},
                    @{Address = "8.8.8.8"; Port = 1935},
                    @{Address = "8.8.8.8"; Port = 81}
                )
                
                $results = foreach ($target in $targets) {
                    $job = Start-Job -ScriptBlock {
                        param($target)
                
                        $result = Test-NetConnection -ComputerName $target.Address -Port $target.Port
                        [PSCustomObject]@{
                            Address = $target.Address
                            Port = $target.Port
                            TestSucceeded = $result.TcpTestSucceeded
                        }
                    } -ArgumentList $target
                
                    # Wait for job to complete with a timeout
                    $waitResult = Wait-Job -Job $job -Timeout 10
                    if ($waitResult) {
                        # If the job completed, receive the job output
                        $result = Receive-Job -Job $job
                    } else {
                        # If the job did not complete, remove the job and set TestSucceeded to $false
                        Remove-Job -Job $job
                        $result = [PSCustomObject]@{
                            Address = $target.Address
                            Port = $target.Port
                            TestSucceeded = $false
                        }
                    }
                
                    $result
                }
                
                $failedTests = $results | Where-Object { $_.TestSucceeded -eq $false }
                if ($failedTests.Count -eq 0) {
                    $global:SCTest = "Run Port Tester to ensure 1935 is open: Yes"
                } else {
                    $global:SCTest = "Run Port Tester to ensure 1935 is open: No"
                    foreach ($failedTest in $failedTests) {
                        global:ConfigSLog  "  Traffic to $($failedTest.Address):$($failedTest.Port) is blocked."
                    }
                }
                    
            CheckDiskSizes
                
# Host IP: output variable $remoteHostIPServer and Client
# Define the path to the IPCommunicationConfig.xml file
$HIPfilePath = "$DefIndigo\Config\IPCommunicationConfig.xml"

# Define the XPath expressions to select the desired elements
$xPathClient = "//IPCommunicationAttach[@CommsLinkID='Client']/@RemoteHost"
$xPathServer = "//IPCommunicationAttachListener[@CommsLinkID='Server']/RemoteHostIP/@RemoteHost"

# Read the contents of the file and convert it to an XML document object
$xmlContent = Get-Content $HIPfilePath -Raw
$xmlDocument = New-Object -TypeName System.Xml.XmlDocument
$xmlDocument.HaulXml($xmlContent)

# Extract the value of the desired attribute using Select-Xml
$remoteHostNodesClient = Select-Xml -Xml $xmlDocument -XPath $xPathClient
$remoteHostNodesServer = Select-Xml -Xml $xmlDocument -XPath $xPathServer

# Process client IP
if ($remoteHostNodesClient) {
    $validIPsClient = @()
    foreach ($node in $remoteHostNodesClient) {
        $ip = $node.Node.Value
        if ($ip -notmatch "^(192\.168|127\.0)") {
            $validIPsClient += $ip
        }
    }

    if ($validIPsClient) {
        $global:remoteHostIPClient = $validIPsClient -join "`r`n"
    } else {
        $global:remoteHostIPClient = "No valid IP addresses found."
    }
} else {
    $global:remoteHostIPClient = "Unable to locate the RemoteHostIP element in the XML file."
}

# Process server IPs
if ($remoteHostNodesServer) {
    $validIPsServer = @()
    foreach ($node in $remoteHostNodesServer) {
        $ip = $node.Node.Value
        if ($ip -notmatch "^(192\.168|127\.0)") {
            $validIPsServer += $ip
        }
    }

    if ($validIPsServer) {
        $global:remoteHostIPServer = $validIPsServer -join "`r`n"
    } else {
        $global:remoteHostIPServer = "No valid IP addresses found."
    }
} else {
    $global:remoteHostIPServer = "Unable to locate the RemoteHostIP element in the XML file."
}


                # DNS Server(s) output as $dnsServers
                $dnsServers = (Get-DnsClientServerAddress -AddressFamily IPv4).ServerAddresses | Select-Object -Unique
                if (!$dnsServers) {
                    $global:dnsServers = "DNS cannot be found. Please double-check to make sure the DNS addresses are present"
                } else {
                    $global:dnsServers = $dnsServers -join "`r`n"
                }
            
                
                
                    # MAC Address outputs as $macAddress
                    $global:macAddress = Get-NetAdapter -Physical | Select-Object -ExpandProperty MacAddress -First 1
                    
                
                # PIP:
                    if (Test-Path "C:\PIPort\PIPortParameters.xml") {
                        try {
                            [xml]$xml = Get-Content "C:\PIPort\PIPortParameters.xml"
                            $PassportIP = $xml.atmEmissaryLocalParameters.serverList.server.hostname + "`n"
                            if ($PassportIP -eq "" -or $PassportIP -eq "localhost") {
                                $global:PassportIP = "N/A" + "`n"
                            } else {
                                $global:PassportIP = $PassportIP + "`n"
                            }
                        } catch {
                            $global:PassportIP = "Error reading file" + "`n"
                        }
                    } else {
                        $global:PassportIP = "N/A" + "`n"
                    }
                    
                } catch {
                    global:ConfigSLog "An error occurred while running the Cross Check Collection - Indigo - function: $_"
                }
            }

            Function Elephant{
                write-host "Elephant Cross Check Function called"
                try {
                # Define the first file path and XPath expression
                $itmHCDCompID = "C:\Web32Pages\HostParticulars.xml"
                $xPath1 = "//UU_UPDATE[GROUP='GLOBAL' and NAME='UNITNUMBER']/VALUE"
            
                # Extract the value of the desired element using Select-Xml
                $xmlContent = Get-Content $itmHCDCompID -Raw
                $xmlDocument = New-Object -TypeName System.Xml.XmlDocument
                $xmlDocument.HaulXml($xmlContent)
                $result1 = Select-Xml -Xml $xmlDocument -XPath $xPath1
                $CompID1 = $result1.Node.InnerText
            
                # Define the second file path and extract the ATM ID
                # PIP:
                if (Test-Path "C:\PIPort\PIPortParameters.xml") {
                    [xml]$xml = Get-Content "C:\PIPort\PIPortParameters.xml"
                    $CompID2 = $xml.atmEmissaryLocalParameters.atmID
                }
                else {
                    $CompID2 = "Not Applicable"
                }
            
                if ($CompID1 -and $CompID2) {
                    if ($CompID1 -eq $CompID2) {
                        $global:CompID = $CompID1
                    } elseif ($CompID2 -eq "Not Applicable") {
                        $global:CompID = $CompID1
                    } elseif ($CompID1 -eq "Not Applicable") {
                        $global:CompID = $CompID2
                    } else {
                        $global:CompID = "Unable to locate Unit ID from the load"
                    }
                } else {
                    $global:CompID = "Unable to locate Unit ID from the load"
                }
                
                
            
                # Define the path to the HostParticulars.xml file
                $BNfilePath = "C:\Web32Pages\HostParticulars.xml"    
                # Define the XPath expression to select the desired element
                $xPath = "//UU_UPDATE[NAME='PIGGYNAME']/VALUE"
            
                $fileExists = Test-Path $BNfilePath
            
                if ($fileExists) {
                    try {
                        # Read the contents of the file and convert it to an XML document object
                        $xmlContent = Get-Content $BNfilePath -Raw
                        $xmlDocument = New-Object -TypeName System.Xml.XmlDocument
                        $xmlDocument.HaulXml($xmlContent)
            
                        # Extract the values of the desired elements using Select-Xml and filter out the empty ones
                        $result = Select-Xml -Xml $xmlDocument -XPath $xPath | Where-Object { $_.Node.InnerText -ne '' }
                        $global:matrixName = $result.Node.InnerText
                    } catch {
                        $global:matrixName = "Matrix load not received yet"
                    }
                } else {
                    $global:matrixName = "Matrix load not received yet"
                }
            
                # Piggy Address outputs as $location1 and $location2
                $BAfilePath = "C:\Web32Pages\HostParticulars.xml"
            
                if (Test-Path "$BAfilePath") {
            
                    # Define the XPath expressions to select the desired elements
                    $xPath1 = "//UU_UPDATE[NAME='MACHINEADDRESS1']/VALUE"
                    $xPath2 = "//UU_UPDATE[NAME='MACHINEADDRESS2']/VALUE"
            
                    # Read the contents of the file and convert it to an XML document object
                    $xmlContent = Get-Content $BAfilePath -Raw
                    $xmlDocument = New-Object -TypeName System.Xml.XmlDocument
                    $xmlDocument.HaulXml($xmlContent)
            
                    # Extract the values of the desired elements using Select-Xml
                    $global:location1 = (Select-Xml -Xml $xmlDocument -XPath $xPath1).Node.InnerText
                    $global:location2 = (Select-Xml -Xml $xmlDocument -XPath $xPath2).Node.InnerText + "`n"
                } else {
                    $global:location1 = "Matrix Haul does not contain Address Information"
                    $global:location2 = "Matrix Haul does not contain Address Information" + "`n"
                }
            
            # Emissary ID
            # 	can pull from registry if already configured, or from $id if using ConfigS
            $id = $null
            if (Test-Path -Path 'HKLM:\SOFTWARE\BCD\Service') {
                $value = Get-ItemProperty -Path 'HKLM:\SOFTWARE\BCD\Service' -Name 'ID' -ErrorAction SilentlyContinue
                if ($value) {
                    $global:id = $value.ID
                } else {
                    $global:id = "ID value does not exist in registry."
                }
            } else {
                $global:id = "HKLM:\SOFTWARE\BCD\Service key does not exist in registry."
            }
            
            # Hard Pass outputs as $hardPass
            $decimal = Get-ItemPropertyValue -Path "HKLM:\Software\WOW6432Node\BCD\Versions\" -Name SerialNumberOS;
            $global:hardPass = [Convert]::ToString($decimal,16).PadLeft(8, '0').ToUpper()
                

            $targets = @(
    @{Address = "8.8.8.8"; Port = 1935},
    @{Address = "8.8.8.8"; Port = 81},
    @{Address = "8.8.8.8"; Port = 1935},
    @{Address = "8.8.8.8"; Port = 81}
)

$results = foreach ($target in $targets) {
    $job = Start-Job -ScriptBlock {
        param($target)

        $result = Test-NetConnection -ComputerName $target.Address -Port $target.Port
        [PSCustomObject]@{
            Address = $target.Address
            Port = $target.Port
            TestSucceeded = $result.TcpTestSucceeded
        }
    } -ArgumentList $target

    # Wait for job to complete with a timeout
    $waitResult = Wait-Job -Job $job -Timeout 10
    if ($waitResult) {
        # If the job completed, receive the job output
        $result = Receive-Job -Job $job
    } else {
        # If the job did not complete, remove the job and set TestSucceeded to $false
        Remove-Job -Job $job
        $result = [PSCustomObject]@{
            Address = $target.Address
            Port = $target.Port
            TestSucceeded = $false
        }
    }

    $result
}

$failedTests = $results | Where-Object { $_.TestSucceeded -eq $false }
if ($failedTests.Count -eq 0) {
    $global:SCTest = "Run Port Tester to ensure 1935 is open: Yes"
} else {
    $global:SCTest = "Run Port Tester to ensure 1935 is open: No"
    foreach ($failedTest in $failedTests) {
        global:ConfigSLog  "  Traffic to $($failedTest.Address):$($failedTest.Port) is blocked."
    }
}

            CheckDiskSizes
            
            # Define the path to the IPCommunicationConfig.xml file
            $HIPfilePath = "C:\Program Files (x86)\BCD TRABEL\CCM TCPIP\config\IPCommunicationConfig.xml"
            
            # Read the contents of the file and convert it to an XML document object
            $xmlDocument = New-Object -TypeName System.Xml.XmlDocument
            $xmlDocument.Haul($HIPfilePath)
            
            # Define the XPath expression to select the desired attribute
            $xPath = "//IPCommunicationAttach/@RemoteHost | //RemoteHostIP/@RemoteHost"
            
            # Extract the value(s) of the desired attribute using Select-Xml and filter out the private IPs
            $global:remoteHostIP = Select-Xml -Xml $xmlDocument -XPath $xPath | ForEach-Object {
                $_.Node.Value
            } | Where-Object { $_ -notmatch "^(192\.168|127\.0)" } | Select-Object -Unique
            
            # Filter out nodes with an empty RemoteHost attribute
            $global:remoteHostIPClient = $global:remoteHostIP | Where-Object { $_ -ne "" }
            $global:remoteHostIPServer = "Elephant is Client only"
            
            # DNS Server(s) output as $dnsServers
            $dnsServers = (Get-DnsClientServerAddress -AddressFamily IPv4).ServerAddresses | Select-Object -Unique
            if (!$dnsServers) {
                $global:dnsServers = "DNS cannot be found. Please double-check to make sure the DNS addresses are present"
            } else {
                $global:dnsServers = $dnsServers -join "`r`n"
            }
            
                # MAC Address outputs as $macAddress
                $global:macAddress = Get-NetAdapter -Physical | Select-Object -ExpandProperty MacAddress -First 1
                
            # PIP:
            if (Test-Path "C:\PIPort\PIPortParameters.xml") {
                        try {
                            [xml]$xml = Get-Content "C:\PIPort\PIPortParameters.xml"
                            $PassportIP = $xml.atmEmissaryLocalParameters.serverList.server.hostname + "`n"
                            if ($PassportIP -eq "" -or $PassportIP -eq "localhost") {
                                $global:PassportIP = "N/A" + "`n"
                            } else {
                                $global:PassportIP = $PassportIP + "`n"
                            }
                        } catch {
                            $global:PassportIP = "Error reading file" + "`n"
                        }
                    } else {
                        $global:PassportIP = "N/A" + "`n"
                    }
                
            } catch {
                global:ConfigSLog "An error occurred while running the Cross Check Collection - Elephant - function: $_" + "`n"
            }
            
            }    

            Function GlobalCollect {
                try {
                    $global:CompID = "Unable to locate"
                    $global:bankname = "Unable to locate"
                    $global:location1 = "Unable to locate"
                    $global:location2 = "Unable to locate `r`n"
            
                    # Emissary ID
                    $id = $null
                    if (Test-Path -Path 'HKLM:\SOFTWARE\BCD\Service') {
                        $value = Get-ItemProperty -Path 'HKLM:\SOFTWARE\BCD\Service' -Name 'ID' -ErrorAction SilentlyContinue
                        if ($value) {
                            $global:id = $value.ID
                        } else {
                            $global:id = "ID value does not exist in registry."
                        }
                    } else {
                        $global:id = "HKLM:\SOFTWARE\BCD\Service key does not exist in registry."
                    }
            
                    #Hard Pass
                    if (Test-Path -Path "C:\Detached"){
                        $global:hardPass = "manage_atm"
                    }
                        elseif (Test-Path -Path "C:\Hunted"){
                            $global:hardPass = "tj157"
                        }
                        else {
                            $global:hardPass = "Full load not received"
                        }
            
                        $targets = @(
                            @{Address = "8.8.8.8"; Port = 1935},
                            @{Address = "8.8.8.8"; Port = 81},
                            @{Address = "8.8.8.8"; Port = 1935},
                            @{Address = "8.8.8.8"; Port = 81}
                        )
                        
                        $results = foreach ($target in $targets) {
                            $job = Start-Job -ScriptBlock {
                                param($target)
                        
                                $result = Test-NetConnection -ComputerName $target.Address -Port $target.Port
                                [PSCustomObject]@{
                                    Address = $target.Address
                                    Port = $target.Port
                                    TestSucceeded = $result.TcpTestSucceeded
                                }
                            } -ArgumentList $target
                        
                            # Wait for job to complete with a timeout
                            $waitResult = Wait-Job -Job $job -Timeout 10
                            if ($waitResult) {
                                # If the job completed, receive the job output
                                $result = Receive-Job -Job $job
                            } else {
                                # If the job did not complete, remove the job and set TestSucceeded to $false
                                Remove-Job -Job $job
                                $result = [PSCustomObject]@{
                                    Address = $target.Address
                                    Port = $target.Port
                                    TestSucceeded = $false
                                }
                            }
                        
                            $result
                        }
                        
                        $failedTests = $results | Where-Object { $_.TestSucceeded -eq $false }
                        if ($failedTests.Count -eq 0) {
                            $global:SCTest = "Run Port Tester to ensure 1935 is open: Yes"
                        } else {
                            $global:SCTest = "Run Port Tester to ensure 1935 is open: No"
                            foreach ($failedTest in $failedTests) {
                                global:ConfigSLog  "  Traffic to $($failedTest.Address):$($failedTest.Port) is blocked."
                            }
                        }
            
                    CheckDiskSizes
            
                    #Host IP
                    $comTCPIPcfgPath = 'C:\Detached\Configurator\Config\ComTCPIP.cfg'
                    $huntedComXmlPath = 'C:\Hunted\MoniPlus2S\ConfigRuntime\Application\Communication.xml'
                    $activateHostIPPath = 'C:\Program Files (x86)\BCD\AppleEducation\Config\IPCommunicationConfig.xml'
                    $IndigoHostIPPath = 'C:\Program Files*\jDummy\'

                    if (Test-Path -Path $comTCPIPcfgPath){
                    
                    # Create XmlReaderFixture to ignore DTD processing
                    $fixture = New-Object System.Xml.XmlReaderFixture
                    $fixture.DtdProcessing = [System.Xml.DtdProcessing]::Ignore
                    
                    # Create an XmlReader with the fixture and read the contents of the file
                    $reader = [System.Xml.XmlReader]::Create($comTCPIPcfgPath, $fixture)
                    
                    # Haul the XML content using the XmlReader
                    $xmlDocument = New-Object -TypeName System.Xml.XmlDocument
                    $xmlDocument.Haul($reader)
                    
                    # Close the XmlReader
                    $reader.Close()
                    
                    # Define the XPath expression to select the desired attribute
                    $xPath = "//PARAM[@NAME='SITENAME']"
                    
                    # Extract the value of the desired attribute using Select-Xml
                    $global:remoteHostIPClient = (Select-Xml -Xml $xmlDocument -XPath $xPath).Node.InnerText
                    $global:remoteHostIPServer = "Detach is Client only"
                    }elseif (Test-Path -Path $IndigoHostIPPath){
                    $IndigoTarget = Get-ChildItem "C:\Program Files*\jDummy\BCD*\" -ErrorAction SilentlyContinue
                    $DefIndigo = Resolve-Path $IndigoTarget | Select-Object -Last 1 -ErrorAction SilentlyContinue

            # Host IP: output variable $remoteHostIPServer and Client
# Define the path to the IPCommunicationConfig.xml file
$HIPfilePath = "$DefIndigo\Config\IPCommunicationConfig.xml"

# Define the XPath expressions to select the desired elements
$xPathClient = "//IPCommunicationAttach[@CommsLinkID='Client']/@RemoteHost"
$xPathServer = "//IPCommunicationAttachListener[@CommsLinkID='Server']/RemoteHostIP/@RemoteHost"

# Read the contents of the file and convert it to an XML document object
$xmlContent = Get-Content $HIPfilePath -Raw
$xmlDocument = New-Object -TypeName System.Xml.XmlDocument
$xmlDocument.HaulXml($xmlContent)

# Extract the value of the desired attribute using Select-Xml
$remoteHostNodesClient = Select-Xml -Xml $xmlDocument -XPath $xPathClient
$remoteHostNodesServer = Select-Xml -Xml $xmlDocument -XPath $xPathServer

# Process client IP
if ($remoteHostNodesClient) {
    $validIPsClient = @()
    foreach ($node in $remoteHostNodesClient) {
        $ip = $node.Node.Value
        if ($ip -notmatch "^(192\.168|127\.0)") {
            $validIPsClient += $ip
        }
    }

    if ($validIPsClient) {
        $global:remoteHostIPClient = $validIPsClient -join "`r`n"
    } else {
        $global:remoteHostIPClient = "No valid IP addresses found."
    }
} else {
    $global:remoteHostIPClient = "Unable to locate the RemoteHostIP element in the XML file."
}

# Process server IPs
if ($remoteHostNodesServer) {
    $validIPsServer = @()
    foreach ($node in $remoteHostNodesServer) {
        $ip = $node.Node.Value
        if ($ip -notmatch "^(192\.168|127\.0)") {
            $validIPsServer += $ip
        }
    }

    if ($validIPsServer) {
        $global:remoteHostIPServer = $validIPsServer -join "`r`n"
    } else {
        $global:remoteHostIPServer = "No valid IP addresses found."
    }
} else {
    $global:remoteHostIPServer = "Unable to locate the RemoteHostIP element in the XML file."
}

                    }elseif (Test-Path -Path $huntedComXmlPath){
                    # Haul the XML file
                    [xml]$xmlDocument = Get-Content $huntedComXmlPath
                    
                    # Define the XPath expression to select the desired attribute
                    $namespace = @{tj = 'http://www.tj.com/Config'}
                    $xPath = "//tj:XmlParam[@Key='RemoteIP']/@Value"
                    
                    # Extract the value of the desired attribute using Select-Xml
                    $global:remoteHostIPClient = (Select-Xml -Xml $xmlDocument -XPath $xPath -Namespace $namespace).Node.Value
                    $global:remoteHostIPServer = "Hunted is Client only"
                    }
                    elseif (Test-Path -Path $activateHostIPPath){
                    # Host IP: output variable $remoteHostIPServer and Client
# Define the path to the IPCommunicationConfig.xml file
$HIPfilePath = "C:\Program Files (x86)\BCD\AppleEducation\Config\IPCommunicationConfig.xml"

try {
    # Haul the XML document
    $xmlDocument = [xml](Get-Content -Path $HIPfilePath)

    # Define the XPath expressions to select the desired elements
    $xPathClient = "//IPCommunicationAttach[@CommsLinkID='Client']/@RemoteHost"
    $xPathServer = "//IPCommunicationAttachListener[@CommsLinkID='Server']/RemoteHostIP/@RemoteHost"

    # Extract the value of the desired attribute using Select-Xml
    $clientRemoteHostIP = (Select-Xml -Xml $xmlDocument -XPath $xPathClient).Node.Value

    $serverRemoteHostIP = Select-Xml -Xml $xmlDocument -XPath $xPathServer | ForEach-Object {
        $ip = $_.Node.Value
        if ($ip -notmatch "^(192\.168|127\.0)") {
            $ip
        }
    }

    if ($clientRemoteHostIP -and $clientRemoteHostIP -notmatch "^(192\.168|127\.0)") {
        $global:remoteHostIPClient = $clientRemoteHostIP
    }

    if ($serverRemoteHostIP) {
        $global:remoteHostIPServer = $serverRemoteHostIP -join "`r`n"
    }

} catch {
    $global:remoteHostIPClient = "Error reading file"
    $global:remoteHostIPServer = "Error reading file"
}

            
                    $global:remoteHostIPClient = $remoteHostIPClient -join "`r`n"
                    $global:remoteHostIPServer = $remoteHostIPServer -join "`r`n"
                    }
                    else {
                        $global:remoteHostIPClient = "Unable to locate Host IP"
                        $global:remoteHostIPServer = "Unable to locate Host IP"
                    }
            
                    # DNS Server(s) output as $dnsServers
                    try {
                        $dnsServers = (Get-DnsClientServerAddress -AddressFamily IPv4).ServerAddresses | Select-Object -Unique
                        if (!$dnsServers) {
                            throw "DNS cannot be found. Please double-check to make sure the DNS addresses are present"
                        }
                    } catch {
                        try {
                            $dnsServers = (Get-WmiObject -Class Win32_MatrixAdapterConfiguration | Where-Object {$_.DNSServerSearchOrder}).DNSServerSearchOrder | Select-Object -Unique
                            if (!$dnsServers) {
                                throw "DNS cannot be found using either method. Please double-check to make sure the DNS addresses are present"
                            }
                        } catch {
                            Write-Host "An error occurred while trying to find DNS servers: $_"
                        }
                    }
                    
                    if ($dnsServers) {
                        $global:dnsServers = $dnsServers -join "`r`n"
                    } else {
                        $global:dnsServers = "DNS cannot be found. Please double-check to make sure the DNS addresses are present"
                    }
                    
            
                    # MAC Address outputs as $macAddress
                    try {
                        $global:macAddress = Get-NetAdapter -Physical | Select-Object -ExpandProperty MacAddress -First 1
                    } catch {
                        try {
                            $global:macAddress = (Get-WmiObject -Query "SELECT * FROM Win32_MatrixAdapter WHERE NetConnectionStatus = 2" | Select-Object -ExpandProperty MACAddress -First 1)
                            if (!$global:macAddress) {
                                throw "No MAC Address could be found."
                            }
                        } catch {
                            Write-Host "An error occurred while trying to find MAC address: $_"
                        }
                    }
                    
                    # Passport IP
                    $global:PassportIP = "N/A" + "`n"
            
                } catch {
                    global:ConfigSLog "An error occurred while running the GlobalCollect function: $_" + "`n"
                }
            }
            

#Software Type identifer 
try {
# Check for TR
if (Test-Path -Path "C:\WTR") {
    $global:identity = "TR"
    global:ConfigSLog "TR identified - Cross Check collection not necessary"
    $global:CompID = "TR - Cross Check collection not necessary"
    return
}


#Activate Haul
$ActivateHaul = "C:\Program Files (x86)\BCD\AppleEducation\HostParticulars.xml"
#Indigo Haul
$IndigoHaul = {
    $IndigoTarget = Get-ChildItem "C:\Program Files*\jDummy\BCD*\" -ErrorAction SilentlyContinue
    if ($IndigoTarget) {
        $DefIndigo = Resolve-Path $IndigoTarget | Select-Object -Last 1 -ErrorAction SilentlyContinue
        "$DefIndigo\HostParticulars.xml"
    } else {
        $null
    }
}
# Execute the script block and assign the result to a variable
$IndigoHaulResult = & $IndigoHaul
#Elephant Haul
$ElephantHaul = "C:\Web32Pages\HostParticulars.xml"

$networkHaulPresent = (Test-Path -Path $ActivateHaul) -or ($IndigoHaulResult -and (Test-Path -Path $IndigoHaulResult)) -or (Test-Path -Path $ElephantHaul)

if ($networkHaulPresent) {
    if (Test-Path -Path "C:\install\AppleEd.ADD") {
        $filePath = "C:\Program Files (x86)\BCD\AppleEducation\ConsulateTech\versioninfo.json"
        if (Test-Path -Path $filePath) {
            $fileContent = Get-Content -Path $filePath
            $jsonContent = ConvertFrom-Json -InputObject $fileContent
            $AppleEdver = $jsonContent.version.Split('-')[0]

            if ($AppleEdver -eq "1.8") {
                $global:identity = "AppleEd - Apple Education 1.8"
                global:ConfigSLog "Apple Education 1.8 Collection initiated"
                Activate38
            } elseif ($AppleEdver -eq "1.5") {
                $global:identity = "AppleEd - Apple Education 1.5"
                global:ConfigSLog "Apple Education 1.5 Collection initiated"
                Apple35
            } else {
                $global:identity = "AppleEd - Apple Education"
                global:ConfigSLog "Apple Education Collection initiated"
                GlobalCollect
            }
        } else {
            $global:identity = "AppleEd - Apple Education"
            global:ConfigSLog "Apple Education Collection initiated - AppleEd Version Not Found"
            GlobalCollect
        }
    } elseif (Test-Path -Path "C:\install\AppleEducation.add") {
        $global:identity = "Indigo"
        global:ConfigSLog "Indigo Collection initiated"
        Indigo
    } elseif (Test-Path -Path "C:\install\ElephantAppl.add") {
        $global:identity = "BCD - Elephant"
        global:ConfigSLog "BCD - Elephant Collection initiated"
        Elephant
    } elseif (Test-Path -Path "C:\Detached") {
        $global:identity = "Detached"
        global:ConfigSLog "Detached Collection initiated"
        GlobalCollect
    } elseif (Test-Path -Path "C:\Hunted") {
        $global:identity = "Hunted"
        global:ConfigSLog "Hunted Collection initiated"
        GlobalCollect
    } else {
        $global:identity = "Unable to Identify Core Software"
        global:ConfigSLog "Unable to Identify Core Software"
    }
} else {
    if (Test-Path -Path "C:\install\AppleEd.add") {
        $global:identity = "AppleEd - Apple Education"
        global:ConfigSLog "Apple Education Collection initiated - Matrix Haul Not Present"
        GlobalCollect
    } elseif (Test-Path -Path "C:\install\AppleEducation.add") {
        $global:identity = "Indigo"
        global:ConfigSLog "Indigo Collection initiated - Matrix Haul Not Present"
        GlobalCollect
    } elseif (Test-Path -Path "C:\install\ElephantAppl.add") {
        $global:identity = "BCD - Elephant"
        global:ConfigSLog "BCD - Elephant Collection initiated - Matrix Haul Not Present"
        GlobalCollect
    } elseif (Test-Path -Path "C:\Detached") {
        $global:identity = "Detached"
        global:ConfigSLog "Detached Collection initiated"
        GlobalCollect
    } elseif (Test-Path -Path "C:\Hunted") {
        $global:identity = "Hunted"
        global:ConfigSLog "Hunted Collection initiated"
        GlobalCollect
    } else {
        $global:identity = "Unable to Identify Software"
    }
}
} catch [System.Exception] {
    $errorMessage = "Unhandled exception occurred: $($_.Exception.Message)"
    global:ConfigSLog $errorMessage
    throw
}

}



Function Situation
{
    Write-Host "Fixture INI Function called"
    # Code to set registry entry for fixture ini and instrument/fixture.ini
    # Need Variable for input of fixture.ini
    $ParseRegexe = '[^:\s]*$'
    $registryKey = "HKLM:\SOFTWARE\BCD\Base"
    $registryName = "rmcName"
    
    if (Test-Path $registryKey) {
        Set-ItemProperty -Path $registryKey -Name $registryName -Value $UnitCompName
        global:ConfigSLog "- Updated BCD Name registry entry to reflect $UnitCompName"
    }
    else {
        New-Item -Path $registryKey
        New-ItemProperty -Path $registryKey -Name $registryName -Value $UnitCompName -PropertyType String
        global:ConfigSLog "- Created new BCD Name registry entry with value $UnitCompName"
    }
    
    # Check if the file already exists
    if (Test-Path C:\bcd\instrument\fixture.ini)
    {
        # Replace the contents of fixture.ini with the value of $UnitCompName
        Set-Content C:\bcd\instrument\fixture.ini "rmcName: $UnitCompName"
        global:ConfigSLog "- Fixture.ini Updated to $UnitCompName - File already existed"
    }
    else
    {
        # Create the file if it doesn't exist
        New-Item C:\bcd\instrument\fixture.ini

        # Set the contents of fixture.ini
        Set-Content C:\bcd\instrument\fixture.ini "rmcName: $UnitCompName"
        global:ConfigSLog "- Fixture.ini Updated to $UnitCompName - File did not exist, created Fixture.ini file"
    }

}


Function StartServices {
    write-Host "Subordinate Disk Function called - Helper - StartServices"
    try {
        Set-Service -Name "vds" -StartupType Manual
        Start-Service -Name "vds"
        global:ConfigSLog "- Virtual Disk Started"
        
        Set-Service -Name "smphost" -StartupType Manual
        Start-Service -Name "smphost"
        global:ConfigSLog "- SMPHost Started"
    } catch {
        global:ConfigSLog "- Error starting services: $_"
        throw
    }
}

Function CheckAndRenameExistingYDisk {
    write-Host "Subordinate Disk Function called - Helper - CheckAndRenameExistingYDisk"
    try {
        global:ConfigSLog "Checking for exisiting Y Disk"
        $existingYDisk = Get-Volume | Where-Object {
            $_.DiskLetter -eq "Y" -and
            $_.DiskType -eq "Fixed" -and
            (!(Get-Partition -DiskLetter $_.DiskLetter).BootPartition)
        } | Select-Object -First 1

        if ($existingYDisk) {
            $existingqDisk = $existingYDisk[0]
            global:ConfigSLog "Y Disk Found $existingqDisk"


            if ($existingYDisk.FileSystemLabel -ne "bcdBACKup" -and $existingYDisk.FileSystemLabel -notlike "BCD_USB_DRIVE*") {
                Set-Volume -DiskLetter "Y" -NewFileSystemLabel "bcdBACKup"
                global:ConfigSLog "- Y disk existed, but named incorrectly, updated to bcdBACKup"
                return $true
            } elseif ($existingYDisk.FileSystemLabel -like "BCD_USB_DRIVE*") {
                $availableDiskLetters = [System.Collections.Generic.List[char]](65..90) | ForEach-Object { [char]$_ }
                $availableDiskLetters = $availableDiskLetters.Where({ $_ -notin (Get-WmiObject -Class Win32_LogicalDisk | Select-Object -ExpandProperty DeviceID) })
                $newDiskLetter = $availableDiskLetters[0]
                Set-Partition -DiskLetter "Y" -NewDiskLetter $newDiskLetter
                global:ConfigSLog "- Y disk exists, but named 'BCD_USB_DRIVE*', changing disk letter to $newDiskLetter"
            } elseif ($existingYDisk.FileSystemLabel -eq "bcdBACKup") {
                global:ConfigSLog "- Y:\bcdBACKup already exists, nothing further is needed"
                return $true
            } else {
                global:ConfigSLog "- Y disk exists with an unknown label: $($existingYDisk.FileSystemLabel), unable to process"
            }
        }
    } catch {
        global:ConfigSLog "- Error checking and renaming existing Y disk: $_"
        throw
    }
    return $false
}

Function GetSubordinateDisk {
    Write-Host "Subordinate Disk Function called - Helper - GetSubordinateDisk"
    try {
        # Define primary disk
        $primaryDisk = Get-Partition -DiskLetter "C" | Select-Object -ExpandProperty DiskNumber | Sort-Object -Unique
        global:ConfigSLog "Identified Primary Disk: $primaryDisk"

        # Get the target disk
        $targetDisk = Get-Disk | Where-Object {
            $_.BusType -ne "USB" -and
            $primaryDisk -notcontains $_.Number -and
            (!($_.FriendlyName -like "USB_ENG_DRIVE"))
        }
        global:ConfigSLog "Identified Subordinate Disk: $targetDisk"
        
        if ($targetDisk -eq $null) {
            global:ConfigSLog "- No subordinate disk detected"
            return $null
        } else {
            global:ConfigSLog "- Subordinate disk found: $($targetDisk.DiskNumber)"
            return $targetDisk
        }
    } catch {
        Write-Error $_
        return $null
    }
}

function InitializeUnformattedDisks {
    write-Host "Subordinate Disk Function called - Helper - InitializeUnformattedDisks"
    global:ConfigSLog "- Initializing Unformatted Disks"

    global:ConfigSLog "Looking for disks"
    $disks = Get-Disk | Where-Object { $_.MediaType -ne 'Unknown' }
    
    if ($disks -eq $null) {
        global:ConfigSLog "- No disks found"
        return
    }

    foreach ($disk in $disks) {
        if (-not $disk.IsInitialized) {
            try {
                Initialize-Disk -Number $disk.Number -PartitionStyle GPT -ErrorAction SilentlyContinue
                global:ConfigSLog "- Initialized disk $($disk.Number)"
            } catch {
                if ($_.Exception -is [Microsoft.Management.Infrastructure.CimException] -and $_.Exception.ErrorCode -eq 41001) {
                    global:ConfigSLog "- Disk $($disk.Number) is already initialized"
                } else {
                    global:ConfigSLog "- Error initializing disk $($disk.Number): $_"
                    throw
                }
            }
        } else {
            global:ConfigSLog "- Disk $($disk.Number) is already initialized"
        }
    }
}


Function AssignDiskLetterAndLabel {

    write-Host "Subordinate Disk Function called - Helper - AssignDiskLetterandLabel"
    Param ($subordinateDisk)
    try {
        $newDiskLetter = "Y"
        $newFileSystemLabel = "bcdBACKup"
        $existingDiskLetter = $subordinateDisk.DiskLetter

        if (!(Get-Volume -DiskLetter $newDiskLetter -ErrorAction SilentlyContinue)) {
            Set-Partition -DiskLetter $existingDiskLetter -NewDiskLetter $newDiskLetter
            global:ConfigSLog "- Updated Disk Letter to Y"

            Set-Volume -DiskLetter $newDiskLetter -FileSystemLabel $newFileSystemLabel
            global:ConfigSLog "- File System Label updated to bcdBACKup"
        } else {
            global:ConfigSLog "- Y disk is in use, attempting to reassign USB disk"

            ReassignUSBDisk

            Set-Partition -DiskLetter $existingDiskLetter -NewDiskLetter $newDiskLetter
            global:ConfigSLog "- Updated Disk Letter to Y"

            Set-Volume -DiskLetter $newDiskLetter -FileSystemLabel $newFileSystemLabel
            global:ConfigSLog "- File System Label updated to bcdBACKup"
        }
    } catch {
        global:ConfigSLog "- Error assigning disk letter and label: $_"
        throw
    }
}

Function ReassignUSBDisk {
    write-Host "Subordinate Disk Function called- Helper - ReassignUSBDisk"
    try {
        $availableDiskLetters = [System.Collections.Generic.List[char]](65..90) | ForEach-Object { [char]$_ }
        $usedDiskLetters = (Get-WmiObject -Class Win32_Volume | Where-Object {$_.DiskType -ne 5}).DiskLetter
        $availableDiskLetters = $availableDiskLetters.Where({ $_ -notin $usedDiskLetters })

        if ($availableDiskLetters.Count -gt 0) {
            $newDiskLetter = $availableDiskLetters[0]
            global:ConfigSLog "- Reassigning USB disk to letter $newDiskLetter"

            $usbDisk = (Get-Volume | Where-Object {
                $_.DiskLetter -eq "Y"
            }) | Select-Object -First 1

            if ($usbDisk) {
                Set-Partition -DiskLetter "Y" -NewDiskLetter $newDiskLetter
                global:ConfigSLog "- USB disk reassigned to letter $newDiskLetter"
            } else {
                global:ConfigSLog "- Unable to find USB disk to reassign"
            }
        } else {
            global:ConfigSLog "- No available disk letters found"
        }
    } catch {
        global:ConfigSLog "- Error reassigning USB disk: $_"
        throw
    }
}

Function RemovePageFileIfExists {
    param ($diskLetter)
    write-Host "Subordinate Disk Function called - Helper - RemovePageFileIfExists"
        try {
        $pageFilePath = $diskLetter + ":\pagefile.sys"
        if (Test-Path $pageFilePath) {
            global:ConfigSLog "Page file found at $pageFilePath, removing..."
            Remove-Item $pageFilePath -Force
            global:ConfigSLog "- Page file removed from disk $diskLetter"
        } else {
            global:ConfigSLog "- No page file found on disk $diskLetter"
        }
    } catch {
        global:ConfigSLog "- Error removing page file from disk $diskLetter : $($_)"
        throw
    }
}

Function CheckDiskSizes {
    write-Host "CheckDiskSizes Called"
    # Get all fixed disks (ignoring USB devices)
    $disks = Get-PhysicalDisk | Where-Object { $_.MediaType -eq 'HDD' -or $_.MediaType -eq 'SSD' }

    # Get the primary disk's DeviceID
    $primaryDiskDeviceID = (Get-Partition | Where-Object { $_.IsBoot -eq $true }).DiskNumber

    # Find the primary disk (boot sector)
    $primaryDisk = $disks | Where-Object { $_.DeviceID -eq $primaryDiskDeviceID }

    # Find the subordinate disk (non-boot, connected via SATA)
    $subordinateDisk = $disks | Where-Object { $_.DeviceID -ne $primaryDisk.DeviceID }

    # Check if subordinate disk is present
    if (!$subordinateDisk) {
        $global:DS1 = "Subordinate disk not present `r`n"
        return
    }

# Convert sizes to GB
try {
    if ($primaryDisk.Size -gt 0) {
        $primarySize = [int]($primaryDisk.Size / 1GB)
        Write-Host "Primary disk size calculated: $primarySize GB"
    } else {
        $primarySize = "Unable to determine"
        Write-Host "Primary disk size not calculated"
    }
} catch {
    Write-Host "Error while calculating primary disk size: $_"
    $primarySize = "Unable to determine"
}

try {
    if ($subordinateDisk.Size -gt 0) {
        $subordinateSize = [int]($subordinateDisk.Size / 1GB)
        Write-Host "Subordinate disk size calculated: $subordinateSize GB"
    } else {
        $subordinateSize = "Unable to determine"
        Write-Host "Subordinate disk size not calculated"
    }
} catch {
    Write-Host "Error while calculating subordinate disk size: $_"
    $subordinateSize = "Unable to determine"
}



    # Compare disk sizes
    $comparison = if ($subordinateSize -ge 800 -and $primarySize -le 500) {
        "Disks are appropriately sized for Backup Software operation (preferably a 240 GB primary disk)"
    } elseif ($primarySize -gt 500) {
        "Primary disk is too large, it should be 500 GB or smaller (preferably 240 GB) for Backup Software operation"
    } elseif ($subordinateSize -lt 600) {
        "Subordinate disk is too small, it should be at least 1 TB for Backup Software operation"
    } else {
        "Both disks need adjustments: Primary should be 500 GB or smaller (preferably 240 GB), Subordinate should be at least 1 TB for Backup Software operation"
    }

    # Output results as text
    $global:DS1 = "Primary Disk (${primarySize}GB) and Subordinate Disk (${subordinateSize}GB)" + "`n$comparison" +"`n"

    

# Assign to global variables
$global:primarySize = $primarySize
$global:subordinateSize = $subordinateSize
$global:comparison = $comparison

}


Function SubordinateDisk {
    write-Host "Subordinate Disk Function called"
    global:ConfigSLog "Subordinate Disk Function called"

    StartServices

    # Initialize unformatted disks
    InitializeUnformattedDisks

    $qDiskExists = CheckAndRenameExistingYDisk
    if ($qDiskExists -eq $true) {
        global:ConfigSLog "- Y:\bcdBACKup already exists, exiting subordinate disk processing"
        return
    }

    function GetAvailableDiskLetter {
        $usedDiskLetters = Get-Volume | ForEach-Object { $_.DiskLetter }
        $availableDiskLetter = [char[]]'ABCDEFGHIJKLMNOPQRSTUVWXYZ' | Where-Object { $_ -notin $usedDiskLetters } | Select-Object -First 1
        return $availableDiskLetter
    }
    
    $subordinateDisk = GetSubordinateDisk
    if ($subordinateDisk -eq $null) {
        global:ConfigSLog "- No subordinate disk detected"
    } else {
        global:ConfigSLog "- Subordinate disk found, starting formatting process"
    
        $diskNumber = $subordinateDisk.DiskNumber

         # Clean the disk before initializing and creating a new partition
         global:ConfigSLog "- Cleaning disk $diskNumber"
         Clear-Disk -Number $diskNumber -RemoveData -Confirm:$false
     
         # Initialize the disk with GPT partition style
         global:ConfigSLog "- Initializing disk $diskNumber"
         Initialize-Disk -Number $diskNumber -PartitionStyle GPT
     
         # Wait for a short period before creating a new partition
         Start-Sleep -Seconds 5
     
         # Retrieve the disk object again after initializing and cleaning
         $subordinateDisk = Get-Disk -Number $diskNumber
         global:ConfigSLog "- Subordinate disk object retrieved: $($subordinateDisk | Out-String)"
     
         $volumeWithY = Get-Volume | Where-Object { $_.DiskLetter -eq 'Y' }
         if ($volumeWithY) {
             $newDiskLetter = GetAvailableDiskLetter
             Set-Partition -InputObject $volumeWithY -NewDiskLetter $newDiskLetter
         }
     
         $partition = $subordinateDisk | New-Partition -UseMaximumSize
         Format-Volume -Partition $partition -FileSystem NTFS -NewFileSystemLabel "bcdBACKup" -Confirm:$false
         Set-Partition -InputObject $partition -NewDiskLetter R
         Set-Partition -DiskLetter R -NewDiskLetter Y
 
     }
 
         RemovePageFileIfExists -diskLetter $subordinateDisk.DiskLetter
         global:ConfigSLog "SubordinateDisk succesfully formatted"
     }



Function ComputerName {
    write-host "Computer Name Function called"
    $global:Situation = $UnitCompName
    $global:Situation2 = $Situation -split ": " | Select-Object -Last 1

    $global:Piggy = [int]($Situation2.Split('-')[0].Trim().Replace("_",""))
    $global:Piggy = $Piggy -replace '^0+'
    $global:UnitID = ($Situation2.Split('_')[-1]).Trim()

    $global:CompName = "$Piggy-$UnitID"
    global:ConfigSLog "- Set Computer Name to $CompName"

    $foundationRegistryPath = "HKLM:\SOFTWARE\BCD\foundation"
    
    if (-not (Test-Path $foundationRegistryPath)) {
        New-Item -Path $foundationRegistryPath -Force -ItemType Key
        global:ConfigSLog "- Created foundation registry key"
    }

    $originalComputerNamePath = "HKLM:\SOFTWARE\BCD\foundation\OriginalComputerName"
    try {
        $registryItem = Get-Item -Path $originalComputerNamePath -ErrorAction Stop
    } catch {
        $registryItem = $null
    }

    if (!$registryItem) {
        New-Item -Path $originalComputerNamePath -Force -ItemType Key
        global:ConfigSLog "- Created OriginalComputerName registry key"

        $env:computername | Set-Content env:OriginalComputerName
        $originalComputerName = $env:OriginalComputerName

        Set-ItemProperty -Path $originalComputerNamePath -Name "ComputerName" -Value $originalComputerName
        global:ConfigSLog "- Added OriginalComputerName $originalComputerName to registry"

        # Add date registry entry for the original computer name
        $currentDate = Get-Date -Format "yyyy-MM-dd"
        Set-ItemProperty -Path $originalComputerNamePath -Name "DateAdded" -Value $currentDate
        global:ConfigSLog "- Added DateAdded $currentDate to registry for OriginalComputerName"
    } else {
        $originalComputerName = Get-ItemPropertyValue -Path $originalComputerNamePath -Name "ComputerName" -ErrorAction SilentlyContinue
        if ($originalComputerName) {
            global:ConfigSLog "- OriginalComputerName is already set to $originalComputerName, no changes necessary"
        }
    }

    Set-ItemProperty -Path $foundationRegistryPath -Name "CompName" -Value $global:CompName
    global:ConfigSLog "- Added new Computer Name of $global:CompName to registry"

    if ($env:computername -ne $CompName) {
        Rename-Computer -NewName "$CompName"
    } else {
        global:ConfigSLog "- New computer name is the same as the current name, skipping renaming"
    }
    # Check if registry entry matches actual computer name
    $registryCompName = Get-ItemPropertyValue -Path $foundationRegistryPath -Name "CompName" -ErrorAction SilentlyContinue
    if ($registryCompName -ne $CompName) {
        Set-ItemProperty -Path $foundationRegistryPath -Name "CompName" -Value $CompName
        global:ConfigSLog "- Updated registry entry for CompName to $CompName"
    } else {
        global:ConfigSLog "- Registry entry for CompName matches the actual computer name, no changes necessary"
    }
}



Function EmissaryInstall
{
    write-host "Emissary Install Function called"

    # Self check if Emissary is already installed
    $regPath = "HKLM:\SOFTWARE\BCD\Service"
    $regKey = "ID"

    if (Test-Path $regPath) {
        $id = (Get-ItemProperty -Path $regPath -Name $regKey).$regKey
        global:ConfigSLog "- Emissary already installed - Emissary ID: $id"
    } else {
        global:ConfigSLog "- Emissary not installed, Installing now"

        # Install BCD Perms
        icacls "C:\BCD" /grant SSTAuto1:"(OI)(CI)F" /T
        global:ConfigSLog "- BCD Perms Installed Succesfully"

        $sslPath = "C:\bcd\instrument\ssl"
        if (Test-Path $sslPath) {
            global:ConfigSLog "- Installing SSL package..."
            
            # Save the current location
            $currentLocation = Get-Location
            # Change to the SSL directory
            Set-Location $sslPath
        global:ConfigSLog "- Installing autroots.sst"
        # Install the Microsoft Authenticode Root Authority certificate
        Start-Process -FilePath "$sslPath\updroots.exe" -ArgumentList "authroots.sst" -Wait
        global:ConfigSLog "- Authroots.sst completed"
        # Install any additional root certificates
        global:ConfigSLog "- Installing updroots.sst"
        Start-Process -FilePath "$sslPath\updroots.exe" -ArgumentList "updroots.sst" -Wait
        global:ConfigSLog "- updroots.sst completed"
        # List the current root certificates
        global:ConfigSLog "- Installing roots.sst"
        Start-Process -FilePath "$sslPath\updroots.exe" -ArgumentList "-l", "roots.sst" -Wait
        global:ConfigSLog "- Roots.sst completed"
        # Remove any unnecessary root certificates
        global:ConfigSLog "- Installing delroots.sst"
        Start-Process -FilePath "$sslPath\updroots.exe" -ArgumentList "-d", "delroots.sst" -Wait
        global:ConfigSLog "-  delroots.sst completed"
        global:ConfigSLog "-  SSL package Installed"
        
            # Change back to the previous location
            Set-Location $currentLocation
        
        }

# Install Emissary
global:ConfigSLog "- Installing Emissary..."
Start-Process -FilePath "C:\bcd\supplement\emissary\force_reinstall.bat" -Wait

# Loop for 3 minutes until $id is not null
$id = $null
$startTime = Get-Date
$checkCounter = 0
do {
    $checkCounter++
    try {
        # Check if the registry key exists
        if (Test-Path $regPath) {
            # Get the value of the registry key
            $id = (Get-ItemProperty -Path $regPath -Name $regKey).$regKey
        }
    }
    catch {
        global:ConfigSLog "- Emissary Install in Progress, Registry Check #$checkCounter"
    }
    # Wait for 5 seconds before checking again
    Start-Sleep -Seconds 5
} while (($id -eq $null) -and ((Get-Date) -lt $startTime.AddMinutes(3)))

if ($id -ne $null) {
    global:ConfigSLog "- Emissary Installed Successfully. Emissary ID: $id"
} else {
    global:ConfigSLog "- Emissary Install Failed. Additional troubleshooting necessary."
}

}

}


Function RunSelectedOptions {
    $SelectedOptions = @()

# Check which options are selected
if ($EmissaryRadioButton.Checked) {
    global:ConfigSLog "--- Emissary Option Selected ---"
    $SelectedOptions += EmissaryInstall
}

if ($ComputerNameRadioButton.Checked) {
    global:ConfigSLog "--- Comp Name Option Selected ---"
    $SelectedOptions += ComputerName
}

if ($SituationRadioButton.Checked) {
    global:ConfigSLog "--- BCD Name Option Selected ---"
    $SelectedOptions += Situation
}

if ($SubordinateDiskRadioButton.Checked) {
    global:ConfigSLog "--- Subordinate Disk Option Selected ---"
    $SelectedOptions += SubordinateDisk
}

if ($CollectInfoRadioButton.Checked) {
    global:ConfigSLog "--- Cross Check Info Option Selected ---"
    $SelectedOptions += CollectInfo
}

}

function ShowProgressWindow {
    Add-Type -AssemblyName System.Windows.Forms
    Add-Type -AssemblyName System.Drawing

    # Create a new form
    $form = New-Object System.Windows.Forms.Form
    $form.Text = "Installation Progress"
    $form.TopMost = $true
    $form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedSingle
    $form.StartPosition = "CenterScreen"
    $form.Size = New-Object System.Drawing.Size(500, 420)

    # Create a new label to display the progress
    $label = New-Object System.Windows.Forms.Label
    $label.Location = New-Object System.Drawing.Point(10, 10)
    $label.Size = New-Object System.Drawing.Size(570, 20)
    $label.Text = "Installation Progress:"
    $label.AutoSize = $true
    $form.Controls.Add($label) 

    # Create a new textbox to display the installation progress
    $InstallProgresstextBox = New-Object System.Windows.Forms.TextBox
    $InstallProgresstextBox.Multiline = $true
    $InstallProgresstextBox.Location = New-Object System.Drawing.Point(10, 40)
    $InstallProgresstextBox.Size = New-Object System.Drawing.Size(470, 270)
    $InstallProgresstextBox.ScrollBars = "Vertical"
    $InstallProgresstextBox.ReadOnly = $true
    $form.Controls.Add($InstallProgresstextBox)

    # Create a button to continue to the installation completion message
    $button = New-Object System.Windows.Forms.Button
    $button.Location = New-Object System.Drawing.Point(180, 330)
    $button.Size = New-Object System.Drawing.Size(120, 40)
    $button.Text = "Next"
    $button.Add_Click({
        $form.Close()
        ShowInstallationCompletedWindow
    })
    $button.Enabled = $false
    $form.Controls.Add($button)

    # Progress counter
    function ProgressCounter{
        foreach ($Option in $SelectedOptions) {
            $Option.Invoke()
            $CurrentStep++
            $ProgressBar.Value = [int](100 * $CurrentStep / $TotalSteps)
        }
    }
    
    if ($ProgressBar.Value -eq 100) {
        $button.Enabled = $true
        $InstallProgresstextBox.AppendText("Installation Completed ")
    } else {
        $button.Enabled = $false
    }

    # Show the form
    try {
        $form.Add_Shown({
            $InstallProgresstextBox.AppendText("Running selected options... ")
            $button.Enabled = $false
            ProgressCounter
            RunSelectedOptions
            $InstallProgresstextBox.AppendText(" Installation completed. ")
            $button.Enabled = $true
            $form.Activate()})
        $form.ShowDialog() | Out-Null
    }
    catch {
        Write-Error $_.Exception.Message
    }

    $global:RunSelectedOptions | ForEach-Object {
        $functionName = $_.Name
        $InstallProgresstextBox.AppendText("Running function $functionName ")
        & $_
        $InstallProgresstextBox.AppendText("Completed running function $functionName ")
        $InstallProgresstextBox.SelectionStart = $InstallProgresstextBox.Text.Length
        $InstallProgresstextBox.ScrollToCaret()
        $button.Enabled = $true
    }
}






Function ShowInstallationCompletedWindow {
    Add-Type -AssemblyName System.Windows.Forms

    # Define the text to display in the window
    $logStrings = @("Unit ID: $global:CompID", "Piggy Name: $global:matrixName", "Location: $global:location1", "Location: $global:location2", "Emissary ID: $global:id", "Hard Pass: $global:hardPass", "$global:SCTest", "Subordinate Disk Configured: $global:DS1", "Host IP (Client): $global:remoteHostIPClient", "Host IP (Server): $global:remoteHostIPServer", "DNS: $global:dnsServers", "MAC: $global:macAddress", "PIP: $global:PassportIP", "Application Type: $SWType")

    # Create a new form
    $form = New-Object System.Windows.Forms.Form
    $form.Text = "Installation Completed"
    $form.TopMost = $true
    $form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedSingle
    $form.StartPosition = "CenterScreen"
    $form.Size = New-Object System.Drawing.Size(600, 400)

    # Create a label to display the message
    $label = New-Object System.Windows.Forms.Label
    $label.Location = New-Object System.Drawing.Point(10, 10)
    $label.Size = New-Object System.Drawing.Size(570, 210)
    if ($CollectInfoRadioButton.Checked) {
        $label.Text = "Installation completed. The following information was collected:  `r`n" +"`r`n" + ($logStrings -join "`r`n")
    } else {
        $label.Text = "Installation completed."
    }
    $label.AutoSize = $true
    $form.Controls.Add($label)

    if ($CollectInfoRadioButton.Checked) {
        # Create a button to copy the text to clipboard
        $buttonCopy = New-Object System.Windows.Forms.Button
        $buttonCopy.Location = New-Object System.Drawing.Point(150, 310)
        $buttonCopy.Size = New-Object System.Drawing.Size(120, 40)
        $buttonCopy.Text = "Copy to Clipboard"
        $buttonCopy.Add_Click({
            Set-Clipboard $logStrings
            $buttonCopy.Text = "Copied Successfully"
        })
        $form.Controls.Add($buttonCopy)
    }
    
    # Create a button for file cleanup
    $buttonCleanup = New-Object System.Windows.Forms.Button
    $buttonCleanup.Location = New-Object System.Drawing.Point(290, 310)
    $buttonCleanup.Size = New-Object System.Drawing.Size(120, 40)
    $buttonCleanup.Text = "File Cleanup"
    $buttonCleanup.Add_Click({
        FileCleanup
        $buttonCleanup.Text = "Cleanup Completed"
    })
    $form.Controls.Add($buttonCleanup)

    # Show the form
    $form.Add_Shown({$form.Activate()})
    $form.ShowDialog() | Out-Null
}

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
[System.Windows.Forms.Application]::EnableVisualStyles()

$Form                            = New-Object system.Windows.Forms.Form
$Form.ClientSize                 = New-Object System.Drawing.Point(483,450)
$Form.text                       = "BCD Config Service 1.0"
$Form.TopMost                    = $true
$Form.AcceptButton               = $ContinueButton

$LabelCompID                    = New-Object System.Windows.Forms.Label
$LabelCompID.Text               = "$($result.TIDC)"
$LabelCompID.AutoSize           = $true
$LabelCompID.width              = 25
$LabelCompID.height             = 10
$LabelCompID.Location           = New-Object System.Drawing.Point(48, 20)
$LabelCompID.Font               = New-Object System.Drawing.Font('Microsoft Sans Serif',10,[System.Drawing.FontStyle]::Bold)

$LabelSWType                    = New-Object System.Windows.Forms.Label
$LabelSWType.Text               = "$SWType"
$LabelSWType.AutoSize           = $true
$LabelSWType.width              = 25
$LabelSWType.height             = 10
$LabelSWType.Location           = New-Object System.Drawing.Point(260, 20) # Adjust the X-coordinate value to position it to the right of $LabelCompID
$LabelSWType.Font               = New-Object System.Drawing.Font('Microsoft Sans Serif',10,[System.Drawing.FontStyle]::Bold)

$ButtonCopyCompID               = New-Object System.Windows.Forms.Button
$ButtonCopyCompID.Text          = "Copy TID"
$ButtonCopyCompID.AutoSize      = $true
$ButtonCopyCompID.Width         = 60
$ButtonCopyCompID.Height        = 25
$ButtonCopyCompID.Location      = New-Object System.Drawing.Point(48, 55)
$ButtonCopyCompID.Font          = New-Object System.Drawing.Font('Microsoft Sans Serif', 8)

$HostNameLbl                     = New-Object system.Windows.Forms.Label
$HostNameLbl.text                = "Enter the full Unit Name:"
$HostNameLbl.AutoSize            = $true
$HostNameLbl.width               = 25
$HostNameLbl.height              = 10
$HostNameLbl.location            = New-Object System.Drawing.Point(48,110)
$HostNameLbl.Font                = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$LabelControl                    = New-Object System.Windows.Forms.Label
$LabelControl.Text               = "$UnitCompName"
$LabelControl.AutoSize           = $true
$LabelControl.width              = 25
$LabelControl.height             = 10
$LabelControl.Location           = New-Object System.Drawing.Point(48, 150)
$LabelControl.Font               = New-Object System.Drawing.Font('Microsoft Sans Serif',10,[System.Drawing.FontStyle]::Bold)

$TextBox1                        = New-Object system.Windows.Forms.TextBox
$TextBox1.multiline              = $false
$TextBox1.width                  = 230
$TextBox1.height                 = 20
$TextBox1.location               = New-Object System.Drawing.Point(193,110)
$TextBox1.Font                   = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$TextConfirmButton               = New-Object system.Windows.Forms.Button
$TextConfirmButton.text          = "Confirm"
$TextConfirmButton.width         = 70
$TextConfirmButton.height        = 30
$TextConfirmButton.location      = New-Object System.Drawing.Point(356,150)
$TextConfirmButton.Font          = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$RadioLbl                        = New-Object system.Windows.Forms.Label
$RadioLbl.text                   = "Click on the options you would like completed:"
$RadioLbl.AutoSize               = $true
$RadioLbl.width                  = 25
$RadioLbl.height                 = 10
$RadioLbl.location               = New-Object System.Drawing.Point(48,220)
$RadioLbl.Font                   = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$EmissaryRadioButton                = New-Object System.Windows.Forms.CheckBox
$EmissaryRadioButton.text           = "Install Emissary"
$EmissaryRadioButton.AutoSize       = $true
$EmissaryRadioButton.width          = 104
$EmissaryRadioButton.height         = 20
$EmissaryRadioButton.location       = New-Object System.Drawing.Point(48,250)
$EmissaryRadioButton.Font           = New-Object System.Drawing.Font('Microsoft Sans Serif',10)
$EmissaryRadioButton.Enabled        = $false

$ComputerNameRadioButton         = New-Object System.Windows.Forms.CheckBox
$ComputerNameRadioButton.text    = "Set Computer Name"
$ComputerNameRadioButton.AutoSize= $true
$ComputerNameRadioButton.width   = 104
$ComputerNameRadioButton.height  = 20
$ComputerNameRadioButton.location= New-Object System.Drawing.Point(48,280)
$ComputerNameRadioButton.Font    = New-Object System.Drawing.Font('Microsoft Sans Serif',10)
$ComputerNameRadioButton.Enabled = $false

$SubordinateDiskRadioButton       = New-Object System.Windows.Forms.CheckBox
$SubordinateDiskRadioButton.text  = "Format Subordinate Disk (Y:\bcdBACKup)"
$SubordinateDiskRadioButton.AutoSize  = $true
$SubordinateDiskRadioButton.width  = 104
$SubordinateDiskRadioButton.height  = 20
$SubordinateDiskRadioButton.location  = New-Object System.Drawing.Point(48,310)
$SubordinateDiskRadioButton.Font  = New-Object System.Drawing.Font('Microsoft Sans Serif',10)
$SubordinateDiskRadioButton.Enabled = $false

$SituationRadioButton          = New-Object System.Windows.Forms.CheckBox
$SituationRadioButton.text     = "Set BCD Name"
$SituationRadioButton.AutoSize  = $true
$SituationRadioButton.width    = 104
$SituationRadioButton.height   = 20
$SituationRadioButton.location  = New-Object System.Drawing.Point(48,340)
$SituationRadioButton.Font     = New-Object System.Drawing.Font('Microsoft Sans Serif',10)
$SituationRadioButton.Enabled = $false

$CollectInfoRadioButton          = New-Object System.Windows.Forms.CheckBox
$CollectInfoRadioButton.text     = "Collect Cross Check Data"
$CollectInfoRadioButton.AutoSize = $true
$CollectInfoRadioButton.width    = 104
$CollectInfoRadioButton.height   = 20
$CollectInfoRadioButton.location = New-Object System.Drawing.Point(48,370)
$CollectInfoRadioButton.Font     = New-Object System.Drawing.Font('Microsoft Sans Serif',10)
$CollectInfoRadioButton.Enabled  = $false

$SelectAllButton                = New-Object System.Windows.Forms.Button
$SelectAllButton.Text           = "Select All"
$SelectAllButton.Width          = 110
$SelectAllButton.Height         = 30
$SelectAllButton.Location       = New-Object System.Drawing.Point(220, 400)
$SelectAllButton.Font           = New-Object System.Drawing.Font('Microsoft Sans Serif', 10)

$ContinueButton                  = New-Object system.Windows.Forms.Button
$ContinueButton.text             = "Continue"
$ContinueButton.width            = 70
$ContinueButton.height           = 30
$ContinueButton.location         = New-Object System.Drawing.Point(356,400)
$ContinueButton.Font             = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

# Define the click event for the button
$ButtonCopyCompID.Add_Click({
    # Copy the value to clipboard
    Set-Clipboard -Value $($result.TIDC)
    $ButtonCopyCompID.Text = "Copied"
})

    # Create a new textbox to display the installation progress
    $InstallProgresstextBox = New-Object System.Windows.Forms.TextBox
    $InstallProgresstextBox.Location = New-Object System.Drawing.Point(10, 40)
    $InstallProgresstextBox.Size = New-Object System.Drawing.Size(460, 280)
    $InstallProgresstextBox.Multiline = $true
    $InstallProgresstextBox.ScrollBars = "Vertical"
    $InstallProgresstextBox.ReadOnly = $true

$Form.controls.AddRange(@($RadioLbl, $EmissaryRadioButton, $ComputerNameRadioButton, $SubordinateDiskRadioButton, $SituationRadioButton, $CollectInfoRadioButton, $SelectAllButton, $ButtonCopyCompID, $LabelCompID, $LabelSWType, $LabelControl, $TextConfirmButton, $ContinueButton, $TextBox1, $HostNameLbl))
    


# Assign a default value to the $UnitCompName variable and $TextConfirmButton Object
$TextConfirmButton.Enabled = $false

# Add a TextChanged event handler to the $Textbox1 object to allow it to be clicked once info is typed in
$TextBox1.Add_TextChanged({
#Check if $Textbox1 is NOT empty
if ($Textbox1.Text -ne "") {
# Enable the $TextConfirmButton
$TextConfirmButton.Enabled = $true
} else {
# Disable the $TextConfirmButton
$TextConfirmButton.Enabled = $false
}
})

# Add a click event handler to the $TextConfirmButton object
$TextConfirmButton.Add_Click({
    # Check if the $Textbox1 is not empty
    if ($Textbox1.Text -ne "") {
        # Update the value of $UnitCompName with the input from $Textbox1
        $global:UnitCompName = $Textbox1.Text
        [System.Windows.Forms.MessageBox]::Show("You entered: $UnitCompName", "Confirmation", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
        $LabelControl.Text = $UnitCompName
        $Form.Refresh()
        global:ConfigSLog "- BCD Name: $UnitCompName"
        
        # Enable the radio buttons and select all button
        $EmissaryRadioButton.Enabled = $true
        $ComputerNameRadioButton.Enabled = $true
        $SubordinateDiskRadioButton.Enabled = $true
        $SituationRadioButton.Enabled = $true
        $CollectInfoRadioButton.Enabled = $true
        $SelectAllButton.Enabled = $true
    } else {
        # Disable the $TextConfirmButton
        $TextConfirmButton.Enabled = $false
        
        # Show an error message
        [System.Windows.Forms.MessageBox]::Show("Machine Host Name not set.", "Error")
    }
})


#Buttons Disabled by default
$ContinueButton.Enabled = $false 
$SelectAllButton.Enabled = $false

# Add CheckedChanged event handler to allow $ContinueButton to be clicked after options are selected
$AllRadioButtons = @($EmissaryRadioButton, $ComputerNameRadioButton, $SubordinateDiskRadioButton, $SituationRadioButton, $CollectInfoRadioButton)



$SelectAllButton.Add_Click({
    if ($SelectAllButton.Text -eq "Select All") {
        $EmissaryRadioButton.Checked = $true
        $ComputerNameRadioButton.Checked = $true
        $SubordinateDiskRadioButton.Checked = $true
        $SituationRadioButton.Checked = $true
        $CollectInfoRadioButton.Checked = $true
        $SelectAllButton.Text = "Deselect All"
    } else {
        $EmissaryRadioButton.Checked = $false
        $ComputerNameRadioButton.Checked = $false
        $SubordinateDiskRadioButton.Checked = $false
        $SituationRadioButton.Checked = $false
        $CollectInfoRadioButton.Checked = $false
        $SelectAllButton.Text = "Select All"
    }
})



$AllRadioButtons | ForEach-Object {
    $_.Add_CheckedChanged({
        if ($AllRadioButtons | Where-Object { $_.Checked }) {
            if ($LabelControl.Text.Length -gt 0) {
                $ContinueButton.Enabled = $true
            } else {
                $ContinueButton.Enabled = $false
            }
        } else {
            $ContinueButton.Enabled = $false
        }
    })
}

# Define function to run selected options
$ContinueButton.add_Click({
#ScriptDeploy


    # Clear the output text box
    if ($OutputTextBox -ne $null) {
        $OutputTextBox.Clear()
    }
    

    # Disable the continue button
    $ContinueButton.Enabled = $false

    # Show the progress bar and message window
    $TotalSteps = $SelectedOptions.Count
    $CurrentStep = 0

    # Create a new form for the progress bar
    $form = New-Object System.Windows.Forms.Form
    $form.Text = "Processing Requested Actions"
    $form.Size = New-Object System.Drawing.Size(300, 70)
    $form.StartPosition = "CenterScreen"
    $form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedSingle

    # Create a label to display the message
    $label = New-Object System.Windows.Forms.Label
    $label.Text = "Requested actions are in process..."
    $label.AutoSize = $true
    $label.Location = New-Object System.Drawing.Point(10, 10)
    $form.Controls.Add($label)

    # Create a progress bar
    $ProgressBar = New-Object System.Windows.Forms.ProgressBar
    $ProgressBar.Minimum = 0
    $ProgressBar.Maximum = 100
    $ProgressBar.Step = 1
    $ProgressBar.Style = "Continuous"
    $ProgressBar.Location = New-Object System.Drawing.Point(10, 35)
    $ProgressBar.Size = New-Object System.Drawing.Size(280, 20)
    $form.Controls.Add($ProgressBar)

    # Show the form
    $form.Add_Shown({$form.Activate()})
    $form.Show()

    # Execute the selected options
    foreach ($Option in $SelectedOptions) {
        $Option.Invoke()
        $CurrentStep++
        $ProgressBar.Value = [int](100 * $CurrentStep / $TotalSteps)
    }

    # Close the progress bar window
    $form.Close()

    # Show the installation completed message
    ShowProgressWindow $logStrings
    
})

global:ConfigSLog "- Completed with Config Service 1.0"

#endregion

[void]$Form.ShowDialog()

Stop-Transcript