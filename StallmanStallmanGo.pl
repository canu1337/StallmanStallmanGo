#!/usr/bin/env perl
use v5.10;
use warnings;
use Dancer;
use URI::Escape qw(uri_escape_utf8);
set server => 'localhost';
set daemon => false;
# This is all the search engine does
get '/search' => sub {
    given (param("q")) {
        when (/^(?:!(?:ducky)?\s+|\\)(.*)/) { redirect 'http://www.google.com/search?btnI=1&q=' . uri_escape_utf8 $1 }
	when (/^(!.*)/)                     { redirect 'https://duckduckgo.com/?q='              . uri_escape_utf8 $_ }
        default                             { redirect 'https://startpage.com/do/search?query='        . uri_escape_utf8 $_ }
    }
};

# Irrelevant crap nobody cares about
get '/favicon.ico' => sub {
    # Steal rms.sexy's favicon.ico
    redirect 'https://rms.sexy/favicon.ico';
};

get '/opensearch_desc.xml' => sub {
    send_file './opensearch_desc.xml';
};

get '/*' => sub {
    redirect '/';
};

get '/' => sub {
    send_file './index.html';
};

get '/style.css' => sub {
  send_file './style.css';
};

get '/logo.png' => sub {
  send_file './logo.png';
};
dance;

__END__

=encoding utf8

=head1 NAME

StallmanStallmanGo - A DuckDuckGo-like search engine with saner defaults and no Google tracking.

=head1 DESCRIPTION

=over

=item *

By default search queries will be sent to L<Startpage|https://startpage.com>,
not DuckDuckGo.

=item *

The L<!bang syntax|http://duckduckgo.com/bang.html> is handled by
DuckDuckGo, except C<!>. Which will get you the first Google result,
instead of the first DuckDuckGo result.

=back

That's it!

=head1 AUTHOR

Ævar Arnfjörð Bjarmason <avarab@gmail.com>

=cut
