param (
    [string]$mavenPOMFile,
    [string]$options,
    [string]$goals,
    [string]$publishJUnitResults,   
    [string]$testResultsFiles, 
    [string]$jdkVersion,
    [string]$jdkArchitecture,
    [string]$sqAnalysisEnabled, #todo - rename the sq vars
    [string]$sqConnectedServiceName, 
    [string]$sqDbDetailsRequired,
    [string]$sqDbUrl,
	[string]$sqDbUsername,
	[string]$sqDbPassword)

Write-Verbose 'Entering Maven.ps1'
Write-Verbose "mavenPOMFile = $mavenPOMFile"
Write-Verbose "options = $options"
Write-Verbose "goals = $goals"
Write-Verbose "publishJUnitResults = $publishJUnitResults"
Write-Verbose "testResultsFiles = $testResultsFiles"
Write-Verbose "jdkVersion = $jdkVersion"
Write-Verbose "jdkArchitecture = $jdkArchitecture"

Write-Verbose -Verbose "sqAnalysisEnabled = $sqAnalysisEnabled"
Write-Verbose -Verbose "connectedServiceName = $sqConnectedServiceName"
Write-Verbose -Verbose "sqDbDetailsRequired = $sqDbDetailsRequired"
Write-Verbose -Verbose "dbUrl = $sqDbUrl"
Write-Verbose -Verbose "dbUsername = $sqDbUsername"
Write-Verbose -Verbose "dbPassword = $sqDbPassword"


#Verify Maven POM file is specified
if(!$mavenPOMFile)
{
    throw "Maven POM file is not specified"
}


. ./mavenHelper.ps1

$sqAnalysisEnabledBool = Convert-String $sqAnalysisEnabled Boolean

if ($sqAnalysisEnabledBool)
{
    $goals = $goals + " sonar:sonar"
    Write-Verbose -Verbose "sonar:sonar goal was added - the goals are now: $goals"

    $sqServiceEndpoint = GetEndpointData $sqConnectedServiceName
    $sqDbDetailsRequiredBool = Convert-String $sqDbDetailsRequired Boolean 

    if ($sqDbDetailsRequiredBool)
    {
        $sqArguments = CreateSonarQubeArgs $sqServiceEndpoint.Url $sqServiceEndpoint.Authorization.Parameters.UserName $sqServiceEndpoint.Authorization.Parameters.Password $sqDbUrl $sqDbUsername $sqDbPassword
    }
    else
    {
        # The platform caches the db details values so we force them to be empty
        $sqArguments = CreateSonarQubeArgs $sqServiceEndpoint.Url $sqServiceEndpoint.Authorization.Parameters.UserName $sqServiceEndpoint.Authorization.Parameters.Password "" "" ""
    }

    $options = $options + " " + $sqArguments
    Write-Verbose -Verbose "options = $options"
 }

 
# Import the Task.Internal dll that has all the cmdlets we need for Build
import-module "Microsoft.TeamFoundation.DistributedTask.Task.Internal"
import-module "Microsoft.TeamFoundation.DistributedTask.Task.Common"
import-module "Microsoft.TeamFoundation.DistributedTask.Task.TestResults"

if($jdkVersion -and $jdkVersion -ne "default")
{
    $jdkPath = Get-JavaDevelopmentKitPath -Version $jdkVersion -Arch $jdkArchitecture
    if (!$jdkPath) 
    {
        throw "Could not find JDK $jdkVersion $jdkArchitecture, please make sure the selected JDK is installed properly"
    }

    Write-Host "Setting JAVA_HOME to $jdkPath"
    $env:JAVA_HOME = $jdkPath
    Write-Verbose "JAVA_HOME set to $env:JAVA_HOME"
}

Write-Verbose "Running Maven..."
Invoke-Maven -MavenPomFile $mavenPOMFile -Options $options -Goals $goals

