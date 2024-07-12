#!/usr/bin/perl
use strict;
use warnings;
use Time::HiRes qw(usleep);
use List::Util qw(shuffle);

# Constants
my $track_length = 50;  # Length of the track
my $num_horses = 8;  # Number of horses

# Generate random horse names
sub generate_horse_names {
    my @adjectives = qw(
        Swift Thunder Brave Mighty Fierce Bold Noble Rapid
        Agile Blazing Daring Gallant Heroic Majestic Fearless
        Valiant Courageous Dynamic Steadfast Stalwart Luminous
        Radiant Vibrant Resolute Tenacious Unyielding Spirited
        Energetic Vigorous Determined Dauntless Intrepid
        Relentless Unstoppable Invincible Indomitable
        Formidable Robust Hearty Strong Sturdy Power
        Nimble Fleet Quick Speedy Rapid Lightning Flash
        Bolt Thunder Comet Blaze
    );

    my @nouns = qw(
        Wind Blaze Storm Flash Comet Star Fury Lightning
        Hurricane Tornado Typhoon Cyclone Thunderbolt
        Avalanche Glacier Volcano Earthquake Meteor Meteorite
        Fire Inferno Flame Ember Spark Rocket Jet
        Missile Arrow Bolt Spear Lance Dagger Blade
        Saber Sword Katana Axe Hammer Mace Whirlwind
        Tempest Tsunami Wave Surge Ocean River Stream
        Torrent Rapids Cascade Waterfall Rain Shower
        Monsoon Gale Breeze Zephyr Twister
    );

    my @names;

    while (@names < $num_horses) {
        my $adjective = (shuffle(@adjectives))[0];
        my $noun = (shuffle(@nouns))[0];
        my $name = "$adjective $noun";
        push @names, $name unless grep { $_ eq $name } @names;  # Ensure unique names
    }

    return @names;
}

my @horses = generate_horse_names();  # Generate horse names
my %positions = map { $_ => 0 } @horses;  # Starting positions

# Single-line ASCII art for horses
my $horse_art = ">o\\";

# Display the current state of the race track
sub display_track {
    print "\033[H\033[J";  # Clear screen
    for my $horse (@horses) {
        my $pos = $positions{$horse};
        printf "%-20s: %s%s%s\n", $horse, '-' x $pos, $horse_art, ' ' x ($track_length - $pos - length($horse_art)), '||';  # Adding finish line
    }
    print " " x 22 . "-" x $track_length . "|| Finish Line\n";  # Visible finish line
}

# Simulate the race
sub simulate_race {
    while (1) {
        for my $horse (@horses) {
            $positions{$horse} += int(rand(3));  # Move horse forward randomly by 0, 1, or 2

            # Check for a winner
            if ($positions{$horse} >= $track_length) {
                $positions{$horse} = $track_length;
                display_track();
                print "\nHorse $horse wins the race!\n";
                return;
            }
        }

        display_track();
        usleep(200000);  # Pause for 200 milliseconds
    }
}

# Main function
sub main {
    display_track();
    simulate_race();
}

main();

