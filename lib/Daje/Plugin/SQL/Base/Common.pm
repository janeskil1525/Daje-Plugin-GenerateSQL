package Daje::Plugin::SQL::Base::Common;
use Mojo::Base -signatures;

has 'json';
has 'template';
has 'sql';
has 'index';
has 'version';

our $VERSION = "0.01";

method shift_section ($self, $array) {
    my $result = {};
    my $test = ref $array;
    if (ref $array eq 'ARRAY') {
        $result = shift(@{$array});
    }
    return $result;
}
method set_sql($self, $sqlin) {
    $self->sql($sqlin);
}
1;