# Publish test results files
$publishJUnitResultsFromAntBuild = Convert-String $publishJUnitResults Boolean
if($publishJUnitResultsFromAntBuild)
{
   # check for JUnit test result files
    $matchingTestResultsFiles = Find-Files -SearchPattern $testResultsFiles
    if (!$matchingTestResultsFiles)
    {
        Write-Host "No JUnit test results files were found matching pattern '$testResultsFiles', so publishing JUnit test results is being skipped."
    }param (
    [string]$mavenPOMFile,
    [string]$options,
    [string]$goals,
    [string]$publishJUnitResults,   
    [string]$testResultsFiles, 
    [string]$jdkVersion,
    [string]$jdkArchitecture,
    [string]$sqAnalysisEnabled, #todo - rename the sq vars
    [string]$sqConnectedServiceName, 
    [string]$sqDbDetailsRequired,
    [string]$sqDbUrl,
	[string]$sqDbUsername,
	[string]$sqDbPassword)

Write-Verbose 'Entering Maven.ps1'
Write-Verbose "mavenPOMFile = $mavenPOMFile"
Write-Verbose "options = $options"
Write-Verbose "goals = $goals"
Write-Verbose "publishJUnitResults = $publishJUnitResults"
Write-Verbose "testResultsFiles = $testResultsFiles"
Write-Verbose "jdkVersion = $jdkVersion"
Write-Verbose "jdkArchitecture = $jdkArchitecture"

Write-Verbose -Verbose "sqAnalysisEnabled = $sqAnalysisEnabled"
Write-Verbose -Verbose "connectedServiceName = $sqConnectedServiceName"
Write-Verbose -Verbose "sqDbDetailsRequired = $sqDbDetailsRequired"
Write-Verbose -Verbose "dbUrl = $sqDbUrl"
Write-Verbose -Verbose "dbUsername = $sqDbUsername"
Write-Verbose -Verbose "dbPassword = $sqDbPassword"


#Verify Maven POM file is specified
if(!$mavenPOMFile)
{
    throw "Maven POM file is not specified"
}


. ./mavenHelper.ps1

$sqAnalysisEnabledBool = Convert-String $sqAnalysisEnabled Boolean

if ($sqAnalysisEnabledBool)
{
    $goals = $goals + " sonar:sonar"
    Write-Verbose -Verbose "sonar:sonar goal was added - the goals are now: $goals"

    $sqServiceEndpoint = GetEndpointData $sqConnectedServiceName
    $sqDbDetailsRequiredBool = Convert-String $sqDbDetailsRequired Boolean 

    if ($sqDbDetailsRequiredBool)
    {
        $sqArguments = CreateSonarQubeArgs $sqServiceEndpoint.Url $sqServiceEndpoint.Authorization.Parameters.UserName $sqServiceEndpoint.Authorization.Parameters.Password $sqDbUrl $sqDbUsername $sqDbPassword
    }
    else
    {
        # The platform caches the db details values so we force them to be empty
        $sqArguments = CreateSonarQubeArgs $sqServiceEndpoint.Url $sqServiceEndpoint.Authorization.Parameters.UserName $sqServiceEndpoint.Authorization.Parameters.Password "" "" ""
    }

    $options = $options + " " + $sqArguments
    Write-Verbose -Verbose "options = $options"
 }

 
# Import the Task.Internal dll that has all the cmdlets we need for Build
import-module "Microsoft.TeamFoundation.DistributedTask.Task.Internal"
import-module "Microsoft.TeamFoundation.DistributedTask.Task.Common"
import-module "Microsoft.TeamFoundation.DistributedTask.Task.TestResults"

if($jdkVersion -and $jdkVersion -ne "default")
{
    $jdkPath = Get-JavaDevelopmentKitPath -Version $jdkVersion -Arch $jdkArchitecture
    if (!$jdkPath) 
    {
        throw "Could not find JDK $jdkVersion $jdkArchitecture, please make sure the selected JDK is installed properly"
    }

    Write-Host "Setting JAVA_HOME to $jdkPath"
    $env:JAVA_HOME = $jdkPath
    Write-Verbose "JAVA_HOME set to $env:JAVA_HOME"
}

Write-Verbose "Running Maven..."
Invoke-Maven -MavenPomFile $mavenPOMFile -Options $options -Goals $goals

# Publish test results files
$publishJUnitResultsFromAntBuild = Convert-String $publishJUnitResults Boolean
if($publishJUnitResultsFromAntBuild)
{
   # check for JUnit test result files
    $matchingTestResultsFiles = Find-Files -SearchPattern $testResultsFiles
    if (!$matchingTestResultsFiles)
    {
        Write-Host "No JUnit test results files were found matching pattern '$testResultsFiles', so publishing JUnit test results is being skipped."
    }
    else
    {
        Write-Verbose "Calling Publish-TestResults"
        Publish-TestResults -TestRunner "JUnit" -TestResultsFiles $matchingTestResultsFiles -Context $distributedTaskContext
    }    
}
else
{
    Write-Verbose "Option to publish JUnit Test results produced by Maven build was not selected and is being skipped."
}


Write-Verbose "Leaving script Maven.ps1"





    else
    {
        Write-Verbose "Calling Publish-TestResults"
        Publish-TestResults -TestRunner "JUnit" -TestResultsFiles $matchingTestResultsFiles -Context $distributedTaskContext
    }    
}
else
{
    Write-Verbose "Option to publish JUnit Test results produced by Maven build was not selected and is being skipped."
}


Write-Verbose "Leaving script Maven.ps1"




