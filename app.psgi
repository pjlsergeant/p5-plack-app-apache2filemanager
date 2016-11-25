package Plack::App::Apache2FileManager;

use strict;
use warnings;

use Plack::Request;
use Plack::App::Apache2FileManager::Mocks;
use Apache2::FileManager;
use Plack::Builder;

my $document_root = '/Users/pjlsergeant/dev/p5-plack-app-apache2filemanager';

our $R;
our $CONFIG;

*Apache2::FileManager::r = sub { return $R };

my $app = sub {
    my $env = shift;
    my $req = Plack::Request->new($env);

    local $R = Plack::App::Apache2FileManager::Mocks->new(
        {   request       => $req,
            document_root => $document_root
        }
    );
    local $CONFIG = {};

    Apache2::FileManager->handler();

    return $R->response->finalize;
};

builder {
    enable "Plack::Middleware::Static",
        path => qr{^/.+},
        root => $document_root;
    $app;
}
