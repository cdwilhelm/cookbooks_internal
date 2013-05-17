#!/usr/bin/perl

use DBI;
use Socket;
use File::Copy;
use Mail::Sender;
use MIME::Base64;
use Image::Magick;
use Net::Amazon::S3;

$SSROOT = "/usr/local/share/mailscripts/";
$tempdir = $SSROOT . "/temp/faxdocs";
$logdir = "/vol/logs/faxdocs";
require "$SSROOT/datasource.pl";

#### CONTROL VARIABLES #########################
$SMTPSERVER = "localhost";
$NFROM = "techsupport\@schoolspring.com";
$NTO = "techsupport\@schoolspring.com";
################################################

#$file = $ARGV[0];
#{
#local $/ = undef ;
#open INF, $file;
#$email = <INF>;
#close INF;
#}

# Amazon S3 bucket
$s3 = Net::Amazon::S3->new({
    aws_access_key_id => $awsKey,
    aws_secret_access_key => $awsSecret,
    retry => 1, secure => 1
});
$S3BUCKET = $s3->bucket($s3filesbucket);

my $holdTerminator = $/;
undef $/;
$email = <STDIN>;
$/ = $holdTerminator;

if ($email =~ /Content-Type: image\/tiff.*?filename="?(.*?)\.tif"?(.*?)-/s) {
 	$filename = $1;
	$attachment = decode_base64($2);
	open OUTF, "> $logdir/$filename.tif"; 
	binmode(OUTF);
	print OUTF $attachment;
	close OUTF;

	if ($email =~ /(\d+) page MaxEmail fax/) {
		$fax_pages = $1;
		if ($email =~ /reference number for this message is (\d+)/si) {
			$fax_num = $1;

			# employers who have dedicated fax numbers are stored like fax CID in E_EmployerFax
			# 8155720812 is the general fax number for all other employers
			if ($fax_num eq "8155720812") {
				$email =~ /page fax from 1?([\d\s]+)/si;
				$fax_cid = $1;
				$fax_cid =~ s/[^\d]//g;
			} else {
				$fax_cid = $fax_num;
			}

			if ($fax_cid) {

				# Retrieve employer_id
				$employer_id = 0;
				$employer_id = $dbh->selectrow_array("SELECT employer_id FROM E_EmployerFax WHERE fax_number = '" . $fax_cid . "'");
	
				if ($employer_id ne 0) {
					# create document record
					$insertDocument = $dbh->do("INSERT INTO E_Document (employer_id, document_name)
											 		VALUES (" . $employer_id . ", '" . $fax_pages . " Page Fax')");
	
					# Retrieve new document_id
					$document_id = $dbh->selectrow_array("select MAX(document_id) from E_Document where employer_id = $employer_id");
					$dbh->disconnect;

					# make sure temp directory exists
					mkdir($tempdir) unless (-d $tempdir);

					# convert to PDF
					$image = Image::Magick->new;
					$image->ReadImage("$logdir/$filename.tif");
					$image->Set(compression=>'Group4');
					#$image->Write('pdf:-'); # write to STDOUT (another option)
					$pdffile = $tempdir . "/" . $document_id . ".pdf";
					$image->Write($pdffile);
					undef $image;
					
					# writing to S3 bucket
					$s3doc = "employer/" . $employer_id . "/docs/" . $document_id . ".pdf";
          			$S3BUCKET->add_key_filename($s3doc, $pdffile);
	
				} else { 
					$error = "Employer Fax number not registered: $fax_cid";
				}
			} else {
				$error = "Caller ID not found";
			}
		} else { 
			$error = "Receiving fax number (reference number) not found"; 
		}
	} else { 
		$error = "Not a MaxEmail email"; 
	}
} else { 
	$error = "no TIFF attachment\n"; 
}

if ($error ne "") {
	$sender = new Mail::Sender {smtp => "$SMTPSERVER"};
	$sender->Open({ from => "$NFROM", 
					to => "$NTO", 
					subject => "SS Employer Fax Error" });
	$sender->print("Error: $error\nFilename: $filename.tif\n\n$email");
	$sender->Close();
	print $error;
}
