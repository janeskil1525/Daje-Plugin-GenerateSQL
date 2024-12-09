package Daje::Plugin::GenerateSQL;
use Mojo::Base -signatures;

use Daje::Plugin::Input::ConfigManager;
use Daje::Tools::Filechanged;
use Daje::Plugin::SQL::Manager;
use Daje::Plugin::Output::Table;
use Config::Tiny;

our $VERSION = "0.01";

has 'config_path';
has 'config_manager';

sub process () {

    $self->_load_config();
    my $files_list = $self->_load_file_list();
    my $length = scalar @{$files_list};
    for (my $i = 0; $i < $length; $i++) {
        if ($self->_process_sql(@{$files_list}[$i])) {
            $config_manager->save_new_hash(@{$files_list}[$i]);
        }
    }

    return;
}

sub _process_sql($file) {
    my $sql = "";
    try {
        my $table = $self->_load_table($file);
        $table->generate_table();
        $sql = $table->sql();
    } catch ($e) {
        die "Create sql failed '$e'";
    };

    try {
        Daje::Generate::Output::Sql::SqlManager->new(
            config => $self->config,
            file   => $file,
            sql    => $sql,
        )->save_file();
    } catch ($e) {
        die "Could not create output '$e'";
    };

    return 1;
}

sub _load_table($file) {

    my $json = $config_manager->load_json($file);
    my $template = $self->_load_templates(
        'Daje::Generate::Templates::Sql',
        "table,foreign_key,index,section,file"
    );
    my $table;
    try {
        $table = Daje::Generate::Sql::SqlManager->new(
            template => $template,
            json     => $json,
        );
    } catch ($e) {
        die "process_sql failed '$e";
    };

    return $table;
}



sub _load_file_list() {

    try {
        $config_manager = Daje::Generate::Input::Sql::ConfigManager->new(
            source_path => $self->config->{PATH}->{sql_source_dir},
            filetype    => '*.json'
        );
        $config_manager->load_changed_files();
    } catch ($e) {
        die "could not load changed files '$e";
    };

    return $config_manager->changed_files();
}



1;
__END__

=encoding utf-8

=head1 NAME

Daje::Plugin::GenerateSQL - It's new $module

=head1 SYNOPSIS

    use Daje::Plugin::GenerateSQL;

=head1 DESCRIPTION

Daje::Plugin::GenerateSQL is ...

=head1 LICENSE

Copyright (C) janeskil1525.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

janeskil1525 E<lt>janeskil1525@gmail.comE<gt>

=cut

