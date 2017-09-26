#Mark Gomes
#CSC 330
#Assignment 1 - Text Parsing
#9/25/17

my $filename = 'KJV.txt';
open(my $infile, '<:encoding(UTF-8)', $filename)        #Opens file
    or die "Error: Could not open file";
read $infile, my $filedata, -s $infile;                 #Read entire file to string
close $infile;

@fdarray = (0, 0, 0);                               #0:WordNum, 1:SyllablesNum, 2:SentenceNum
foreach $word (split(' ', $filedata))               #Iterates through every word in filedata
{
    $stats = processWord($word);                    #Returns string with data: "words syllables sentences"
    $counter = 0;
    foreach $stat (split(' ', $stats))              #Tallys up data from the word
    {
        $fdarray[$counter] += $stat;
        $counter++;
    }
}

$alpha = $fdarray[1] / $fdarray[0];                 #Calculate indexes
$beta = $fdarray[0] / $fdarray[2];
$FRI = 206.835 - ($alpha * 84.6) - ($beta * 1.015);
$FKGLI = ($alpha * 11.8) + ($beta * 0.39) - 15.59;
$FRI = sprintf("%.0f", $FRI);
$FKGLI = sprintf("%.1f", $FKGLI);

print "Words: $fdarray[0]   Syllables: $fdarray[1]   Sentences: $fdarray[2]\n";     #Display information
print "Flesch Readability Index: $FRI\n";
print "Flesch-Kincaid Grade Level Index: $FKGLI\n";

sub processWord                  #Checks for word, syllables, sentence end
{
    my($self) = @_;
    $isword = 0;
    $issentence = 0;
    $syllables = 0;
    $voladj = 0;            #Keeps track is char is adjacent to a vowel

    foreach $char (split //, $self)         #Iterates though every char in the word
    {
        if($char =~ /^[[a-zA-Z]+$/)         #Checks if char is alphanumerical
        {
            $isword = 1;
        }

        if($char eq '.' || $char eq ':' || $char eq ';' || $char eq '?' || $char eq '!')    #Checks if char is ending punctuation
        {
            $issentence = 1;
            $self = substr $self,0,-1;
        }
        else                        #Counts syllables
        {
            if($voladj == 0)                #if not yet encountered a vowel then check for vowel
            {
                if(isVowel($char) == 1)
                {
                    $voladj = 1;
                }
            }
            else                            #If already encountered a vowel then check for non-vowel
            {
                if(isVowel($char) == 0)     #If non-vowel encountered reset and and increment syllables
                {
                    $syllables++;
                    $voladj = 0;
                }
            }
        }
    }
    $endch = substr $self,-1,1;
    if($voladj == 1 && $endch ne 'e')    #Excludes words that end in 'e' from extra syllable
    {
        $syllables++;
    }
    if($isword == 1 && $syllables == 0)     #If word hasn't incremented syllable yet then increment it
    {
        $syllables++;
    }
    if($isword == 0)                    #Does count syllables if not word
    {
        $syllables = 0;
    }

    return "$isword $syllables $issentence";
}

sub isVowel                 #Checks if character is a vowel
{
    my($self) = @_;
    $c = lc $self;
    if($c eq 'a' || $c eq 'e' || $c eq 'i' || $c eq 'o' || $c eq 'u' || $c eq 'y')
    {
        return 1;
    }
    return 0;
}
