class Net::POP3::Message;

has $.pop;
has $.sid;
has $!size;
has $!uid;
has $!data;

method new(:$pop!, :$sid!, :$size, :$uid) {
    my $self = self.bless(:$sid, :$pop);
    $self._init($size, $uid);
    return $self;
}
method _init($size, $uid) {
    $!size = $size if $size;
    $!uid = $uid if $uid;
}

method size {
    unless $!size {
        my $response = $.pop.raw.list($.sid);
        if $response ~~ /^\+OK ' ' (\d+) ' ' (\d+)$/ {
            $!size = $1;
        }
    }
    return $!size;
}

method uid {
    unless $!uid {
        my $response = $.pop.raw.uidl($.sid);
        if $response ~~ /^\+OK ' ' (\d+) ' ' (.+)$/ {
            $!uid = $1;
        }
    }
    return $!uid;
}

method data {
    unless $!data {
        my $response = $.pop.raw.retr($.sid);
        if $response.substr(0,3) eq '+OK' {
            $response ~~ s/^\+OK <-[\r]>* \r\n//;
            $!data = $response;
        }
    }
    return $!data;
}

method delete {
    $.pop.raw.dele($.sid);
}
