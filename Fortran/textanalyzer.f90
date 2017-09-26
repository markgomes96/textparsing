!Mark Gomes
!CSC 230
!Assignment 1 - Text Parsing
!9/25/17
program reader
character(100) :: filename
character, dimension(:), allocatable :: filedata
integer :: filesize
integer :: i
character :: c
integer :: ascii
integer :: wordnum
integer :: syllnum
integer :: sentnum
integer :: prevsyllnum
logical :: isword
logical :: onletter
character :: lastvowel
logical :: voladj
logical :: isvowel
real :: alpha
real :: beta
real :: FRI
real :: FKGLI

interface

subroutine read_file(string, filesize, filename)    !Reads and stores data from a file
character, dimension(:), allocatable :: string
integer :: filesize
character(100) :: filename
end subroutine read_file

subroutine alphanum(ch, isword, onletter)           !Check if letter is alphabetical
character :: ch
logical :: isword
logical :: onletter
end subroutine alphanum

subroutine vowel(ch, isvowel, lastvowel)            !Checks if char is a vowel
character :: ch
logical :: isvowel
character :: lastvowel
endsubroutine vowel

end interface

write(*,*) "Please Enter File Name: "                   !Aquires file name from user
read(*,*) filename

call read_file(filedata, filesize, filename)            !Read in file to filedata

wordnum = 0;    syllnum = 0;    sentnum = 0;
do  i=1,filesize                            !Iterates throught the filedata by ever char
    c = filedata(i)
    ascii = ichar(c)
    call alphanum(c, isword, onletter)          !Checks if current char is a letter, and if a word has started

    if(c == '.' .or. c == ':' .or. c == ';' .or. c == '?' .or. c == '!') then   !Checks for sentence ending punctuation and increments sentnum
        sentnum = sentnum + 1;
    end if

    if(voladj .eqv. .false.) then                           !If not yet encountered vowel, then check for one
        call vowel(c, isvowel, lastvowel)
        if(isvowel .eqv. .true.) then
            voladj = .true.
        end if
    else                                                    !If already encountered vowel
        if(onletter .eqv. .false.) then                         !If word has ended
            if(lastvowel == 'e' .or. lastvowel == 'E') then     !If last vowel was 'e' then dont increment syllnum
                voladj = .false.
            else                                            !Any other vowel then increment syllnum
                syllnum = syllnum + 1
                voladj = .false.
            end if
        else                                                !If adjacent vowels have ended then increment syllnum
            call vowel(c, isvowel, lastvowel)
            if(isvowel .eqv. .false.) then
                syllnum = syllnum + 1
                voladj = .false.
            end if
        end if
    end if

    if(ascii == 32 .or. ascii == 10) then           !Checks if character grouping has ended
        if(isword .eqv. .true.) then                !If grouping was word then increment wordnum
            wordnum = wordnum + 1
            isword = .false.
            if(prevsyllnum == syllnum) then         !If syllnum is the same since last word then increment syllnum
                syllnum = syllnum + 1
            end if
            prevsyllnum = syllnum
        end if
    end if
end  do

print *, "Word #: ", wordnum                        !Display stats
print *, "Syllables: ", syllnum
print *, "Sentence #: ", sentnum

alpha = real(syllnum) / real(wordnum)
beta = real(wordnum) / real( sentnum)

FRI = 206.835 - (alpha*84.6) - (beta*1.015)                     !Calculate indexes
FKGLI = (alpha*11.8) + (beta*0.39) - 15.59
FRI = ANINT(FRI)
FKGLI = ANINT(FKGLI*10.0)
FKGLI = FKGLI / real(10.0)

    write(*, 10) "Flesch Readability Index: ", FRI              !Display information
10 format(A, F4.0)
    write(*, 20) "Flesch-Kincaid Grade Level Index: ", FKGLI
20  format(A, F4.1)

end program reader

subroutine read_file(string, filesize, filename)
character, dimension(:), allocatable :: string
integer :: counter
integer :: filesize
character(100) :: filename
character (LEN=1) :: input

inquire(file=filename, size=filesize)
open (unit=5,status="old",access="direct",form="unformatted",recl=1,file=filename)
allocate(string(filesize))

counter=1
100 read (5,rec=counter,err=200) input
        string(counter:counter) = input
        counter = counter + 1
        goto 100
200 continue
counter = counter - 1
close (5)
end subroutine read_file

subroutine alphanum(ch, isword, onletter)
character :: ch
logical :: isword
logical :: onletter
integer :: ascii

ascii = ichar(ch)
if((ascii >= 65 .and. ascii <= 90) .or. (ascii >= 97 .and. ascii <= 122)) then      !Checks ascii ranges for all alphabetical characters
    isword = .true.
    onletter = .true.
else
    onletter = .false.
end if
end subroutine alphanum

subroutine vowel(ch, isvowel, lastvowel)
character :: ch
logical :: isvowel
character :: lastvowel

if(ch == 'a' .or. ch == 'e' .or. ch == 'i' .or. ch == 'o' .or. ch == 'u' .or. ch == 'y') then
    isvowel = .true.
    lastvowel = ch
else
    if(ch == 'A' .or. ch == 'E' .or. ch == 'I' .or. ch == 'O' .or. ch == 'U' .or. ch == 'Y') then
        isvowel = .true.
        lastvowel = ch
    else
        isvowel = .false.
    end if
end if
endsubroutine vowel
