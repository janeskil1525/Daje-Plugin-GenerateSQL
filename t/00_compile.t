use strict;
use Test::More 0.98;

use_ok $_ for qw(
    Daje::Plugin::GenerateSQL
    Daje::Plugin::SQL::Base::Common
    Daje::Plugin::SQL::Manager
    Daje::Plugin::SQL::Script::Fields
    Daje::Plugin::SQL::Script::Index
    Daje::Plugin::SQL::Script::ForeignKey
    Daje::Plugin::SQL::Script::Sql
    Daje::Plugin::Output::Table
    Daje::Plugin::Input::ConfigManager
);

done_testing;

