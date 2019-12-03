#!/usr/bin/perl

use strict;
use warnings;
my $usage="\nCommand Line:\n$0 [tabela de jogadores] [digite SIM para com equilibrio e NAO para aleatorio]";

my $listFile = $ARGV[0]|| die "$usage";
my $eq = $ARGV[0]|| die "$usage";


open (TAB, "$listFile");
my $line; my @jogadores;
while($line=<TAB>){
	chomp($line);
	push(@jogadores,$line)
}
close TAB;

package selectTime{
    sub randomSelect {
        my ($size, $done) = @_;
        my $random = rand($size);
        my $jogador = $jogadores[$random];
        #print ("testando novamente\n");
        selectTime::randomTest($jogador, $done, $size);
    }
    sub randomTest {
        my ($jogador, $done, $size) = @_;
        if ($done=~m/$jogador/){
            #print ("$done tem $jogador, testando novamente\n");
            selectTime::randomSelect($size, $done);

        }elsif ($done!~m/$jogador/){
            return $jogador;
        }

    }
}

my $size = scalar @jogadores;

my $done = " ";
my $daVez;
my $count = 0;
my $timeCount = 1;
print ("------TIME $timeCount-----\n");
foreach my $i (0 .. $#jogadores){    
    my $random = rand($size);
    $daVez = $jogadores[$random];
    $count++;
    my $jogador;
    if ($done=~m/$daVez/){
        $jogador = selectTime::randomSelect($size, $done);
    } else {
        $jogador = $jogadores[$random];
    }
    if ($count < 6){
        print ("TIME $timeCount: $jogador\n");
        $done = $done . " " . $jogador;
    } elsif ($count == 6){
        print ("TIME $timeCount: $jogador\n");
        $done = $done . " " . $jogador;
        $timeCount++ ;
        print ("------TIME $timeCount-----\n");
        $count = 0 ;

    }
    #print ("da vez: $jogador - Done: $done\n\n");

}


