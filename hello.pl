#!/usr/bin/perl

use Mojolicious::Lite -signatures;
# strict, warnings, utf8 & 5.16 are automatically enabled.

get '/' => sub ($c) {
    $c->render(text => 'Hello World!');
};

# /foo?user=marshall
get '/foo' => sub($c) {
    my $user = $c->param('user');
    $c->render(text => "Hello $user.");
};

# using stash and templates
get '/bar' => sub($c){
    $c->stash(one => 23);
    $c->render(template => 'magic', two => 24);
};

# HTTP features
get '/agent' => sub($c){
    my $host = $c->req->url->to_abs->host;
    my $ua = $c->req->headers->user_agent;
    $c->render(text => "Request by $ua reached $host.");
};
# echo the request body and sending a customer header with response
get '/echo' => sub($c){
    $c->res->headers->header('X-Bender' => 'Bite my shiny ass!');
    $c->render(data => $c->req->body);
};

# working with JSON
# modify the received json doc and return it
put '/reverse' => sub ($c){
    my $hash = $c->req->json;
    $hash->{message} = reverse $hash->{message}; #good luck to the values that were duplicated.
    $c->render(json => $hash);
};


# there are also built-in exception and not-found pages
get '/missing' => sub($c){
    $c->render(template => 'does_not_exist'); # seems there are no templates; getting an error for these
};

get '/dies' => sub { die 'Internal error' };



app->start;

__DATA__

@@ magic.html.ep
The magic numbers are <%= $one %> and <%= $two %>.