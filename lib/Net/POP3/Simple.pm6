role Net::POP3::Simple;

use Net::POP3::Message;

has $.raw is rw;

method start {
    $.raw = self.new(:server($.server), :port($.port), :raw, :debug($.debug), :socket-class($.socket-class));
    my $greeting = $.raw.get-response;
}

method auth($username, $password) {
    try {
        return $.raw.apop-login($username, $password);
    }
    if $! {
        my $response = $.raw.user($username);
        unless $response.substr(0,3) eq '+OK' {
            return $response;
        }
        return $.raw.pass($password);
    }
}

method message-count() {
    my $stat = $.raw.stat;
    if $stat ~~ /^\+OK ' ' (\d+) ' ' (\d+) $/ {
        return $0;
    }
}

method get-messages() {
    my $list = $.raw.list;
    unless $list.substr(0,3) eq '+OK' {
        return $list;
    }

    my @return;

    my @messages = $list.split("\r\n");
    @messages = @messages[1..*]; # strip the +OK
    for @messages -> $msg-line {
        my @parts = $msg-line.split(' ');
        my $size = @parts[1];
        my $sid = @parts[0];

        @return.push(Net::POP3::Message.new(sid  => $sid,
                                            size => $size,
                                            pop  => self));
    }

    return @return;
}

multi method get-message(:$uid!) {
    die "NYI";
}

multi method get-message(:$sid!) {
    return Net::POP3::Message.new(sid => $sid, pop => self);
}

method quit {
    $.raw.quit;
    $.raw.conn.close;
    return True;
}
