use strict;
use warnings; 

package Cell { 
  use List::Util qw(reduce);
  use List::MoreUtils qw(all);

  sub new { 
    my ($class, %attrs) = @_; 

    $attrs{sink}    ||= 0;
    $attrs{neighbors} = [];

    bless \%attrs, $class;
  }  

  # accessor/setter methods
  sub elevation { 
    return shift->{elevation};
  }

  sub x {
    return shift->{x};
  }

  sub y {
    return shift->{y};
  }

  sub neighbors {
    return @{ shift->{neighbors} };
  }

  sub lowest_neighbor { 
    my ($self) = @_;

    return reduce { 
              $a->elevation < $b->elevation ? $a : 
                                              $b 
           } $self->neighbors;
  }

  sub set_neighbors {
    my ($self, @neighbors) = @_;

    $self->{neighbors} = \@neighbors;
  }

  sub is_sink {
    my ($self) = @_;
    return 1 if $self->{sink}; # caching

    my $min = $self->elevation;
    for my $neighbor ( $self->neighbors ) {
      $min = ($min, $neighbor->elevation)[$min > $neighbor->elevation];
    }

    $self->{sink} = $min == $self->elevation;
    return $self->{sink};
  }

  sub xy {
    my $self = shift;
    return ($self->x, $self->y);
  }

  # recursively find the number of Cells in the Basin 
  # attached to the given Cell
  sub basin_size { 
    my ($self) = @_;

    my $size = 1;
    for my $neighbor ( $self->get_flowing_neighbors ) {
      $size += $neighbor->basin_size;
    }

    return $size;
  }

  # returns the neighbors that flow into this Cell
  sub get_flowing_neighbors {
    my ($self) = @_;

    # the neighbors of this cell flow into it 
    # iff this cell's elevation is less than their neighbors
    # AND the neighboring cell has no other neighbors (that are not this cell) that have a lower (or equal) elevation 
    return  grep {  
              !$_->is_sink && $self == $_->lowest_neighbor
            } $self->neighbors;
  }

  1;
} # end Cell 
