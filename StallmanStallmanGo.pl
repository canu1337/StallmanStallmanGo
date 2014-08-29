#!/usr/bin/env perl
use v5.10;
use warnings;
use Dancer;
use URI::Escape qw(uri_escape_utf8);
set server => 'localhost';
set daemon => true;
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
    <<"MAIN_PAGE";
<!DOCTYPE html>
<html>
  <head>
    <link rel="search" type="application/opensearchdescription+xml" href="/opensearch_desc.xml" title="StallmanStallmanGo" />
    <meta charset="UTF-8" />
    <title>StallmanStallmanGo - Freedums and bangs</title>
  </head>
  <body>
    <h1>StallmanStallmanGo</h1>
    <form name="search" method="GET" action="/search">
      <input type="text" autocomplete="off" name="q" autofocus tabindex="1" />
      <button title="GNU/Go!">Search</button>
    </form>
    <h1><a href="https://gist.github.com/Difegue/078df8f03135465e4238">Source code and documentation</h1></a>
  </body>
</html>
MAIN_PAGE
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
