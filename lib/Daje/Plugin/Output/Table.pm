package Daje::Plugin::Output::Table;
use Mojo::Base  -signatures;

use Mojo::File;

our $VERSION = "0.01";

has 'config' ;
has 'file';
has 'sql';

sub save_file($self) {

    my $filename = $self->create_new_filename();
    open (my $fh, ">", $filename) or die "Could not open file '$filename";
    print $fh $sql;
    close $fh;

    return;
}

sub create_new_filename($self) {
    my $filename;
    try {
        $filename = $config->{PATH}->{sql_target_dir} . Mojo::File->new($self->file)->basename();
        $filename =~ s/json/sql/ig;
    } catch ($e) {
        die "create_new_filename failed '$e'";
    };

    return $filename;
}
1;