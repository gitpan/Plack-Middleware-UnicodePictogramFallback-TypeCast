#!perl -w
use strict;
use Test::More;
use Plack::Test;

use HTTP::Request::Common;

use Plack::Middleware::UnicodePictogramFallback::TypeCast;

my $sun_unicode = "\xE2\x98\x80";
my $app = sub {
    [200, ['Content-Type' => 'text/html', 'Content-Length' => 16], ["<body>$sun_unicode</body>"]];
};

$app = Plack::Middleware::UnicodePictogramFallback::TypeCast->wrap($app,
    template => '<img src="/img/emoticon/%s.gif" />'
);

test_psgi $app, sub {
    my $cb = shift;

    my $res = $cb->(GET 'http://localhost/');
    is $res->code, 200;

    like $res->content, qr!emoticon/sun\.gif!;
};

done_testing;
