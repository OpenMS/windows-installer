#!perl

if (@ARGV < 1)
{
	#die "Usage:\n  $0 <path_to_OpenMS> [enable DBImporter (1|0=default)]\n\n";
}

print "Setting $OMS_path to $ARGV[0]!\n";

$OMS_path = 'C:/dev/OpenMS1_3branch_build';
$OMSSRC_path = 'C:/dev/OpenMS1_3branch';
#$OMS_path = $ARGV[0];

$enable_DB = 0;
if (@ARGV >=2)
{
	$enable_DB = $ARGV[1];
}

$outfile = "$OMSSRC_path/source/TEST/TOPP/TOPP_test.bat";

# call make TOPP
$cmd = "cd $OMS_path && ctest -R TOPP -VV -N > $OMS_path/ctest.output";
print "Command: $cmd\n";
system($cmd);

# read output
open (MAKE, "$OMS_path/ctest.output");
@makefile = <MAKE>;
close(MAKE);

if ($#makefile < 10)
{
	die "Output of dry Make seems to be faulty (less than 10 lines)!\n\n";
}

@cmds = ("\@ECHO OFF\n\n");

#parse relevant commands
foreach $line (@makefile)
{
	if ($line =~ /^Test command: (.*)/ )
	{
		#this should be a command
		#@parts = split(' ', $1);
		#@file = split('/', $parts[0]);
		#$rejoin = join(' ', ($file[$#file], @parts[1..$#parts]));
		print "$rejoin\n\n";
		
		if ((!$enable_DB) and ($file[$#file] eq "DBImporter") || ($file[$#file] eq "DBExporter") ) {
			print "skipping DB importer...\n".$file[$#file]."\n";
			#skip DBImporter test
		}
		else {
			push @cmds, $1;
			push @cmds, "IF ERRORLEVEL 1 ECHO TOPP Command in line $#cmds failed! Press any key to continue.";
			push @cmds, "IF ERRORLEVEL 1 pause";
		}
	}	
}

push @cmds, "\nECHO ALL TESTS RUN!\nECHO Check for errors above!\npause";

open(CMD, ">$outfile");
print CMD join("\n",@cmds);
close(CMD);

print "$outfile written!\n\n";


print "Now, copy\n  $OMSSRC_path/source/TEST/TOPP\nto the VM and run it. Good luck!";

  # Create a Zip file
 #  use Archive::Zip qw( :ERROR_CODES :CONSTANTS );
 #  my $zip = Archive::Zip->new();
   
   # Add a file from disk
 #  my $file_member = $zip->addFile( 'OpenMS_splash.bmp', 'FolderList.exe.txt' );

#  my $member = $zip->memberNamed( 'xyz.txt' );
#  $file_member->compressionMethod(COMPRESSION_STORED );
  
   
   # Save the Zip file
#   unless ( $zip->writeToFileNamed('someZip.zip') == AZ_OK ) {
#       die 'write error';
#   }
   
