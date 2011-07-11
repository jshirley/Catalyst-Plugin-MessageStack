package TestApp::Controller::Root;

use base 'Catalyst::Controller';

__PACKAGE__->config( namespace => '' );

sub index : Path('') {
    my ( $self, $c ) = @_;

    $c->res->body('No message.');
}

sub create : Local {
    my $self = shift;
    my $c = shift;

    if($c->req->method eq 'POST') {
        my $data = $c->req->params;
        my $message = $data->{message} || 'A simple default message';
        $c->message($message);
        if($data->{multiple}) {
            $c->res->redirect($c->uri_for('/multiple'));
        } else {
            $c->res->redirect($c->uri_for('/read'));
        }
    }

    $c->res->body('did not create message');
}

sub multiple : Local {
    my $self = shift;
    my $c = shift;

    my $message = 'An additional message from the multiple method';
    $c->message($message);
    $c->res->redirect($c->uri_for('/read'));
}

sub read : Local {
    my $self = shift;
    my $c = shift;

    my $body;

    if($c->has_messages) {
        my $stack = $c->message;
        my $msgs = $stack->messages;
        foreach my $msg (@{$msgs}) {
            $body .= $msg->msgid;
        }
    } else {
        $body = 'no messages';
    }
    $c->res->body($body);
}

1;
