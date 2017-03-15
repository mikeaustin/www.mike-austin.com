// Wordster
// Author: Brian Hammond <io at brianhammond dot com>
// For: the first Io Game Development Competition Feb 2005
// Contact: bhammond in #io on irc.freenode.net
// License: BSD

Importer turnOff

Random setSeed(Date clone now asNumber)
writeln( launchPath )

//Object setSchedulerSleepSeconds(0.00001)
Object useCoros  := Nil      // xxx having lots of issues w/ coros
Object debugMode := 1
Object dprint    := method(
    if (Object debugMode == Nil, return)
    performWithArgList("writeln", thisMessage argsEvaluatedIn(sender))
)
Object whatTimeIsIt := method(Date clone now asNumber)

List choice := method(at(Number random(count)))

// Returns a random element from a list, weighted by given weights.
// weights - a list of weights 1:1 with elements in the given list.
// Each weight value must be in the range [0,1] and the sum of all
// weights should equal 1.

List weightedChoice := method(weights,
    if (weights count != count,
        Exception clone raise("weightedChoice", "wrong number of weights")
    )
    n := Random value
    weights foreach(i, w,
        if (n < w, return at(i))
        n = n - w
    )
    Nil
)

ResCache := Object clone do(
    newSlot("resType", Nil)
    newSlot("fileExt", Nil)
    newSlot("basePath", Lobby launchPath appendPath("resources"))
writeln( launchPath )

    cache := Map clone

    init := method(
        cache = cache clone
        self
    )

    find := method(path,
        res := Nil
        if (path pathExtension == fileExt,
            path = basePath appendPath(path)
            res = cache at(path)
            if (res == Nil,
                dprint(resType, ": ", path lastPathComponent)
                p := Lobby getSlot(resType)
                res = Lobby getSlot(resType) clone open(path)
                cache atPut(path, res)
            )
        )
        if (res == Nil) then (
            writeln("WARNING: Failed to find ", resType, " resource:", path)
        )
        res
    )
)

# xxx Add support for all supported file types, not just one...

SoundCache := ResCache clone do(
    setFileExt("wav")
    setResType("Sound")
    setBasePath(basePath appendPath("sounds"))
)

ImageCache := ResCache clone do(
    setFileExt("png")
    setResType("Image")
    setBasePath(basePath appendPath("images"))
)

FontCache := ResCache clone do(
    setFileExt("ttf")
    setResType("Font")
    setBasePath(basePath appendPath("fonts"))
)

Point distanceSquared := method(pt,
    x2x1 := (pt x - self x)
    y2y1 := (pt y - self y)
    (x2x1 * x2x1) + (y2y1 * y2y1)
)

Point distance := method(pt, distanceSquared(pt) sqrt)

// Animations are easy to do with coros. Here are some ideas:
// * interpolate any value from m to n over time
// * fade alpha in and out
// * scale up and down
// * move along a path using splines or just linear movements
// * squash
// * shake
// * explode
//      * shake a little while being squashed a bit
//      * then scale up with fading alpha out
// * for this game, when doing a swap, swap the two pieces down,
//   rotate them about a common midpoint 180 degrees, then scale back up.

