package Daje::Plugin::Database::Operations;
use Mojo::Base -signatures;

has 'dbh';

our $VERSION = '0.01';


sub save_hash($self, $file, $hash) {
    try {
        my $date = localtime();
        my $script = $self->save_script();
        my $sth = $self->dbh->prepare($script);
        $sth->execute($file, $hash, $date, $hash, $date);
    } catch ($e) {
        die "Save hash failed '$e";
    }
}

sub load_hash($self, $file_path_name) {
    my $hash;
    try {
        my $script = $self->select_script();
        my $sth = $self->dbh->prepare($script);
        $sth->execute($file_path_name);
        $hash = $sth->fetch();
    } catch ($e) {
        die "Could not load hash '$e";
    };

    return $hash;
}

sub select_script($self) {
    return qq{
        SELECT hash FROM file_hashes WHERE file = ?;
    };
}

sub save_script($self) {
    return qq{
        INSERT INTO file_hashes (file, hash, moddatetime)
            VALUES (?,?,?)
                ON CONFLICT (file)
            DO UPDATE set hash = ?, moddatetime = ?;
    };
}

1;
#################### pod generated by Pod::Autopod - keep this line to make pod updates possible ####################

=head1 NAME

Daje::Plugin::Database::Operations


=head1 REQUIRES

L<Mojo::Base> 


=head1 METHODS

=head2 load_hash($self,

 load_hash($self,();

=head2 save_hash($self,

 save_hash($self,();

=head2 save_script($self)

 save_script($self)();

=head2 select_script($self)

 select_script($self)();


=cut
