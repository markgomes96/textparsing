//Mark Gomes
//CSC 330
//Assignment 1 - Text Parsing
//9/25/17
#include <iostream>
#include <sstream>
#include <string>
#include <fstream>
#include <cstdlib>
#include <stdio.h>
#include <ctype.h>
#include <iomanip>
#include <math.h>

using namespace std;

void checkFile(int argc);           //Checks if a filename was given
bool isWord(string word);           //Checks if a string contains an alphabetical character
void countWords(int worddata[], string filename);       //Counts words in a string
int countSyllables(string word);            //Counts syllables in a string
bool isVowel(char ch);                      //Checks if a character is a vowel
bool isSentenceEnd(string word);            //Checks if a string contains ending punctution

int main(int argc, char* argv[])
{
    checkFile(argc);                        //Checks if any filename is given
    string filename = argv[1];
    float wordNum, syllNum, sentNum;
    float alpha, beta, FRI, FKGLI;
    int worddata[3];                        //0: Words; 1: Syllables; 2: Sentences
    worddata[0] = 0;    worddata[1] = 0;    worddata[2] = 0;
    countWords(worddata, filename);
    wordNum = worddata[0];  syllNum = worddata[1];  sentNum = worddata[2];

    alpha = syllNum/wordNum;                //Calculate indexes and display information
    beta = wordNum/sentNum;
    FRI = 206.835 - (alpha*84.6) - (beta*1.015);
    FKGLI = (alpha*11.8) + (beta*0.39) - 15.9;
    cout << "Word #: " << wordNum << "    " << "Syllables #: " << syllNum << "    " << "Sentence #: " << sentNum << endl;
    cout << "Flesch Readability Index: " << round(FRI) << endl;
    FKGLI = round(FKGLI * 10) / 10;                //Rounds to one decimal points
    cout << "Flesch-Kincaid Grade Level Index: " << setprecision(2) << FKGLI << endl;
    return 0;
}

void checkFile(int argc)
{
    if(argc == 1)
    {
        cout << "Error - No File Entered." << endl;
        exit(1);
    }
}

bool isWord(string word)
{
    bool hasLetter = false;
    for(int i = 0; i < word.length(); i++)
    {
        if(isalpha(word[i]))
                hasLetter = true;
    }
    return hasLetter;
}

void countWords(int worddata[], string filename)
{
    ifstream infile;
    infile.open(filename.c_str());
    if(!infile.is_open())                           //Checks if file is available
    {
        cout << "Error - Invalid File Name Entered" << endl;
        exit(1);
    }

    int wordNum = 0;
    string word;
    int endlpos;
    while(infile.peek() != EOF)                     //Iterates through file until EOF(end of file)
    {
        getline(infile, word, ' ');                 //Stores strings from file between every space
        endlpos = word.find("\n");
        if(endlpos != -1)                           //Checks if it's two words becuase of nextline
        {
            if(isWord(word.substr(endlpos)))
            {
                wordNum++;
            }
        }
        if(isWord(word))                            //Counts syllables if string counts as word
        {
            wordNum++;
            worddata[1] += countSyllables(word);
        }
        if(isSentenceEnd(word))                     //Check if there is sentencing ending punctuation attached to word
            worddata[2]++;
    }
    worddata[0] = wordNum;
}

int countSyllables(string word)
{
    int syllCount = 0;
    bool volAdj = false;
    char lastvowel;
    stringstream ss;
    string letter;
    for(int i = 0; i < word.length(); i++)
    {
        if(isVowel(word[i]))            //Records the last vowel
            lastvowel = word[i];   
 
        if(volAdj == false)             //If not yet encountered vowel then check for one
        {
            if(isVowel(word[i]))
                volAdj = true;
        }
        else                            //If already encountered vowels
        {
            ss << word[i];
            ss >> letter;
            if(!isVowel(word[i]) && isWord(letter))       //If adjacent vowels end then increment syllnum
            {
                syllCount++;
                volAdj = false;
            }
        }
    }
    lastvowel = tolower(lastvowel);
    if(volAdj == true && lastvowel != 'e')          //Prevents words with ending 'e' to have extra syllable
        syllCount++;
    if(syllCount == 0)              //Makes sure all words have at least 1 syllable
        syllCount++;
    return syllCount;
}

bool isVowel(char ch)
{   
    bool vowel = false;
    char c;
    c = tolower(ch);
    if(c == 'a' || c == 'e' || c == 'i' || c == 'o' || c == 'u' || c == 'y')
        vowel = true;
    return vowel;
}
bool isSentenceEnd(string word)
{
    bool sentEnd = false;
    char c;
    for(int i = 0; i < word.length(); i++)
    {
        c = word[i];
        if(c == '.' || c == ':' || c == ';' || c == '?' || c == '!')
            sentEnd = true;
    }
    return sentEnd;
}
