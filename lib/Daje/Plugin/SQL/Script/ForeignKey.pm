package Daje::Plugin::SQL::Script::ForeignKey;
use Mojo::Base 'Daje::Plugin::SQL::Base::Common', -signatures;

has 'tablename';
has 'templates';
has 'created';

our $VERSION = "0.01";

sub create_foreign_keys($self) {
    my $fkeys = '';
    $self->templates->{template_fkey} = "";
    $self->templates->{template_ind} = "";
    try {
        my $fields = $self->json->{fields};
        foreach my $key (sort keys %{$fields}) {
            if (index($key,'_fkey') > -1) {
                my ($template_fkey,$template_ind) = $self->get_templates($key);
                my $referenced_table = substr($key,0,index($key,'_fkey'));
                $self->templates->{template_fkey} .= ",  " . $template_fkey;
                $self->templates->{template_ind} .= "  " . $template_ind;
                $self->created = 1;
            }
        }
    } catch ($e) {
        die "Foreign keys could not be created $e";
    };
    return;
}

sub get_templates($self, $key) {
    my $referenced_table = substr($key,0,index($key,'_fkey'));
    my $template_fkey = $self->template->get_data_section('foreign_key');
    $template_fkey =~ s/<<referenced_table>>/$referenced_table/ig;
    my $template_ind = $self->template->get_data_section('index');
    $template_ind =~ s/<<type>>//ig;
    $template_ind =~ s/<<table>>/$tablename/ig;
    $template_ind =~ s/<<field_names>>/$key/ig;
    $template_ind =~ s/<<fields>>/$key/ig;
    $created = 1;

    return ($template_fkey,$template_ind);
}
1;