#!/usr/bin/perl

use Term::ANSIColor;
use strict;
use warnings;
my $usage="\nCommand Line:\n$0 [lista de jogadores][tabela de jogadores - na mesma ordem da lista]";

my $listFile = $ARGV[0]|| die "$usage";
my $tabFile = $ARGV[1]|| die "$usage";


my $condition;
BEGIN {
    $condition = 1;
}

use if $condition, 'Term::ANSIColor';


open (TAB, "$listFile");
my $line; my @jogadores;
while($line=<TAB>){
    chomp($line);
    push(@jogadores,$line)
}
close TAB; 
my $size = scalar @jogadores;

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


package run { 
    sub time{
        my ($tabFile) = @_;
        print ("######################### SELECAO DE TIMES #########################\n");
        open (TAB1, "$tabFile");
        my $line; my @jogadoresTAB;
        while($line=<TAB1>){
            chomp($line);
            push(@jogadoresTAB,$line)
        }
        close TAB1; 
        my $size = scalar @jogadoresTAB;

        my $done = " ";
        my $daVez;
        my $count = 0;
        my $timeCount = 1;

        if ($timeCount % 2 == 0){
            print Term::ANSIColor::color("green");
        } else {
            print Term::ANSIColor::color("white");
        }

        print ("------TIME $timeCount-----\n");


        my @valuesTime;
        my $valorDeTodosOsTimes = 0;
        my $valueTime = 0;
        my $valueTimeAll = 0;
        foreach my $i (0 .. $#jogadores){    
            my $random = rand($size);    
            $daVez = $jogadores[$random];

            $count++;
            my $jogador;
            if ($done=~m/$daVez/){
                $jogador = selectTime::randomSelect($size, $done);
                foreach my $jogadorTAB (@jogadoresTAB){
                    my @comValores = split('\t', $jogadorTAB); 
                    if ($comValores[0] eq $jogador){
                        $valueTimeAll = $valueTimeAll + $comValores[1];
                        $valueTime =  $comValores[1];    
                    }

                }

            } else {
                $jogador = $jogadores[$random];
                foreach my $jogadorTAB (@jogadoresTAB){
                    my @comValores = split('\t', $jogadorTAB); 
                    if ($comValores[0] eq $jogador){
                        $valueTimeAll = $valueTimeAll + $comValores[1];
                        $valueTime =  $comValores[1];     
                    }

                }
            }
            if ($count < 6){
                print ("TIME $timeCount: $jogador\n");
                $done = $done . " " . $jogador;
            } elsif ($count == 6){
                print ("TIME $timeCount: $jogador\n");
                $done = $done . " " . $jogador;
                $timeCount++ ;
                $valorDeTodosOsTimes = $valorDeTodosOsTimes + $valueTimeAll;
                push (@valuesTime,$valueTimeAll);
                print ("value Time: $valueTimeAll\n\n------TIME $timeCount-----\n");
                $count = 0 ;
                $valueTimeAll = 0;
                $valueTime = 0;

            }
            #print ("da vez: $jogador - Done: $done\n\n");

        }
        my $quantosTimes = scalar @valuesTime;
        my $media = $valorDeTodosOsTimes/$quantosTimes;
        print ("\nquantidade de times fechados: $quantosTimes\nmedia $media\n");
        my $sqtotal = 0;
        foreach my $valuein (@valuesTime) {
        $sqtotal += ($valuein - $media) ** 2
        }
        my $var = $sqtotal / (scalar @valuesTime - 1);
        print ("variancia: $var\n\n\n");
        if ($var>0.15){
            run::time($tabFile);
        } else {
            print  Term::ANSIColor::color("red"), "\n###### CHUPA RAFINHA ######\n", Term::ANSIColor::color("reset");
        }
    }

}

run::time($tabFile);
