package Plack::App::Apache2FileManager;

use strict;
use warnings;

use Plack::Request;
use Plack::App::Apache2FileManager::Mocks;
use Apache2::FileManager;

my $document_root = '.';

our $R;
our $CONFIG;

*Apache2::FileManager::r = sub { return $R };

sub {
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
    }
