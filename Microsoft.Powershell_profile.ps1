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