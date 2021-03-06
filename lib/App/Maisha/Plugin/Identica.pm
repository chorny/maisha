package App::Maisha::Plugin::Identica;

use strict;
use warnings;

our $VERSION = '0.13';

#----------------------------------------------------------------------------
# Library Modules

use base qw(App::Maisha::Plugin::Base);
use base qw(Class::Accessor::Fast);
use Net::Identica;

#----------------------------------------------------------------------------
# Accessors

__PACKAGE__->mk_accessors($_) for qw(api users);

#----------------------------------------------------------------------------
# Public API

sub login {
    my ($self,$user,$pass) = @_;
    my $api = Net::Identica->new(
        username    => $user,
        password    => $pass,
        source      => $self->{source},
        useragent   => $self->{useragent},
        clientname  => $self->{clientname},
        clientver   => $self->{clientver},
        clienturl   => $self->{clienturl}
    );

    warn "Unable to establish Identica API\n"   unless($api);
    return 0    unless($api);

    $self->api($api);
    print "...building user cache for Identica\n";
    $self->_build_users();
    return 1;
}

sub _build_users {
    my $self = shift;
    my %users;

    my $f = $self->api->friends();
    if($f && @$f)   { for(@$f) { next unless($_); $users{$_->{screen_name}} = 1 } }
    $f = $self->api->followers();
    if($f && @$f)   { for(@$f) { next unless($_); $users{$_->{screen_name}} = 1 } }

    $self->users(\%users);
}

sub api_update
{
    my $self = shift;
    $self->api->update(@_);
}

sub api_user
{
    my $self = shift;
    $self->api->show_user(@_);
}

sub api_user_timeline
{
    my $self = shift;
    $self->api->user_timeline(@_);
}

sub api_friends
{
    my $self = shift;
    $self->api->friends();
}

sub api_friends_timeline
{
    my $self = shift;
    $self->api->friends_timeline();
}

sub api_public_timeline
{
    my $self = shift;
    $self->api->public_timeline();
}

sub api_followers
{
    my $self = shift;
    $self->api->followers();
}

sub api_replies
{
    my $self = shift;
    $self->api->replies();
}

sub api_send_message
{
    my $self = shift;
    $self->api->new_direct_message(@_);
}

sub api_direct_messages_to
{
    my $self = shift;
    $self->api->direct_messages();
}

sub api_direct_messages_from
{
    my $self = shift;
    $self->api->sent_direct_messages();
}

1;

__END__

=head1 NAME

App::Maisha::Plugin::Identica - Maisha interface to Identi.ca

=head1 SYNOPSIS

   maisha
   maisha> use Identica
   use ok

=head1 DESCRIPTION

App::Maisha::Plugin::Identica is the gateway for Maisha to access the Identi.ca
API.

=head1 METHODS

=head2 Constructor

=over 4

=item * new

=back

=head2 Process Methods

=over 4

=item * login

Login to the service.

=back

=head2 API Methods

The API methods are used to interface to with the Identica API.

=over 4

=item * api_user

=item * api_user_timeline

=item * api_friends

=item * api_friends_timeline

=item * api_public_timeline

=item * api_followers

=item * api_update

=item * api_replies

=item * api_send_message

=item * api_direct_messages_to

=item * api_direct_messages_from

=back

=head1 SEE ALSO

For further information regarding the commands and configuration, please see
the 'maisha' script included with this distribution.

L<App::Maisha>

L<Net::Identica>

=head1 WEBSITES

=over 4

=item * Main Site: L<http://maisha.grango.org>
=item * Git Repo:  L<http://github.com/barbie/maisha/tree/master>
=item * RT Queue:  L<RT: http://rt.cpan.org/Public/Dist/Display.html?Name=App-Maisha>

=back

=head1 AUTHOR

  Copyright (c) 2009 Barbie <barbie@cpan.org> for Grango.org.

=head1 LICENSE

  This program is free software; you can redistribute it and/or modify it
  under the same terms as Perl itself.

  See http://www.perl.com/perl/misc/Artistic.html

=cut
