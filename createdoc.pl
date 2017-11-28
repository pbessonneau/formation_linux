#! /usr/bin/perl

use strict;
use open ":encoding(Latin1)";


my @files = glob("??.*_*.tex");

my $first = 1;

open( MASTER, ">article/master.tex" );

foreach my $file ( @files ) {
	
	open ( ENTREE, $file );
	open( SORTIE, ">article/parties/".$file );
	
	if ( $first ) {
		
		my $continuer = 1;
		
		while( $continuer ) {
		
			my $tampon = <ENTREE>;
			
			if ( $tampon =~ /begin\{document\}/ig ) {
				$continuer = 0;
			}
			
			#if ( $tampon =~ /^(\\documentclass\{beamer\})/ig ) { $tampon = "\\documentclass{article}\n"; }
			#if ( $tampon =~ /\\usetheme\{Warsaw\}/ig ) { $tampon = "\n"; }
			
			#print MASTER $tampon;
			
		}

		print MASTER "\\documentclass{article}\n";
  
		print MASTER "% Packages nécessaires\n";
		print MASTER "\\include{preambule/packages}\n";

		print MASTER "% Macros commandes\n";   
		print MASTER "\\include{preambule/macros}\n";

		print MASTER " % Définition de l'auteur, ...\n";
		print MASTER "\\include{preambule/titre}\n";  

		print MASTER "% Pieds de page, marges, ...\n";             
		print MASTER "\\include{preambule/layout}\n";

		print MASTER "\\begin\{document\}\n";
		print MASTER "\\maketitle\n";
		print MASTER "\\newpage\n";
		print MASTER "\\tableofcontents\n";
		print MASTER "\\newpage\n";
		
	}
	
	my $fichier;
	
	( $fichier = $file ) =~ s/\.tex//;
	print MASTER "\\include\{parties/$fichier\}\n";
	
	my $continuer = 1;
	
	my $subsection = "";
	
	while( <ENTREE> ) {
		
		if ( /^\\section\{/ig ) { $continuer = 0; }
		
		if ( $continuer ) { next; }
		
		if ( /^(\\begin\{document\})/ig ) { next; }
		if ( /^(\\end\{document\})/ig ) { next; }
		if ( /\\(begin|end)\{frame\}/ig ) { next; }
		
		s/frametitle/subsection/ig;
		
		if ( /subsection/ig ) {

			/(.*subsection{)(.*)(})(.*)/i;
		
			if ( $subsection eq "$2" ) { 
				next; 
			} 
			$subsection = $2;
		}
		
		print SORTIE $_;
	
	}

	close ( SORTIE );
	
	$first = 0;
	
}

print MASTER "\\end{document}\n";

close ( MASTER );
