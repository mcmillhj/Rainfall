#!/usr/bin/perl
use strict; 
use warnings; 

use Cell;
use Rainfall;

{ # Tests
  use Test::More tests => 4; 

  { # 3x3 field 
    my $r = Rainfall->new( rows  => 3,
                           cols  => 3,
                           field => [ [1, 5, 2], 
                                      [2, 4, 7], 
                                      [3, 6, 9] ]);

    my %basin = $r->basins;
    is_deeply( 
        [sort { $b <=> $a } values %basin],
        [7, 2],
        'Correctly divided 3x3 field into 2 basins'
    );
  }

  { # 1x1 field
    my $r = Rainfall->new( rows  => 1,
                           cols  => 1,
                           field => [ [1] ]);

    my %basin = $r->basins;
    is_deeply( 
        [sort { $b <=> $a } values %basin],
        [1],
        'Correctly divided 1v1 field into 1 basin'
    );
  }

  { # 5x5 field
    my $r = Rainfall->new( rows  => 5,
                           cols  => 5,
                           field => [ [1, 0, 2, 5, 8],
                                      [2, 3, 4, 7, 9],
                                      [3, 5, 7, 8, 9],
                                      [1, 2, 5, 4, 3],
                                      [3, 3, 5, 2, 1] ]);

    my %basin = $r->basins;
    is_deeply( 
        [sort { $b <=> $a } values %basin],
        [11, 7, 7],
        'Correctly divided 5v5 field into 3 basins'
    );
  }

  { # Test 4x4 field
    my $r = Rainfall->new( rows  => 4,
                           cols  => 4,
                           field => [ [0, 2, 1, 3],
                                      [2, 1, 0, 4],
                                      [3, 3, 3, 3],
                                      [5, 5, 2, 1] ]);

    my %basin = $r->basins;
    is_deeply( 
        [sort { $b <=> $a } values %basin],
        [7, 5, 4],
        'Correctly divided 4v4 field into 3 basins'
    );
  }
}
