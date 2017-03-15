// Determines the frequency of letters in words.
// Useful for word games that generate a set of random letters with
// which a player can create words. You don't want 'x' showing up
// more than 'a' for instance since 'x' is used in far fewer words!
// Brian Hammond <io at brianhammond dot com>

wordsPath := if (Lobby args at(0), Lobby args at(0), "resources/words")
file := File clone openForReading(wordsPath)
if (file == Nil,
    writeln(wordsPath, " not found")
    exit
)

nwords := 0
nletters := 0

histogram := Map clone
for (i, 65, 90, histogram atPut(i asCharacter, 0))

word := Nil
while (word = file readLine,
    word foreach (i, ch,
        if (97 <= ch <= 122, ch = ch - 32)
        if (ch < 65 or ch > 90, continue)
        histogram atPut(ch asCharacter, histogram at(ch asCharacter) + 1)
    )
    nletters = nletters + word length
    nwords = nwords + 1
    if (nwords % 1000 == 0,
        write(".")
        File standardOutput flush
    )
)
writeln("\n")

writeln("processed ", nwords, " words with a total of ", nletters, " letters.")

sum := 0
writeln("histogram:")
histogram foreach(k, v,
    p := (v / nletters)     // normalize
    sum = sum + p
    writeln(k, ": ", p)
)
writeln("sum = ", sum)
if (sum < 1 or sum > 1, 
    writeln(sum - 1.0, "...?")
)

// vim:ft=io:ts=8:sw=4:sts=4:et
