#!perl

use strict;

use FindBin qw($Bin);
use lib "$Bin/lib";

use Test::More;
use Catalyst::Test 'TestApp';
use Test::WWW::Mechanize::Catalyst;
use HTTP::Request::Common;
use URI;

my $c = Test::WWW::Mechanize::Catalyst->new(catalyst_app => 'TestApp');

my $content = $c->get_ok('/create');
$c->content_contains('did not create message', 'Correct body for GET /create');
$content = $c->get_ok('/read');
$c->content_contains('no messages', 'Correct body for GET /read before POST');

$content = $c->post('/create', { message => 'This is a message from a POST, inside the unit test' });
$c->content_contains('This is a message from a POST, inside the unit test');

$content = $c->post('/create', {
    message => 'This is a message from a POST, for the multiple method',
    multiple => 1
});
$c->content_contains('This is a message from a POST, for the multiple methodAn additional message from the multiple method');

done_testing;
