#!/usr/bin/perl

use DBI;
use Mail::Sender;
use WWW::Mechanize;

$SMTPSERVER = "localhost";
require "/var/www/cgi-bin/datasource.pl";

#### CONTROL VARIABLES #########################
$NFROM = "techsupport\@schoolspring.com";
$passingScore = 70;
$username = $gc_username;
$password = $gc_password;
$attemptURL = "http://schoolspring.globalclassroom.us/cirrus/mod/quiz/review.php?attempt=";
$profileURL = "https://schoolspring.globalclassroom.us/cirrus/user/editadvanced.php?id=";
################################################

my $holdTerminator = $/;
undef $/;
$email = <STDIN>;
$/ = $holdTerminator;

my ($candidate_id, $emailaddress);

#$file = 'text.txt';
#{
#local $/ = undef;
#open INF, $file;
#$email = <INF>;
#close INF;
#}

print $email;
if ($email =~ /attempt=(\d+)/s) {
 	$attempt_id = $1;
	print "Attempt ID: $attempt_id\n";
	
	my $mech = WWW::Mechanize->new();
	$mech->get($attemptURL . $attempt_id);
	$mech->form_id('login');
	$mech->submit_form(	fields => { 'username' => $username, 'password' => $password });
	#$mech->save_content('gc_1.html');
	$content = $mech->content;

	#{
	#local $/ = undef;
	#open INF, 'gc_2.html';
	#$content = <INF>;
	#close INF;
	#}

	if ($content =~ /Grade.*?<td.*?><b>(\d+)</is) {
		$grade = $1;
		print "Grade: $grade\n";
		if ($grade >= $passingScore) {
			if ($content =~ /<th.*?><a.*?view.php\?id=(\d+)/i) {
				$profile_id = $1;
				$mech->get($profileURL . $profile_id);
				$content = $mech->content;
				#$mech->save_content('gc_2.html');
				#{
				#local $/ = undef;
				#open INF, 'gc_3.html';
				#$content = <INF>;
				#close INF;
				#}
				if ($content =~ /<input.*?name="email".*?value="(.*?)"/is) {
					$emailaddress = lc Trim($1);
				}
				if ($content =~ /<input.*?name="profile_field_CandidateID".*?value="(.*?)"/is) {
					$candidate_id = Trim($1);
				}
				print "CID: $candidate_id / EMAIL: $emailaddress\n";
				if ($emailaddress && $candidate_id) {
					$updateCand = $dbh->do("update C_Candidate set TechSavvyDate = now() where candidate_id = '$candidate_id' and LOWER(email) = '$emailaddress' and techsavvydate is null");
					print "Records affected: $updateCand \n";
					if ($updateCand ne 1) {
						$error = "Candidate info could not be found in SchoolSpring database";
					}
				} else {
					$error = "Candidate info not found at " . $profileURL . $profile_id;
				}
			} else {
				$error = "Profile ID not found at " . $attemptURL . $attempt_id;
			}
		}
	} else {
		$error = "Grade not found at " . $attemptURL . $attempt_id;
	}
} else {
	$error = "Attempt ID not found in notification email\n";
}

if ($error ne "") {
	if ($grade > $passingScore) {
		$gradeResult = "PASSED";
	} else {
		$gradeResult = "FAILED";
	}
	$email =~ s/.*(Dear SchoolSpring Admin.*)/$1/is;
	$sender = new Mail::Sender {smtp => "$SMTPSERVER"};
	$sender->Open({ from => "$NFROM", 
					to => "support\@schoolspring.com", 
					subject => "SS Tech Savvy Error",
					headers => "MIME-Version: 1.0\nContent-type: text/html\nContent-Transfer-Encoding: 7bit"});
	$sender->print("<b>ERROR:</b> $error<br><b>SCORE:</b> $grade ($gradeResult)<br><b>EMAIL:</b> <a href=https://admin.schoolspring.com/search.cfm?query=$emailaddress>$emailaddress</a><br><b>CAND ID:</b> <a href=https://admin.schoolspring.com/search.cfm?query=$candidate_id>$candidate_id</a><p><pre>$email</pre></p>");
	$sender->Close();
	print "ERROR: $error\n";
}

# Strip leading and trailing spaces off a string
sub Trim {
  my ($str) = @_;
  $str =~ s/^[\s\t]+//;
  $str =~ s/[\s\t]+$//;
  return $str;
}
