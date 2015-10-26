# `subl` alias for Sublime Text 3
Set-Alias subl "C:\Program Files\Sublime Text 3\subl.exe";

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

# `deploy-beta` command to quick copy some file to beta.nannin.ga using PuTTY's pscp
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
