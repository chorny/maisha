use 5.006;
use ExtUtils::MakeMaker;
WriteMakefile1(
    LICENSE => 'perl',
    MIN_PERL_VERSION => '5.006',
    META_MERGE => {
        resources => {
            repository => 'http://github.com/barbie/maisha',
        },
    },
    BUILD_REQUIRES => {
        'Test::More'            => '0.47',  # testing only
    },
    NAME                => 'App::Maisha',
    VERSION_FROM        => 'lib/App/Maisha.pm',
    PREREQ_PM           => {
        'Class::Accessor::Fast' => '0',
        'Config::Any'           => '0',
        'Module::Pluggable'     => '2.7',
        'Net::Identica'         => '2.05',
        'Net::Twitter'          => '2.06',
        'Term::Shell'           => '0',
        'Text::Wrap'            => '0',

        'File::HomeDir'         => '0',     # used by maisha script
        'FindBin'               => '0',     # used by maisha script
        'Getopt::Long'          => '0',     # used by maisha script
        'Pod::Usage'            => '0',     # used by maisha script
    },
    NO_META			    => 1,
    EXE_FILES           => ['script/maisha'],

    ABSTRACT_FROM => 'A command line social micro-blog networking tool.',
    AUTHOR => 'Barbie <barbie@cpan.org>',
);

sub WriteMakefile1 {  #Written by Alexandr Ciornii, version 0.21. Added by eumm-upgrade.
    my %params=@_;
    my $eumm_version=$ExtUtils::MakeMaker::VERSION;
    $eumm_version=eval $eumm_version;
    die "EXTRA_META is deprecated" if exists $params{EXTRA_META};
    die "License not specified" if not exists $params{LICENSE};
    if ($params{BUILD_REQUIRES} and $eumm_version < 6.5503) {
        #EUMM 6.5502 has problems with BUILD_REQUIRES
        $params{PREREQ_PM}={ %{$params{PREREQ_PM} || {}} , %{$params{BUILD_REQUIRES}} };
        delete $params{BUILD_REQUIRES};
    }
    delete $params{CONFIGURE_REQUIRES} if $eumm_version < 6.52;
    delete $params{MIN_PERL_VERSION} if $eumm_version < 6.48;
    delete $params{META_MERGE} if $eumm_version < 6.46;
    delete $params{META_ADD} if $eumm_version < 6.46;
    delete $params{LICENSE} if $eumm_version < 6.31;
    delete $params{AUTHOR} if $] < 5.005;
    delete $params{ABSTRACT_FROM} if $] < 5.005;
    delete $params{BINARY_LOCATION} if $] < 5.005;

    WriteMakefile(%params);
}