Entity := Object clone do(
    appendProto(OpenGL)

    newSlot("entityParent", Nil)
    newSlot("children", List clone)     // xxx not used currently
    newSlot("rotation", Point clone set(0,0,0))
    newSlot("scale", Point clone set(1,1,1))
    newSlot("pos", Point clone)         // center, not lower left
    newSlot("alpha", 1)

    init := method(
        pos = pos clone
        self
    )

    preRender := method(
        glPushMatrix
    )

    render := method(
        preRender
        render_
        postRender
    )

    render_ := method(
        // xxx combine with parent's rotation/scale/etc later

        /*
        glTranslated(pos x, pos y, 0)
        glScalef(scale x, scale y, scale z)
        glRotatef(rotation x, 1, 0, 0)  // xxx use quats later
        glRotatef(rotation y, 1, 0, 0)
        glRotatef(rotation z, 1, 0, 0)
        */

        self
    )

    postRender := method(
        glPopMatrix
    )

    moveThreshold := 3

    setPos := method(x, y,
        if (useCoros == Nil) then (
            pos set(x, y)
            return self
        )

        // If distance moved isn't very far, just move the piece there.
        // else start an animator coro that'll take us there over time.

        p := Point clone set(x, y)

        if (pos distanceSquared(p) < (moveThreshold * moveThreshold),
            pos set(p x, p y)
        ) else (
            @@moveTo(p x, p y)
        )
        self
    )

    // NB all of the following are to be called asynchronously (@@).

    moveTo := method(x, y,
        dprint("move from ", pos x, " ", pos y, " to ", x, " ", y)

        target := Point clone set(x,y)
        dist   := target distance(pos)

        while (dist > 1,
            xdir := if (pos x < target x, 1, -1)
            ydir := if (pos y < target y, 1, -1)

            delta := ((dist / 20) max(1))

            pos x = (pos x + (delta * xdir))
            pos y = (pos y + (delta * ydir))

            dist = target distance(pos)

            yield
        )

        pos set(x,y)
    )

    fadeIn := method(
        delta = if (delta, delta, 0.01)
        while (alpha < 1,
            alpha = alpha + delta
            yield
        )
        alpha = 1
    )

    fadeOut := method(delta,
        delta = if (delta, delta, 0.01)
        while (alpha > 0,
            alpha = alpha - delta
            yield
        )
        alpha = 0
    )

    currTime := method(
        Date clone now asNumber
    )

    delayFor := method(delay,
        now := currTime
        while (currTime < now + delay, yield)
    )

    blink := method(times, delay, lowAlpha, highAlpha,
        lowAlpha = if (lowAlpha, lowAlpha, 0.25)
        highAlpha = if (highAlpha, highAlpha, 1)
        for (i, 1, times,
            alpha = lowAlpha
            delayFor(delay)
            alpha = highAlpha
            delayFor(delay)
        )
    )

    shrink := method(rate, goalScale,
        rate = if (rate, rate, 2)    // xx make time based
        goalScale = if (goalScale, goalScale, 0)

        while (scale x > goalScale,      // xx assumes all components are eq
            scale set(scale x - rate, scale y - rate, scale z - rate)
            yield
        )
    )

    grow := method(rate, goalScale,
        rate = if (rate, rate, 2)    // xx make time based
        goalScale = if (goalScale, goalScale, 0)

        while (scale x < goalScale,      // xx assumes all components are eq
            scale set(scale x + rate, scale y + rate, scale z + rate)
            yield
        )
    )

    // bounces the entity like the Mac OS X dock icons.
    // xxx todo

    bounce := method(dir, dist,
        self
    )

    // xx make time based

    rotate := method(whichAxis, revolutions, rate,
        initialAngle := 0
        if (whichAxis == 0,
            initialAngle = rotation x
        ) elseif (whichAxis == 1,
            initialAngle = rotation y
        ) elseif (whichAxis == 2,
            initialAngle = rotation z
        )

        revs := 0
        while (revs < revolutions,
            if (whichAxis == 0,
                rotation x = rotation x + rate
                if (rotation x > initialAngle,
                    rotation x = rotation x - 360
                    revs = revs + 1
                )
            ) elseif (whichAxis == 1,
                rotation y = rotation y + rate
                if (rotation y > initialAngle,
                    rotation y = rotation y - 360
                    revs = revs + 1
                )
            ) elseif (whichAxis == 2,
                rotation z = rotation z + rate
                if (rotation z > initialAngle,
                    rotation z = rotation z - 360
                    revs = revs + 1
                )
            )
            yield
        )
        self
    )
)

Button := Entity clone do(
    newSlot("label", Nil)
    newSlot("font", FontCache find("freemono-bold.ttf") setPixelSize(16))
    newSlot("bgImage", Nil)
    newSlot("fgColor", Color clone set(0,0,0,1))

// xxx we don't take into account scale when testing for point containment

    halfWidth  := 0
    halfHeight := 0

    setBgImage := method(img,
        bgImage    = img
        halfHeight = img width / 2
        halfWidth  = img height / 2
        self
    )

    render_ := method(
        glPushMatrix
        glColor4f(1,1,1,alpha)
        glTranslated(left, bottom, 0)
        bgImage drawTexture
        glPopMatrix

        glPushMatrix
        glColor4f(fgColor red, fgColor green, fgColor blue, alpha)
        caretX := pos x - (font widthOfString(label) * 0.5)
        caretY := pos y - (font pixelSize * 0.5)
        glTranslated(caretX, caretY, 0.0)
        font drawString(label)
        glPopMatrix

        self
    )

    left   := method(pos x - halfWidth)
    right  := method(pos x + halfWidth)
    top    := method(pos y + halfHeight)
    bottom := method(pos y - halfHeight)
    width  := method(bgImage width)
    height := method(bgImage height)

    containsPoint := method(pt,
        if (pt x < left or pt x > right or pt y < bottom or pt > top) then (
            Nil
        ) else (
            self
        )
    )
)

