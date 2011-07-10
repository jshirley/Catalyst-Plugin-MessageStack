#!perl

use strict;

use FindBin qw($Bin);
use lib "$Bin/lib";

use Test::More;
use Catalyst::Test 'TestApp';
use Message::Stack;
use Message::Stack::Message;

my $c = TestApp->new;

is($c->reset_messages, 0, 'Clear the (non-existent) stack');
is($c->has_messages, 0, 'No messages in the stack');

$c->message({
    scope => 'some_scope',
    message => 'this is a message',
    type => 'info',
    subject => 'verb'
});
$c->message({
    scope => 'some_scope',
    message => 'this is second message',
    type => 'error',
    subject => 'ruler'
});
my $msg = Message::Stack::Message->new({
    scope => 'some_other_scope',
    id => 'this is a third message',
    level => 'info',
    subject => 'ruler'
});
$c->message($msg);
my $msg2 = Message::Stack::Message->new({
    scope => 'some_other_scope',
    id => 'this is a fourth message',
    level => 'error',
    subject => 'verb'
});
$c->message($msg2);


isa_ok($c->message, 'Message::Stack', 'Returns a Message::Stack');
is($c->has_messages, 4, 'Four messages in the stack');

is($c->has_messages('some_other_scope'), 2, 'some_other_scope gets two messages');
is($c->reset_messages('some_other_scope'), 2, 'resetting the scope gets two messages');
is($c->reset_messages, 2, 'resetting the whole stack gets two messages');

is($c->has_messages, 0, 'No messages left in the stack');

$c->message('This is the simple message interface');
is($c->has_messages, 1, 'The simple interface adds to the stack');

use Data::Dump;
ddx($c->config);
$c->config->{'Plugin::Message'}->{stash_key} = "foo";
ddx($c->config);

done_testing;
