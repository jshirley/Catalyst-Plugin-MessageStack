#!perl

use strict;

use Test::More;
use Catalyst::Test 'TestApp';

my $content;
my $response;

$content  = get('index');
is( $content, 'No message.', 'correct body' );

#$response = post('index'); # isa redirect

#$content = get('index');
#like($content, 'A message from a POST', 'correct messaging');

done_testing;
