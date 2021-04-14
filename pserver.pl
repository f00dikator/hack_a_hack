#!/usr/bin/perl

# John Lampe ... dmitry.chan@gmail.com , john.lampe@gmail.com

$|=1;

use Socket;

sub REAPER {
    1 until (-1 == waitpid(-1, WNOHANG));
    $SIG{CHLD} = \&REAPER;
}

$SIG{CHLD} = \&REAPER;

$incfile = shift || die "Need the .cnf file\n";

require("$incfile");

@fuzzrray = @startvalidproto;

$req = calculate_req();

foreach $arg (@ARGV)
{
    if ($arg eq "-sql")
    {
        @goofy = (";", "--", "\/*", "#", "'", '"');
    }
    if ($arg eq "-xss")
    {
        @goofy = ("\<", "\>", "'", '"');
    }
}

if ($udp) {
    do_udp();
    exit(0);
}


$port = getservbyname ($port, 'tcp') if $port =~ /^\D/;

die "No port. $!\n" unless $port;


socket(soc, PF_INET, SOCK_STREAM, 0 ) ||  die "socket failed on $port. $!\n";

setsockopt (soc, SOL_SOCKET, SO_REUSEADDR, pack('l', 1)) ||  die "setsockopt failed on $port. $!\n";

bind (soc, sockaddr_in($port, INADDR_ANY)) ||  die "can't bind to $port. $!\n";

listen (soc, SOMAXCONN) || die "can't listen on $port. $!\n";

print "Listening on Port $port\n";

while ($cli = accept(client,soc) ) {
        $sleepycounter=0;
        next if $pid = fork;
        die "\n\nERROR: frikkin fork on $port. $!\n\n" unless defined $pid;
        close(soc);
         $blastcount=0;
         $blastsize = length($req);
         while (defined(client))
         {
            $blastcount++;
            $total = $blastcount * $blastsize;
            if ($blastcount > 1)
            {
                $req = calculate_req();
                if ( ($sleepytime == 1) && ($sleepycounter == 0) )
                {
                        sleep(2);
                        $sleepycounter++;
                }
                $blast = send (client, $req, 0);
                print "\[$blastcount\]:  $total bytes -> $port \n";
            }
        }
} continue {
        close(client);
}



sub do_udp {
    use IO::Socket;
    $server = IO::Socket::INET->new(LocalPort => $port,
                                    Proto => "udp") || die "\n\nERROR: Can't serve udp on $port. $!\n\n";
    $blastcount=0;
    $blastsize = length($req);
    while ($server->recv($datagram, 64))
    {
        $blastcount++;
        $total = $blastcount * $blastsize;
        $server->send($req);
        print "\[$blastcount\]:  $total bytes -> $port \n";
    }
}



sub calculate_req
{
        # if @goofy defined in cnf file, then use it
        if ($#goofy <= 0)
        {
                @goofy = qw(< & ' " >);
        }
        $index = $#goofy;
        @timerray = localtime;
        $seconds = @timerray[0];
        $seconds++;
        $entropy = $seconds * 3;
        $mcount = 0;

        for ($zztop=0; length($fuzzrray[$zztop]) >= 1; $zztop++)
        {
            if ($fuzzrray[$zztop] =~ /FUZZ/)
            {
                        $insert = "";
                        for ($ff=0; $ff < $entropy; $ff++)
                        {
                                $span = 300;
                                $random = int(rand($span));
                                $insert .= $goofy[($entropy + $mcount + $random) % $index ];
                                $mcount++;
                        }
                        $myreq = $myreq . $insert;
            } else {
                $myreq = $myreq . $fuzzrray[$zztop];
            }
        }

        return ($myreq);
}
