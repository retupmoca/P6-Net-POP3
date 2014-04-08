class Net::POP3;

use Net::POP3::Raw;

method new(:$server!, :$port = 110, :$raw, :$debug, :$socket-class = IO::Socket::INET){
    my role debug-connection {
        method send($string){
            my $tmpline = $string.substr(0, *-2);
            note '==> '~$tmpline;
            nextwith($string);
        }
        method get() {
            my $line = callwith();
            note '<== '~$line;
            return $line;
        }
    };
    my $self = self.bless();
    if $raw {
        $self does Net::POP3::Raw;
        if $debug {
            $self.conn = $socket-class.new(:host($server), :$port) but debug-connection;
        } else {
            $self.conn = $socket-class.new(:host($server), :$port);
        }
        $self.conn.input-line-separator = "\r\n";
    } else {
        die "Simple mode NYI";
    }
    return $self;
}
