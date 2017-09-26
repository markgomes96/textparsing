//Mark Gomes
//CSC 330
//Assignment 1 - Text Parsing
import java.io.File;
import java.util.Scanner;
import java.io.FileNotFoundException;

public class textanalyzer
{
    public static void main(String[] args)
    {
        checkFile(args.length);             //Checks if any filename is given

        String fileName = args[0];
        double wordNum, syllNum, sentNum;
        double alpha, beta, FRI, FKGLI;
        int[] wordData = new int[3];        //0:Words, 1:Syllables, 2:Sentences
        wordData[0] = 0; wordData[1] = 0; wordData[2] = 0;

        countWords(wordData, fileName);

        wordNum = wordData[0];  syllNum = wordData[1];  sentNum = wordData[2];
        alpha = syllNum/wordNum;                            //Calculates the indexes
        beta = wordNum/sentNum;
        FRI = 206.835 - (alpha*84.6) - (beta*1.015);
        FKGLI = (alpha*11.8) + (beta*0.39) - 15.9;
        FRI = (double)Math.round(FRI);
        FKGLI = (double)(Math.round(FKGLI*10)/10);

        System.out.println("Word #: " + wordNum + "     Syllable #: " + syllNum        //Displays daya
                            + "     Sentences #: " + sentNum);
        System.out.println("Flesch Readability Index: " + FRI);
        System.out.println("Flesch-Kincaid Grade Level Index: " + FKGLI);
    }

    static void checkFile(int args)             //Checks if filename was entered, terminates program if none given
    {
        if(args == 0)
        {
            System.out.println("Error - No File Entered.");
            System.exit(0);
        }
    }

    static boolean isWord(String word)          //Checks if a string contains alphabetical lettes
    {
        for(int i = 0; i < word.length(); i++)
        {
            if(Character.isLetter(word.charAt(i)))
                return true;
        }
        return false;
    }

    static void countWords(int wordData[], String fileName)    //Counts all the data
    {
        try
        {
            File infile = new File(fileName);       //Opens file
            Scanner sc = new Scanner(infile);
            String line;
            String wordArray[];
            while(sc.hasNextLine())             //Increments line by line though the file
            {
                line = sc.nextLine();
                wordArray = line.split(" ");    //Turns line into an array of words
                for(int i = 0; i < wordArray.length; i++)       //Increments though the word array
                {
                    if(isWord(wordArray[i]))            //Counts syllables if string counts as word
                    {
                        wordData[0]++;
                        wordData[1] += countSyllables(wordArray[i]);
                    }
                    if(isSentenceEnd(wordArray[i]))     //Checks if there is sentece ending punctuation attached to word
                    {
                        wordData[2]++;
                    }
                }
            }
        }
        catch(FileNotFoundException ex)
        {
            System.out.println("Error - Invalid File Name Entered");
            System.exit(0);
        }
    }

    static int countSyllables(String word)
    {
        int syllCount = 0;
        boolean volAdj = false;
        char lastvowel = 0;
        for(int i = 0; i < word.length(); i++)       //Increments though ch in the word
        {
            if(isVowel(word.charAt(i)))
                lastvowel = word.charAt(i);
            if(volAdj == false)                 //Checks if encountered a vowel, if not then check for vowel
            {
                if(isVowel(word.charAt(i)))
                    volAdj = true;
            }
            else                                //If encountered vowel
            {
                if(!isVowel(word.charAt(i)) && isWord(Character.toString(word.charAt(i))))        //If adjacent vowels end, then increment syllCount
                {
                    syllCount++;
                    volAdj = false;
                }
            }
        }
        lastvowel = Character.toLowerCase(lastvowel);
        if(volAdj == true && lastvowel != 'e')   //Makes sure words that end in 'e' don't get an extra syllable
            syllCount++;
        if(syllCount == 0)              //Makes sure all words have at least one syllable
            syllCount++;
        return syllCount;
    }

    static boolean isVowel(char ch)             //Checks if ch is a vowel
    {
        char c = Character.toLowerCase(ch);
        if(c == 'a' || c == 'e' || c == 'i' || c == 'o' || c == 'u' || c == 'y')
            return true;
        return false;
    }

    static boolean isSentenceEnd(String word)       //Checks if a string has ending punctuation
    {
        char c;
        for(int i = 0; i < word.length(); i++)
        {
            c = word.charAt(i);
            if(c == '.' || c == ':' || c == ';' || c == '?' || c == '!')
                return true;
        }
        return false;
    }
}
