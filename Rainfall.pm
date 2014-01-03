package Rainfall { 

  # models 4 nearest neighbors to position i,j forall i,j
  my $adjacents = [ [ 0, -1], # left
                    [-1,  0], # top
                    [ 0,  1], # right
                    [+1,  0], # bottom
                  ];

  sub new { 
    my ($class, %attrs) = @_; 

    # initialize all elements of the matrix to cells O(N * M)
    for my $i ( 0 .. $#{$attrs{field}} ) {
      for my $j ( 0 .. $#{$attrs{field}->[$i]} ) {
        # create new Cell
        $attrs{field}->[$i]->[$j] =
          Cell->new(  x => $i, 
                      y => $j, 
                      elevation => $attrs{field}->[$i]->[$j],
          );
      }
    }

    # find sinks and set neighbors O(2 * N * M)
    my @sinks;
    for my $i ( 0 .. $#{$attrs{field}} ) {
      for my $cell ( @{ $attrs{field}->[$i] } ) {
        # get neighbors for this Cell
          my @neighbors; 
        NEIGHBORS:
          for my $adjacent ( @$adjacents ) {
            my ($xmod, $ymod) = ($i + $adjacent->[0], $cell->y + $adjacent->[1]);

            # x and y must be in the bounds of the matrix
            next NEIGHBORS 
              if $xmod >= $attrs{rows} || $ymod >= $attrs{cols} || $xmod < 0 || $ymod < 0;

            push @neighbors, 
              $attrs{field}->[$xmod]->[$ymod];
          } 
      
        # set neighbors 
        $cell->set_neighbors(@neighbors); 

        # determine sinks
        push @sinks, $cell
          if $cell->is_sink;
      }
    }

    # set sinks
    $attrs{sinks} = \@sinks;
    bless \%attrs, $class;
  }  

  # accessor methods
  sub field { 
    my $self = shift;
    return $self->{field};
  }

  sub cell {
    my ($self, $i, $j) = @_;

    return $self->field->[$i]->[$j];
  }

  sub rows {
    return shift->{rows};
  }

  sub cols {
    return shift->{cols};
  }

  sub sinks {
    return shift->{sinks};
  }

  # given an Array of Sinks, find the Basins in this field
  # O(n)
  sub basins {
    my ($self) = @_;

    my %basin;
    my $basin_marker = 'A';

    # determine how many cells eventually flow into this one
    for my $sink ( @{ $self->sinks } ) { 
      $basin{$basin_marker++} = $sink->basin_size;
    } 

    return %basin;
  }

  1;
} # end Rainfall
