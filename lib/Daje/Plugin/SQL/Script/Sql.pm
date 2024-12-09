package Daje::Plugin::SQL::Script::Sql;
use Mojo::Base 'Daje::Plugin::SQL::Base::Common', -signatures;

use Syntax::Keyword::Match qw(match);

has 'tablename';

our $VERSION = "0.01";

sub create_sql($self) {
    my $sql = "";
    my $json = $self->json->{sql};
    my $length = scalar @{$json};
    for (my $i = 0; $i < $length; $i++) {
        my $type = $self->template->get_section(@{$json}[$i]->{type});
        my $template = $self->template->get_section($type);

        match ($type : eq) {
            case('insert') {
                $template =~ s/<<tablename>>/$tablename/ig;
                $template =~ s/<<fields>>/@{$json}[$i]->{fields}/ig;
                $template =~ s/<<values>>/@{$json}[$i]->{values}/ig;
            }
            default { $template = "" }
        }
        $sql .= $template . '\n';
    }
    $self->set_sql($sql);
    return;
}
1;