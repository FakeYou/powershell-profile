# common aliases
Set-Alias subl "C:\Program Files\Sublime Text 3\subl.exe";
Set-Alias putty "C:\Program Files\Putty\putty.exe";
Set-alias reactotron ".\node_modules\.bin\reactotron";

# shortcuts for folder traversal
function ..() { cd ..; }
function ...() { cd ..\..; }
function ....() { cd ..\..\..; }

# `touch` command to quickly create new (empty) files
function touch { 
    New-Item -ItemType file $args[0];
}

# `whois` command to get dns/whois data about any domain
function whois {
    if($args.Length -eq 0) {
        echo "Usage: whois url";
        return;
    }

    $web = New-WebServiceProxy "http://www.webservicex.net/whois.asmx?WSDL";
    echo $web.GetWhoIs($args[0]);
}

# `docker-start` command to quickly start a docker-machine and bind it to the current shell
function docker-start($machine = 'default') {
    docker-machine start $machine;
    docker-machine env $machine --shell=powershell | Invoke-Expression;
}

# `docker-clean` command removes all docker containers
function docker-clean() {
    docker rm -f $(docker ps -aq);
}

# `deploy-test` command to quick copy some file to beta.nannin.ga using PuTTY's pscp
function deploy-beta() {
    Param(
        [Parameter(Mandatory=$True)][string]$path,
        [Parameter(Mandatory=$True)][string]$destination,
        [Parameter(Mandatory=$True)][Security.SecureString]$securePassword
    );

    # convert secureString to plaintext
    $passwordPointer = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($securePassword)
    $password = [Runtime.InteropServices.Marshal]::PtrToStringAuto($passwordPointer)

    write-host "Moving " -nonewline
    write-host "$path" -foreground green -nonewline
    write-host " to beta.nannin.ga/$destination"

    C:\Tools\Putty\pscp.exe -scp -r -pw $password $path andre@nannin.ga:/var/www/beta.nannin.ga/public/$destination;
}

# `adb-wifi` connect to a android device over wifi
function adb-wifi($ip) {
    adb.exe tcpip 5555;
    adb.exe connect $ip;
}

# `adb-react-native` start adb server for react-native development
function adb-react-native() {
    adb.exe start-server;
    adb.exe reverse tcp:8081 tcp:8081;
}

# `adb-log-react-native` show android logs for react-native
function adb-log-react-native() {
    adb.exe logcat *:S ReactNative:V ReactNativeJS:V;
}

# `rns` start react-native server
function rns() {
    react-native start;
}


# `shell` start a new powershell instance at specified path (defaults to current path)
function shell() {
    [CmdletBinding()]
    Param (
        [Parameter()][AllowNull()][string] $path
    );

    if ($path -eq "" -and $path -eq [String]::Empty) {
        $path = pwd;
    }

    $absolutePath = Resolve-Path $path;

    Start-Process powershell -ArgumentList "-noexit -command Set-Location '$absolutePath'";
}