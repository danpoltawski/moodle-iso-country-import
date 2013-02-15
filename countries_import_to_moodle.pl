#!/usr/bin/perl -w
# Script to import ISO country names and import into Moodle langfile.
#
# License:   http://www.gnu.org/copyleft/gpl.html GNU GPL v3 or later
# Copyright: 2013 Dan Poltawski <dan@moodle.com>
#
# Takes the country codes/official names from:
# http://www.iso.org/iso/home/standards/country_codes/country_names_and_code_elements_txt.htm
# In stdin, and outputs them them into the Moodle langfile format
#
# e.g. wget http://www.iso.org/iso/home/standards/country_codes/country_names_and_code_elements_txt.htm
#      cat country_names_and_code_elements_txt | ./countries_import_to_moodle.pl > ~/git/moodle/lang/en/countries.php
#

use strict;
use warnings;
use utf8;
use locale;
use encoding 'utf8';

my %countries = ();

while (<STDIN>) {
    chomp;

    my ($countryname, $countrycode) = split(/;/, $_);

    # Lowercase except first word:
    $countryname =~ s/([\w']+)/\u\L$1/g;
    # Escape '
    $countryname =~ s/'/\\'/g;

    # Exception for taiwan MDL-15976
    if ($countrycode eq "TW") {
        $countryname = 'Taiwan';
    }

    $countries{$countrycode} = $countryname;
}

moodleheader();

foreach my $code (sort keys %countries) {
   print "\$string['$code'] = '$countries{$code}';\n";
}


sub moodleheader
{

print << 'EOL';
<?php

// This file is part of Moodle - http://moodle.org/
//
// Moodle is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// Moodle is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with Moodle.  If not, see <http://www.gnu.org/licenses/>.

/**
 * Strings for component 'countries', language 'en', branch 'MOODLE_20_STABLE'
 *
 * @package   countries
 * @copyright 1999 onwards Martin Dougiamas  {@link http://moodle.com}
 * @license   http://www.gnu.org/copyleft/gpl.html GNU GPL v3 or later
 */

EOL
}
