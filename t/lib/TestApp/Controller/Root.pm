package TestApp::Controller::Root;

use base 'Catalyst::Controller';

__PACKAGE__->config( namespace => '' );

sub index : Path('') {
    my ( $self, $c ) = @_;

    $c->res->body('No message.');
}

1;
