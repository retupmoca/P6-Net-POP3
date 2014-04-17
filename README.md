P6-Net-POP3
===========

    ####
    # raw interface
    ####
    my $pop = Net::POP3.new(:server("your.server.here"), :port(110), :debug, :raw);
    $pop.get-response # +OK
    
    $pop.apop-login("username", "password");
    # or (less secure)
    $pop.user("username");
    $pop.pass("password");

    my $message-list = $pop.list; # +OK 2 messages\r\n1 120\r\n...
    say $pop.retr(1); # +OK \r\nFrom:...
    $pop.dele(1);
    $pop.quit;

    ####
    # simple interface
    ####
    my $pop = Net::POP3.new(:server("your.server.here"), :port(110), :debug);
    $pop.auth("username", "password"); # tries apop, then falls back to user/pass
    my $count = $pop.message-count;
    my @messages = $pop.get-messages;
    for @messages {
        my $unique-id = .uid;
        my $raw-data = .data;
        my $email-mime = .mime; # returns Email::MIME object
                                # (requires Email::MIME installed to work)
        .delete;
    }
    $pop.quit;

SSL/STARTTLS are not currently supported.
