package Daje::Plugin::SQL::Script::Index;
use Mojo::Base 'Daje::Plugin::SQL::Base::Common', -signatures;

has 'tablename';

our $VERSION = "0.01";

sub create_index($self) {
    my $sql = "";
    my $json = $self->json->{index};
    my $length = scalar @{$json};
    for (my $i = 0; $i < $length; $i++) {
        my $template = $self->template->get_data_section('index');
        $template =~ s/<<table>>/$tablename/ig;
        $template =~ s/<<type>>/@{$json}[$i]->{type}/ig;
        $template =~ s/<<fields>>/@{$json}[$i]->{fields}/ig;
        @{$json}[$i]->{fields} =~ s/,/_/ig;
        $template =~ s/<<field_names>>/@{$json}[$i]->{fields}/ig;
        $sql .= $template . "";
    }
    $self->set_sql($sql);
    return;
}
1;