// Pieces are circular with an inscribed string, generally 1 character long.

Piece := Button clone do(
    newSlot("boardPos", Point clone)
    newSlot("selected", Nil)
    newSlot("fg", Color clone set(0,0,0,1))
    newSlot("selectedFg", Color clone set(1,0,0,1))

    setBgImage(ImageCache find("piece-bg.png"))

    pos := Point clone set(-100, -100)

    select := method(
        setFgColor(selectedFg)
        selected = 1
        self
    )

    deselect := method(
        setFgColor(fg)
        selected = Nil
        self
    )

    // We know we're circular buttons.

    containsPoint := method(pt,
        if (pos distanceSquared(pt) < (halfWidth * halfWidth), self, Nil)
    )

    setBoardPos := method(c, r,
        boardPos = Point clone set(c, r)
        self
    )

    sameRowAs := method(piece,
        if (boardPos y == piece boardPos y, self, Nil)
    )

    sameColAs := method(piece,
        if (boardPos x == piece boardPos x, self, Nil)
    )

    inALineWith := method(piece,
        if (sameRowAs(piece) or sameColAs(piece), self, Nil)
    )
)

// A simple container for all the Pieces of the board.  Change any of the
// layout attributes and the pieces will animate into the new layout.

Board := Object clone do(
    pieces  := List clone
    rows    := 7
    cols    := 7
    padding := 2
    origin  := Point clone set(50, 80)

    init := method(
        pieces = pieces clone
        for (i, 1, rows * cols, pieces push(Piece clone setLabel("W")))
        self
    )

    // sets the letter of a piece at (row,col) to label.
    // row,col: 0-based, [0 - rows-1] [0 - cols-1]

    atPut := method(row, col, label,
        index := (col + (row * cols))
        if (index < 0 or index >= pieces count,
            Exception clone raise("Board atPut", "out of bounds")
        )
        pieces at(index) setLabel(label)
    )

    at := method(row, col,
        // xxx stupid linear scan

        pieces foreach(i, p,
            if (p boardPos x == col and p boardPos y == row) then (
                return p
            )
        )

        Nil
    )

    setRows := method(r,
        if (r <= 0, return self)
        rows = r
        layout_
    )

// xxx maybe allow 0 cols/rows for effects like the board eating itself

    setCols := method(c,
        if (c <= 0, return self)
        cols = c
        layout_
    )

    setOrigin := method(o,
        origin = o
        layout_
    )

    setPadding := method(p,
        padding = p
        layout_
    )

    layout_ := method(
        // NB: entity positions reflect their center.

        x := origin x
        y := origin y

        for (r, 0, rows - 1,
            maxRowHeight := 0

            for (c, 0, cols - 1,
                p := pieces at(c + (r * cols))

                p setPos(x,y)
                p setBoardPos(c,r)

                x = x + p width + padding

                if (p height > maxRowHeight) then (
                    maxRowHeight = p height
                )
            )

            y = y + maxRowHeight + padding
            x = origin x
        )

        self
    )

    doLayout := method(
        layout_
    )

    deselectAll := method(
        pieces foreach(i, p, p deselect)
        self
    )

    selectAll := method(
        pieces foreach(i, p, p select)
        self
    )

    moveAllOffScreen := method(
        pieces foreach(i, p, p setPos(-100, -100))
        self
    )

    render := method(
        pieces foreach(i, p, p render)
        self
    )

    hit := method(pt,
        pieces foreach(i, p,
            if (p containsPoint(pt)) then (
                return p
            )
        )
        Nil
    )

    // Assign random letters to all pieces in the given list we weight the
    // probability of vowels higher than consonants and letters like x, y, z,
    // w, qu lower than other consonants.  The following list of weights was
    // determined by find the histogram of letters in a dictionary of words.

    weights := list(
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

    letters := list(
        "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K",
        "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V",
        "W", "X", "Y", "Z"
    )

    assignRandomLetters := method(plist,
        plist = if (plist, plist, pieces)
        plist foreach(i, p,
            c := letters weightedChoice(weights)
            p setLabel(c)
        )
        self
    )
)

GUI := Object clone do(
    appendProto(OpenGL)
    title       := "Io Application"
    size        := Point clone set(512,512)
    mpos        := Point clone
    initialized := Nil

    newSlot("eventTarget", Nil)
    newSlot("cursorImage", ImageCache find("default-cursor.png"))

    init := method(
        mpos = mpos clone
        size = size clone
        self
    )

    assertIsInit := method(
        if (initialized == Nil) then (
            Exception clone raise("startEventLoop", "Not initialized")
        )
    )

    startEventLoop := method(
        assertIsInit
        dprint("entering event loop..")
        glutMainLoop
    )

    setSize := method(w, h,
        assertIsInit
        glutReshapeWindow(w,h)
        if (eventTarget, eventTarget ?onResize(size w - w, size h - h))
        size set(w,h)
        glutPostRedisplay
        self
    )

    display := method(
        assertIsInit
	glMatrixMode(GL_PROJECTION)
	glLoadIdentity
	gluOrtho2D(0, size x, 0, size y)
	glMatrixMode(GL_MODELVIEW)
	glLoadIdentity
        glClearColor(0.25,0.425,0.25,1)
	glClear(GL_COLOR_BUFFER_BIT|GL_DEPTH_BUFFER_BIT)
        if (eventTarget, eventTarget ?onRedisplay)
        renderMouseCursor_
        glutSwapBuffers
        self
    )

    renderMouseCursor_ := method(
        if (cursorImage) then (
            glutSetCursor(GLUT_CURSOR_NONE)
            glPushMatrix
            glTranslated(mpos x, mpos y - cursorImage height, 0)
            cursorImage drawTexture
            glPopMatrix
        ) else (
            glutSetCursor(GLUT_CURSOR_INHERIT)
        )
        self
    )

    wireframeMode := Nil

    keyboardUp := method(key, x, y,
        if (key asCharacter == "w" and debugMode) then (
            if (wireframeMode) then (
                wireframeMode = Nil
                glPolygonMode(GL_FRONT_AND_BACK, GL_FILL)
                writeln("FILL")
            ) else (
                wireframeMode = 1
                glPolygonMode(GL_FRONT_AND_BACK, GL_LINE)
                writeln("LINE")
            )
        ) else (
            if (eventTarget, eventTarget ?onKey(key))
        )
        glutPostRedisplay
        self
    )

    special := method(key, x, y,
        if (eventTarget, eventTarget ?onSpecialKey(key))
        glutPostRedisplay
        self
    )

    mouse := method(b, s, x, y,
        mpos set(x, size y - y)
        if (eventTarget,
            if (s == GLUT_DOWN) then (
                eventTarget ?onMousePress(b,mpos)
            ) elseif (s == GLUT_UP) then (
                eventTarget ?onMouseRelease(b,mpos)
            )
        )
        glutPostRedisplay
        self
    )

    // We don't support dragging but passiveMotion is not called while
    // dragging. We thus just keep track of where the mouse is.

    motion := method(x, y,
        mpos set(x, size y - y)
        glutPostRedisplay
        self
    )

    passiveMotion := method(x, y,
        mpos set(x, size y - y)
        glutPostRedisplay
        self
    )

    timer := method(value,
        if (eventTarget, eventTarget ?onTimer)
        glutTimerFunc(0, 0)
    )

    reshape := method(w, h,
	glViewport(0, 0, w, h)
        setSize(w, h)
    )
)

GameState := Object clone do(
    playing     := Nil
    board       := Board clone
    dict        := List clone
    status      := String clone
    currentTime := whatTimeIsIt

    setStatus := method(s,
        status = s
        self
    )

    loadDict := method(
        path := ResCache basePath appendPath("words")

        try (
            file := File clone openForReading(path)
        ) catch (Exception, e,
            writeln("Failed to load dictionary from ", path)
            exit
        )

        line := Nil
        dict  = List clone

        while (line = file readLine,
            if (line length < 3, continue)
            dict push(line upper)
        )

        if (dict count == 0) then (
            writeln("No words loaded!")
            exit
        )

        setStatus("Loaded " .. dict count .. " words")
    )
)

UserOpts := Object clone do(
    soundEnabled := 1
)

SelectionState := Object clone do(
    first  := Nil
    second := Nil

    init := method(
        first  = Nil
        second = Nil
    )

    reset := method(
        if (first,  first deselect)
        if (second, second deselect)

        first  = Nil
        second = Nil
    )
)

PlayerState := Object clone do(
    inputText := Buffer clone
    points    := 0
)

LevelState := Object clone do(
    level        := 0
    endTime      := 0
    reqWordCount := 0

    init := method(
        level = 0
        endTime = 0
        reqWordCount = 0
        self
    )

    wordAdded := method(theWord,
        reqWordCount = ((reqWordCount - 1) max(0))
        self
    )
)

Wordster := Visual clone appendProto( Object ) clone do(
    appendProto(OpenGL)

    gui            := GUI clone
    gameState      := GameState clone
    selState       := SelectionState clone
    playerState    := PlayerState clone
    levelState     := LevelState clone

    sounds := Object clone do(
        err       := SoundCache find("error.wav")
        select    := SoundCache find("select.wav")
        swap      := SoundCache find("swap.wav")
        submit    := SoundCache find("submit.wav")
        bonus     := SoundCache find("bonus.wav")
        timesUp   := SoundCache find("timesup.wav")
        nextLevel := SoundCache find("nextlevel.wav")
        gameOver  := SoundCache find("gameover.wav")
    )

    resources := Object clone do(
        font       := FontCache find("bluehigh.ttf") setPixelSize(16)
        aboutImage := ImageCache find("wordster-about.png")
    )

    init := method(
        resend()
        gui = GUI clone
        //gui setEventTarget(self)
        //gui open
        //gui setTitle("Wordster")
        //gui startEventLoop
        self
    )

    newGame := method(
        gameState setStatus(" ")
        gameState loadDict
        levelState level = 0
        playerState points = 0
        newLevel
        self
    )

    newLevel := method(
        gameState board doLayout
        gameState board assignRandomLetters
        gameState board deselectAll

        selState reset

        levelState do(
            level        := level + 1
            endTime      := (whatTimeIsIt + (60 - (level * 2)))
            reqWordCount := level * 3
        )

        playSound(sounds nextLevel)

        gameState setStatus("Level " .. levelState level .. "... Good Luck!")
        self
    )

    handleLevelEnd := method(
        gameState setStatus("Time's Up!")
        playSound(sounds timesUp)

        gameState board moveAllOffScreen

        if (levelState reqWordCount > 0) then (
            gameState setStatus("Not enough words entered -- Game over.")
            gameState playing = Nil
            playSound(sounds gameOver)
        ) else (
            newLevel
        )
    )

    updateState := method(
        if (gameState playing) then (
            if (gameState currentTime > levelState endTime) then (
                handleLevelEnd
            )
        )
        if (useCoros and activeCoroCount > 1, yield)
    )

    onTimer := method(
        gameState currentTime = whatTimeIsIt
        updateState
        gui display
    )

    notifyError := method(msg,
        gameState setStatus("Oops! " .. msg)
        playSound(sounds err)
    )

    playSound := method(sound,
        if (UserOpts soundEnabled == Nil, return self)
        if (useCoros == Nil) then (
            dprint("Play sound (no-coro)")
            AudioDevice open write(sound buffer)
        ) else (
            dprint("Play sound (w/ coro)")
            AudioMixer addSound(sound)
            AudioMixer @@start
        )
        self
    )

    textEntered := method(str,
        dprint("You say: ", str)
        self
    )

    onKey := method(key,
        if (gameState playing == Nil) then (
            // pressing any key will start the game.
            gameState playing = 1
            newGame
        ) else (
            if (key == 27) then (
                gameState playing = Nil
            ) else (
                // Allow player to enter a line of text
                // To be used in multiplayer chats, etc
                if (32 <= key < 127) then (
                    playerState inputText appendByte(key)
                ) elseif (key == 13) then (
                    textEntered(playerState inputText asString)
                    playerState inputText = Buffer clone
                )
            )
        )
    )

    onMousePress := method(btn, pt,
        if (gameState playing == Nil) then (
            // Clicking anywhere begins a new game.
            gameState playing = 1
            newGame
        ) else (
            pieceClicked := gameState board hit(pt)
            if (pieceClicked, handlePieceClicked(pieceClicked))
        )
    )

    handlePieceClicked := method(thePiece,
        if (selState first and selState second) then (
            selState reset
        )

        if (selState first == Nil) then (
            gameState setStatus(thePiece label)
            selState first = thePiece
            selState first select
        ) else (
            // Did user click the same first piece again?  If so, deselect it.

            if (thePiece == selState first) then (
                gameState setStatus("Canceled")
                selState first deselect
                selState first = Nil
                return self
            )

            // Clicking a second piece. It's a rule that first and last
            // must be in a vert/horiz line from one another, no diagonals.

            if (thePiece inALineWith(selState first) == Nil) then (
                notifyError("Not in a vertical or horizontal line!")
                return self
            )

            selState second = thePiece
            selState second select

            // Now, two pieces have been clicked.  Let's see how far apart
            // from each other they are.

            dx  := ((selState first boardPos x - selState second boardPos x) abs)
            dy  := ((selState first boardPos y - selState second boardPos y) abs)

            if (dx == 1 or dy == 1) then (
                // If adjacent, swap.

                doSwap
            ) elseif (dx >= 2 or dy >= 2) then (
                // if further apart (at least 3 characters inclusive),
                // submit the word with letters from first -> last.

                doWordSubmit
            ) else (
                notifyError("Words must be at least 3 letters long!")
            )
        )
    )

    doSwap := method(
        gameState setStatus(selState first label .. " < > " .. selState second label)

        // Swap logical board positions

        tmp := Point clone set(selState first boardPos x, selState first boardPos y)
        selState first boardPos set(selState second boardPos x, selState second boardPos y)
        selState second boardPos set(tmp x, tmp y)

        // Swap on-screen positions too

        tmp = selState first pos clone
        selState first setPos(selState second pos x, selState second pos y)
        selState second setPos(tmp x, tmp y)

        playSound(sounds swap)
    )

    doWordSubmit := method(
        piecesNeedingNewLetters := List clone
        theWord := Buffer clone

        // Walk row/col from first to last piece in selection, form word
        // from letters the in-between pieces contain, look it up in the
        // dictionary. If found, score it and reassign new letters to the
        // pieces forming the word.

        if (selState first sameRowAs(selState second)) then (
            row := selState first boardPos y
            for (col, selState first boardPos x, selState second boardPos x,
                p := gameState board at(row, col)
                p select
                theWord append(p label)
                piecesNeedingNewLetters push(p)
            )
        ) elseif (selState first sameColAs(selState second)) then (
            col := selState first boardPos x
            for (row, selState first boardPos y, selState second boardPos y,
                p := gameState board at(row, col)
                p select
                theWord append(p label)
                piecesNeedingNewLetters push(p)
            )
        )

        // Dictionary search.

        theWord = theWord asString
        if (gameState dict contains(theWord) == Nil) then (
            notifyError(theWord .. " is not in my dictionary. Try again")
            return
        )

        playSound(sounds submit)
        scoreWord(theWord)
        gameState board assignRandomLetters(piecesNeedingNewLetters)
        selState reset
        gameState board deselectAll
        levelState wordAdded(theWord)

        self
    )

    scoreWord := method(theWord,
        wordScore := theWord length * 50
        playerState points = playerState points + wordScore

        gameState setStatus(theWord .. " for " .. wordScore .. " points!")

        if (theWord length > 5) then (
            playSound(sounds bonus)
            bonusAmt := 500
            setStatus("Bonus ", bonusAmt, " for long word!")
            playerState points = playerState points + bonusAmt
        )

        self
    )

    //onRedisplay := method(
    drawVisual := method(
        if (gameState playing) then (
            gameState board render
            renderHUD
        ) else (
            glPushMatrix
            resources aboutImage draw
            glPopMatrix
        )
        self
    )

    renderHUD := method(
        glPushMatrix
        glTranslated(10, 25, 0)
        Color clone set(1,1,0,1) glColor
        resources font drawString("WORDSTER: " .. gameState status)
        glPopMatrix

        if (gameState playing) then (
            glPushMatrix
            glTranslated(10, 5, 0)
            Color clone set(1,1,1,1) glColor

            remaining := (levelState endTime - gameState currentTime)
            remaining := ((remaining floor) max(0))

            s := Buffer clone
            s append("Time: " .. remaining .. " seconds, ")
            s append("Score: " .. playerState points asString .. ", ")
            s append("Words Needed: " .. levelState reqWordCount)
            if (levelState reqWordCount == 0) then (
                s append(" You will play in the next round!")
            )
            resources font drawString(s asString)
            glPopMatrix
        )

        self
    )
)

dprint("loaded.. opening gui")

game := Wordster clone

// vim:ft=io:ts=8:sw=4:sts=4:et

Inertia desktop addChild(
  Window clone appendProto( Object ) do (
    addChild( wordster := Wordster clone do (
      width = 512; height = 512
      reshape = list( Reshape Size, Reshape Size )
    ))
    width = 512; height = 512 + 20; sizeChanged = 1
    focusedVisual = wordster
  )
)

