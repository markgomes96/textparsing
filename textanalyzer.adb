--Mark Gomes
--CSC 330
--Assignment #1 - Text Parsing
--9/25/17
with Ada.text_IO;
with Ada.IO_Exceptions;
with Ada.Integer_Text_IO;
with Ada.Characters.Handling;
with Ada.Float_Text_IO;
with Ada.Command_Line;
with GNAT.OS_Lib;
use Ada.Text_IO;
use Ada.IO_Exceptions;
use Ada.Integer_Text_IO;
use Ada.Characters.Handling;
use Ada.Float_Text_IO;
use Ada.Command_line;
use GNAT.OS_Lib;

procedure textanalyzer is
    In_File         :Ada.Text_IO.File_Type;
    value           :Character;
    filedata        :array(1..5000000) of Character;
    pos             :Integer;
    c               :Character;
    wordnum         :Integer;
    syllnum         :Integer;
    sentnum         :Integer;
    isword          :Boolean;
    onletter        :Boolean;
    voladj          :Boolean;
    lastvowel       :Character;
    prevsyllnum     :Integer;
    alpha           :Float;
    beta            :Float;
    FRI             :Integer;
    FKGLI           :Float;
    FKGLI_int       :Integer;

    function lettercheck(ch : character) return Boolean is          --Checks if a character is alphabetic
    begin
        if ch = ''' then
            return true;
        end if;
        return Ada.Characters.Handling.Is_Letter(ch);
    end lettercheck;

    function vowelcheck(ch : Character) return Boolean is           --Checks if a character is a vowel
    begin
        case ch is
                when 'a' | 'e' | 'i' | 'o' | 'u' | 'y' => return true;
                when 'A' | 'E' | 'I' | 'O' | 'U' | 'Y' => return true;
                when others => return false;
        end case;
    end vowelcheck;

begin
    if Ada.Command_Line.Argument_Count = 0 then                     --Checks to see if a file name was entered in the command line
        Put("Error: No File Entered");
        New_Line;
        GNAT.OS_Lib.OS_Exit (0);                                    --Exits program if no file name is given
    end if;

    Ada.Text_IO.Open(File=>In_File,Mode=>Ada.Text_IO.In_File,Name=>Ada.Command_Line.Argument(1));       --Opens file

    pos := 0;
    while not Ada.Text_IO.End_Of_File(In_File) loop                     --Reads in file data
        Ada.Text_IO.Get(File => In_File, Item => value);
        pos := pos + 1;
        filedata(pos) := value;
    end loop;
 
    exception
        when Ada.IO_Exceptions.END_ERROR=>Ada.Text_IO.Close(File => In_File);

    wordnum := 0;   syllnum := 0;   sentnum := 0;
    voladj := false;    prevsyllnum := 0;
    for i in 1..pos loop                            --Iterates through the file data
        c := filedata(i);

        if lettercheck(c) = true then               --If letter is detected then it's know this is a word
            isword := true;
            onletter := true;
        else
            onletter := false;
        end if;

        if voladj = false then                      --If not yet encountered vowel check for vowel
            if vowelcheck(c) = true then
                voladj := true;
                lastvowel := c;
            end if;
        else                                        --If already encountered vowel
            if onletter = false then                            --If word has ended
                if lastvowel = 'e' or lastvowel = 'E' then      --If letter is 'e' then don't increment syllnum
                    voladj := false;
                else                                            --If anyother vowel then increment syllnum
                    syllnum := syllnum + 1;
                    voladj := false;
                end if;
            else                                                --If adjacent vowels have ended increment syllnum
                if vowelcheck(c) = false then
                    syllnum := syllnum + 1;
                    voladj := false;
                end if;
            end if;
        end if;

        if c = '.' or c = ':' or c = ';' or c = '?' or c = '!' then     --Checks for sentence punctuation
            sentnum := sentnum + 1;
        end if;

        if isword = true and onletter = false then                  --If word end increment wordnum
            wordnum :=  wordnum + 1;
            isword := false;
            if prevsyllnum = syllnum then                           --If syllnum hasn't changed since last word increment syllnum
                syllnum := syllnum + 1;
            end if;
            prevsyllnum := syllnum;
        end if;

    end loop;

    alpha := Float(syllnum)/Float(wordnum);                         --Index calculations
    beta := Float(wordnum)/Float(sentnum);
    FRI := Integer(206.835 - (alpha*84.6) - (beta*1.015));
    FKGLI := (alpha*11.8) + (beta*0.39) - 15.59;
    FKGLI_int := Integer(FKGLI*10.0);
    FKGLI := Float(FKGLI_int)/10.0;

    Put("Word #: "); Put(wordnum); Put("     Syllable #: "); Put(syllnum); Put("    Sentence #: "); Put(sentnum);   --Print results
    New_Line;
    Put("Flesch Readability Index: ");
    Put(FRI);
    New_Line;
    Put("Flesch-Kincaid Grade Level Index: ");
    Put(FKGLI, 2, 1, 0);
    New_Line;
end textanalyzer;
