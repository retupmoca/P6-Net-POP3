P6-Net-POP3
===========

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


Currently only a raw interface is provided. A simple interface is coming soon.

SSL/STARTTLS are not currently supported.
