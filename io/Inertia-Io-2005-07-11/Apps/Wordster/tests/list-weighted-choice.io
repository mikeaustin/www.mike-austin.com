// Testing the weightedChoice List method
// Brian Hammond <io at brianhammond dot com>

List weightedChoice := method(weights,
    if (weights count != count,
        Exception clone raise("weightedChoice", "wrong number of weights")
    )
    n := Number random
//    writeln("weightedChoice")
    weights foreach(i, w,
//        writeln("\tn: ", n, " w: ", w)
        if (n < w, return at(i))
        n = n - w
    )
    Nil
)

l := List clone
w := List clone

test1 := block(
    l = list("a")
    w = list(1)
)

test2 := block(
    l = list("a", "b")
    w = list(0.50, 0.50)
)

test3 := block(
    l = list("a", "b", "c")
    w = list(0.10, 0.75, 0.15)
)

test4 := block(
    l = list("a", "b")
    w = list(0, 1)
)

test5 := block(
    l = list(
        "A",
        "B",
        "C",
        "D",
        "E",
        "F",
        "G",
        "H",
        "I",
        "J",
        "K",
        "L",
        "M",
        "N",
        "O",
        "P",
        "Q",
        "R",
        "S",
        "T",
        "U",
        "V",
        "W",
        "X",
        "Y",
        "Z"
    )
    
    w = list(
        0.079971, // A
        0.020199, // B
        0.043593, // C
        0.032184, // D
        0.112513, // E
        0.014622, // F
        0.022845, // G
        0.023497, // H
        0.08563,  // I
        0.001693, // J
        0.008535, // K
        0.060585, // L
        0.028389, // M
        0.071596, // N
        0.065476, // O
        0.029165, // P
        0.00183,  // Q
        0.07264,  // R
        0.066044, // S
        0.070926, // T
        0.037091, // U
        0.011369, // V
        0.008899, // W
        0.002925, // X
        0.024432, // Y
        0.00335   // Z
    )
)

writeln("List weightedChoice unit-test")
writeln("=============================")

testNo := 1
testSetupBlock := Nil

while (testSetupBlock = getSlot("test" .. testNo),
    testSetupBlock
    writeln("Running test 'test", testNo, "'")

    results := Map clone
    expected := Map clone
    l foreach (i, k,
        results atPut(k, 0)
        expected atPut(k, w at(i))
    )

    iterations := 25000
    for (i, 1, iterations,
        c := l weightedChoice(w)
        results atPut(c, results at(c) + 1)
    )

    results foreach (k, v,
        chosenPercent := ((v/iterations) * 100)
        expectedPercent := expected at(k) * 100

        write("> ", k, " chosen: ", chosenPercent, "% ")
        write("expecting: ", expectedPercent, "%")

        if ((expectedPercent - chosenPercent) abs < 2) then (
            writeln(" --> PASS")
        ) else (
            writeln(" --> FAIL")
            exit
        )
    )

    testNo = testNo + 1
)

writeln("\n** ALL TESTS PASS")

// vim:ft=io:ts=8:sw=4:sts=4:et
