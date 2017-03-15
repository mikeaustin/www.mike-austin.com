// china.io
// A program for playing Chinese Checkers
// The program requires IoDesktop.
// Version 1.2, 03-Jun-2005
// Written by Jon Kleiser

writeln( "[China.io]" )

// This program is released in the public domain.
// Look for improved versions here: <http://folk.uio.no/jkleiser/china/>

/*
	History:
	1.2i Modified to run in Inertia Desktop - Mike Austin
	1.2  Supporting new appendProto as well as old parent.
	1.1  Added saveGame and loadGame methods. Added Dialog.
			Fixed bug in automaticMove. Supporting new/old random methods.
	1.0 First release


	Prototypes	Methods
	----------	---------------------------------------------------------------
	Object:		setParent
	Color:		adjustBrightness, adjustSaturation
	Colors
	Cell:			setup
	Direction:	new, distance, axisOffset
	GameState:	initialState, newFromMove, restoreBoardFromPrevious, getBoard,
					pieceTypeHasMadeIt, findJumpablesShort, findJumpablesLong,
					reachableCells, traceJumpsShort, traceJumpsLong, stepTrace,
					getPossibleMoves, movesWithRelGainAtLeast, acceptableMove,
					hasRealMove, movesFromStart
	Evaluator:	new, evaluation, gain, targetEvaluation
	Move:			new, isReal, getStateAfter
	ChinaBoard:	makeCellRow, cellAtRowCol, init, newGame, legalDestType,
					nextPieceType, nameOfColorToMove, vertInc, centerX, paint,
					paintMovingPiece, lastMove, teamThatDidLastMove, teamToMove,
					humanMustSkip, clickedCell, automaticMove, pieceTypeThatJustMadeIt,
					gameOver, undoLastMove, currentRevealedMove, revealNextMove,
					saveGame, loadGame
	Dialog:		new, handleKeyboard, handleSpecial, prevDialogActionApproved,
					toggleCursor, input, inputLeft, inputRight, asList
	ChinaApp:	setMsg, addMsg, boardStateIsInitial, newGame, setBackground,
					teamPolarities, dataPath, configure, setupFont, drawString,
					drawMessageBox, boardTop, display, msgAboutWhatsNext, setDialog,
					loadGameWithDialog, saveGameWithDialog, keyboard, special,
					motion, passiveMotion, negatives, mouse, reshape, timer, run
*/

//appendProto( Inertia )

Object setParent := method(p,
	self parent := p
	self ?appendProto(p)
)

Color do(
	adjustBrightness := method(coef,
		self setRed(self red * coef)
		self setGreen(self green * coef)
		self setBlue(self blue * coef)
		return self
	)
	
	adjustSaturation := method(coef,
		self setRed((self red - 1) * coef + 1)
		self setGreen((self green - 1) * coef + 1)
		self setBlue((self blue - 1) * coef + 1)
		return self
	)
)

Colors := Map clone do(
	atPut("red",		Color clone set(1, 0, 0, 1))
	atPut("cyan",		Color clone set(0, 1, 1, 1))
	atPut("blue",		Color clone set(0, 0, 1, 1))
	atPut("yellow",	Color clone set(1, 1, 0, 1))
	atPut("green",		Color clone set(0, 1, 0, 1))
	atPut("magenta",	Color clone set(1, 0, 1, 1))
	atPut("white",		Color clone set(1, 1, 1, 1))
	atPut("gray",		Color clone set(0.5, 0.5, 0.5, 1))
	atPut("darkGray",	Color clone set(0.22, 0.22, 0.22, 1))
)


Cell := Object clone do(
	cType := 0
	color := Nil
	neighbors := Nil
	pos := Nil
	row := Nil
	col := Nil
	flag := Nil

	setup := method(p, r, c,
		self pos = p
		self row = r
		self col = c
		return self
	)
	
)	// Cell


Direction := Object clone do(
	target := Nil
	a := Nil
	b := Nil
	c := Nil
	d := Nil
	colorName := Nil
	pieceColor := Nil
	pieceColor2 := Nil
	cellColor := Nil
	arrowColor := Nil
	
	new := method(t, ai, bi, ci, di, cName,
		newD := self clone
		newD target = t
		newD a = ai
		newD b = bi
		newD c = ci
		newD d = di
		newD colorName = cName
		newD pieceColor = Colors at(cName)
		newD pieceColor2 = newD pieceColor clone adjustBrightness(0.6)		// less bright
		newD cellColor = newD pieceColor clone adjustSaturation(0.2)		// low saturation
		newD arrowColor = newD pieceColor clone adjustSaturation(0.6)		// medium saturation
		return newD
	)
	
	distance := method(row, col,
		// Distance away from "home zero"
		return self c + (self a * row) + (self b * col)
	)
	
	axisOffset := method(row, col,
		// Distance away from axis (positive on one side, negative on the other)
		return self d + (((self b * row) - (self a * col)) * 2 / (self a + (self b))) + ((self b - (self a)) * distance(row, col))
	)
	
)	// Direction


GameState := Object clone do(
	//parent := Nil			// ChinaBoard, slot now created with setParent
	creator := Nil				// the Move that created this state
	board := Nil				// piece values
	evals := Nil				// evaluations for each of the directions
	pieceType := Nil			// the one to do the next move
	possibleMoves := Nil
	
	initialState := method(cb, team1,
		// Creates the initial state
		gs := self clone
		gs setParent(cb)
		gs board = List clone sizeTo(cb dimP)
		for(p, 0, cb dimP - 1,
			// Put a piece of given type only if that type is active ...
			gs board add(if(cb teamPolarities at(cb cellP at(p) cType) != 0,
										cb cellP at(p) cType, 0))
		)
		gs evals = List clone sizeTo(6)
		tEval := cb evaluator targetEvaluation
		//writeln("GameState initialState: targetEvaluation=", tEval)
		6 repeatTimes(gs evals add(-tEval))
		gs pieceType = cb teamPolarities indexOf(team1)
		return gs
	)
	
	newFromMove := method(move,
		// Creates a new state as a result of a move
		gs := self clone
		cb := move stateBefore parent		// the ChinaBoard object
		gs setParent(cb)
		gs creator = move
		movingPieceType := move stateBefore pieceType
		// Copy board ...
		gs board = List clone sizeTo(cb dimP) addList(move stateBefore board)
		if (move isReal,
			gs board atPut(move startPos, 0)
			gs board atPut(move destPos, movingPieceType)
		)
		// Copy evals
		gs evals = List clone sizeTo(6) addList(move stateBefore evals)
		gs evals atPut(movingPieceType - 1, gs evals at(movingPieceType - 1) + (move gain))
		gs pieceType = cb nextPieceType(movingPieceType)
		move stateAfter = gs
		return gs
	)
	
	restoreBoardFromPrevious := method(boardToRestore, move,
		prevState := move stateBefore
		if (prevState board) then (
			boardToRestore addList(prevState board)
		) else (
			prevState restoreBoardFromPrevious(boardToRestore, self creator)
		)
		if (move isReal,
			boardToRestore atPut(move startPos, 0)
			boardToRestore atPut(move destPos, prevState pieceType)
		)
	)
	
	getBoard := method(
		if (self board == Nil,
			// Restore board ...
			self board = List clone sizeTo(dimP)
			restoreBoardFromPrevious(self board, self creator)
		)
		return self board
	)
	
	pieceTypeHasMadeIt := method(pType,
		if (pType == Nil, pType = self pieceType)
		return (self evals at(pType - 1) abs < 0.001)
	)
	
	findJumpablesShort := method(fromCell, reach,
		fromCell neighbors foreach(i, n1,
			if (n1 and (self board at(n1 pos) > 0),
				n2 := n1 neighbors at(i)
				if (n2 and (self board at(n2 pos) == 0) and (reach at(n2 pos) == Nil),
					reach atPut(n2 pos, 1)				// reach by jump
					findJumpablesShort(n2, reach)		// look further
				)
			)
		)
	)
	
	findJumpablesLong := method(start, fromCell, reach,
		fromCell neighbors foreach(i, nc,
			freeCount := 0
			while (nc and ((board at(nc pos) == 0) or (nc pos == start)),
				freeCount = freeCount + 1
				nc = nc neighbors at(i)
			)
			if (nc,
				// After zero or more free cells, we have now found one that's taken.
				nc = nc neighbors at(i)
				while ((freeCount > 0) and nc and ((board at(nc pos) == 0) or (nc pos == start)),
					freeCount = freeCount - 1
					nc = nc neighbors at(i)
				)
				if (nc and (board at(nc pos) == 0) and (reach at(nc pos) == Nil),
					reach atPut(nc pos, 1)						// reach by jump
					findJumpablesLong(start, nc, reach)		// look further
				)
			)
		)
	)
	
	reachableCells := method(start,
		reach := reachScratch map(p, v, Nil)
		startCell := cellP at(start)
		startCell neighbors foreach(i, nc,
			if (nc,
				if (self board at(nc pos) == 0) then (
					reach atPut(nc pos, 1)		// reach by roll
				) else (
					if (shortJumps, findJumpablesShort(startCell, reach))
				)
				if (shortJumps == Nil, findJumpablesLong(start, startCell, reach))
			)
		)
		return reach
	)
	
	traceJumpsShort := method(from, dest, reach, posTrace,
		cellP at(from) neighbors foreach(i, n1,
			if (n1 and (getBoard at(n1 pos) > 0),
				n2 := n1 neighbors at(i)
				if (n2 and (board at(n2 pos) == 0) and (reach at(n2 pos) == Nil),
					reach atPut(n2 pos, 1)		// reach by jump
					if (n2 pos == dest) then (
						return dest
					) else (
						p := traceJumpsShort(n2 pos, dest, reach, posTrace)	// look further
						if (p,
							posTrace add(p)
							return n2 pos
						)
					)
				)
			)
		)
		return Nil
	)
	
	traceJumpsLong := method(start, from, dest, reach, posTrace,
		cellP at(from) neighbors foreach(i, nc,
			freeCount := 0
			while (nc and ((board at(nc pos) == 0) or (nc pos == start)),
				freeCount = freeCount + 1
				nc = nc neighbors at(i)
			)
			if (nc,
				nc = nc neighbors at(i)
				while ((freeCount > 0) and nc and ((board at(nc pos) == 0) or (nc pos == start)),
					freeCount = freeCount - 1
					nc = nc neighbors at(i)
				)
				if (nc and (board at(nc pos) == 0) and (reach at(nc pos) == Nil),
					reach atPut(nc pos, 1)						// reach by jump
					if (nc pos == dest) then (
						return dest
					) else (
						p := traceJumpsLong(start, nc pos, dest, reach, posTrace)	// look further
						if (p,
							posTrace add(p)
							return nc pos
						)
					)
				)
			)
		)
		return Nil
	)
	
	stepTrace := method(m,
		reach := List clone sizeTo(dimP)		// not to interfere with reachableCells
		dimP repeatTimes(reach add(Nil))
		posTrace := List clone
		cellP at(m startPos) neighbors foreach(i, nc,
			if (nc,
				if (nc pos == (m destPos)) then (
					posTrace add(nc pos)			// reach by roll
				) else (
					p := if(shortJumps, traceJumpsShort(m startPos, m destPos, reach, posTrace),
								traceJumpsLong(m startPos, m startPos, m destPos, reach, posTrace))
					if (p >= 0, posTrace add(p))
				)
			)
		)
		posTrace add(m startPos)
		return posTrace
	)
	
	getPossibleMoves := method(
		if (self possibleMoves == Nil,
			self possibleMoves = List clone
			// If the color to do a move has all its pieces in the target triangle,
			// we assume that it shall/will not move any piece back out, even if it
			// should be to help an other color on the same team. So, if it has
			// "made it", we skip the scanning.
			if (pieceTypeHasMadeIt == Nil,
				// Scanning the board for pieces of right color ...
				getBoard foreach(s, bs,
					if (bs == self pieceType,
						reach := reachableCells(s)
						// Finding possible destinations ...
						reach foreach(d, rd,
							if (rd and legalDestType(pieceType, cellP at(d) cType),
								self possibleMoves add(Move new(self, s, d))
							)
						)
					)
				)
				if (variations) then (
					self possibleMoves sortBy(method(m1, m2, m1 gain > (m2 gain)))
				) else (
					// Using bubble sort as long as I need full match with Java version ...
					for(i, 0, self possibleMoves count - 2,
						mi := self possibleMoves at(i)
						for(j, i + 1, self possibleMoves count - 1,
							mj := self possibleMoves at(j)
							if (mj gain > (mi gain),
								self possibleMoves swapIndexWithIndex(i, j)
								mi = mj
							)
						)
					)
				)
			)
			if (self possibleMoves count == 0,
				self possibleMoves add(Move new(self, -1, -1))	// no move, next please
			)
		)
		return self possibleMoves
	)
	
	movesWithRelGainAtLeast := method(coef,
		// If we only want the moves with the highest gain, coef should be 1.
		// If we accept lower gains, coef should be < 1.
		bestGain := getPossibleMoves first gain
		if (bestGain > 0) then (
			reqGain := bestGain * coef
		) else (
			// All moves have negative gain. Some tweak is needed ...
			worstRelBest := getPossibleMoves last gain - bestGain
			reqGain := worstRelBest + ((bestGain - worstRelBest) * coef)
			//writeln("bestGain=", bestGain, ", worstRelBest=", worstRelBest, ", reqGain=", reqGain)
		)
		return getPossibleMoves select(i, move, move gain >= reqGain)
	)
	
	acceptableMove := method(start, dest,
		getPossibleMoves detect(i, move, (move startPos == start) and (move destPos == dest))
	)
	
	hasRealMove := method(
		getPossibleMoves detect(i, move, move isReal)
	)
	
	movesFromStart := method(
		return if(self creator, self creator stateBefore movesFromStart + 1, 0)
	)
	
)	// GameState


Evaluator := Object clone do(
	//parent := Nil			// ChinaBoard, slot now created with setParent
	tEval := 0
	
	new := method(cb,
		ev := self clone
		ev setParent(cb)
		return ev
	)
	
	evaluation := method(pos, pieceType,
		c := cellP at(pos)
		dist := dir at(pieceType) distance(c row, c col)
		absOff := dir at(pieceType) axisOffset(c row, c col) abs
		//writeln(dist, " ", absOff)
		//return dist * (100 - (2 * dist)) - absOff
		return dist pow(1/3) * 300 - absOff			// to be tuned
	)
	
	gain := method(move,
		pieceType := move stateBefore board at(move startPos)
		return evaluation(move destPos, pieceType) - evaluation(move startPos, pieceType)
	)
	
	targetEvaluation := method(
		if (self tEval == 0,
			pieceType0 := cellP at(0) cType					// should be 2
			targetType := dir at(pieceType0) target		// should be 5 (opposite to 2)
			//writeln("Evaluator targetEvaluation: ", pieceType0, " ", targetType)
			for(pos, 0, 9,
				self tEval = self tEval + evaluation(pos, targetType) - evaluation(pos, pieceType0)
			)
		)
		return self tEval
	)
	
)	// Evaluator


Move := Object clone do(
	stateBefore := Nil
	stateAfter := Nil
	startPos := Nil
	destPos := Nil
	gain := Nil
	
	new := method(gs, start, dest,
		mv := self clone
		mv stateBefore = gs
		mv startPos = start
		mv destPos = dest
		mv gain = if(mv isReal, gs evaluator gain(mv), 0)
		return mv
	)
	
	isReal := method(self startPos >= 0)
	
	getStateAfter := method(disposeOldBoard,
		nextState := if(self stateAfter, self stateAfter, GameState newFromMove(self))
		if (disposeOldBoard and (self stateBefore creator),
			// The previous state was not the initial state.
			self stateBefore board = Nil		// dispose to reduse memory usage
		)
		return nextState
	)
	
)	// Move


ChinaBoard := Object clone do(
	setParent(OpenGL)
	dimR := 17
	dimP := 121
	cellRC := Nil		// the cells of the board, as a 2-dimensional List
	cellP := Nil		// the same cells, as a 1-dimensional List
	shortJumps := 1
	reachScratch := Nil
	dir := Nil			// List of Directions
	teamPolarities := Nil	// e.g. list(0, -1, 0, 0, 1, 0, 0)
	currentState := Nil
	evaluator := Nil
	selectedPos := -1
	curRevealed := -1
	moveTrace := Nil			// step positions of last move, or possible new move
	variations := 1
	random := Nil
	
	makeCellRow := method(pos, row, c,
		self cellRC atInsert(row, List clone sizeTo(c count))
		c foreach(col, t,
			if (t <= 6) then (
				cell := Cell clone setup(pos, row, col)
				self cellP atInsert(pos, cell)
				self cellRC at(row) atInsert(col, cell)
				cell cType = t
				cell color = self dir at(t) cellColor
				pos = pos + 1
			) else (
				self cellRC at(row) atInsert(col, Nil)
			)
		)
		return pos
	)
	
	cellAtRowCol := method(row, col,
		if ((row >= 0) and (row < self dimR) and (col >= 0) and (col < self cellRC at(row) count),
            return self cellRC at(row) at(col)
		)
		return Nil
	)

	init := method(
		dir = List clone sizeTo(7)
		dir add(Direction new(0, -1, -1, -1,   0, "white"))	// just for the color of common cell
		dir add(Direction new(4,  1,  1, -8,   0, "blue"))
		dir add(Direction new(5,  1,  0,  0,  24, "yellow"))
		dir add(Direction new(6,  0, -1, 16,  -8, "green"))
		dir add(Direction new(1, -1, -1, 24,   0, "magenta"))
		dir add(Direction new(2, -1,  0, 16,   8, "red"))
		dir add(Direction new(3,  0,  1,  0, -24, "cyan"))
		
		self cellRC = List clone sizeTo(self dimR)
		self cellP = List clone sizeTo(self dimP)
		p := 0
		//                          0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6
		p = makeCellRow(p,  0, list(9,9,9,9,9,9,9,9,9,9,9,9,2))
		p = makeCellRow(p,  1, list(9,9,9,9,9,9,9,9,9,9,9,2,2))
		p = makeCellRow(p,  2, list(9,9,9,9,9,9,9,9,9,9,2,2,2))
		p = makeCellRow(p,  3, list(9,9,9,9,9,9,9,9,9,2,2,2,2))
		p = makeCellRow(p,  4, list(9,9,9,9,1,1,1,1,0,0,0,0,0,3,3,3,3))
		p = makeCellRow(p,  5, list(9,9,9,9,1,1,1,0,0,0,0,0,0,3,3,3))
		p = makeCellRow(p,  6, list(9,9,9,9,1,1,0,0,0,0,0,0,0,3,3))
		p = makeCellRow(p,  7, list(9,9,9,9,1,0,0,0,0,0,0,0,0,3))
		p = makeCellRow(p,  8, list(9,9,9,9,0,0,0,0,0,0,0,0,0))
		p = makeCellRow(p,  9, list(9,9,9,6,0,0,0,0,0,0,0,0,4))
		p = makeCellRow(p, 10, list(9,9,6,6,0,0,0,0,0,0,0,4,4))
		p = makeCellRow(p, 11, list(9,6,6,6,0,0,0,0,0,0,4,4,4))
		p = makeCellRow(p, 12, list(6,6,6,6,0,0,0,0,0,4,4,4,4))
		p = makeCellRow(p, 13, list(9,9,9,9,5,5,5,5))
		p = makeCellRow(p, 14, list(9,9,9,9,5,5,5))
		p = makeCellRow(p, 15, list(9,9,9,9,5,5))
		p = makeCellRow(p, 16, list(9,9,9,9,5))
		
		/*	 12
			0x3
			54
		*/
		// Find neighbors ...
		self cellRC foreach(row, cellR,
			cellR foreach(col, c,
				if (c,
					c neighbors = List clone sizeTo(6)
					c neighbors add(cellAtRowCol(row, col - 1))
					c neighbors add(cellAtRowCol(row - 1, col))
					c neighbors add(cellAtRowCol(row - 1, col + 1))
					c neighbors add(cellAtRowCol(row, col + 1))
					c neighbors add(cellAtRowCol(row + 1, col))
					c neighbors add(cellAtRowCol(row + 1, col - 1))
				)
			)
		)
		
		self reachScratch = List clone sizeTo(self dimP)
		self dimP repeatTimes(self reachScratch add(Nil))
		self evaluator = Evaluator new(self)
		//self currentState = GameState initialState(self, -1)
		
		if (?Random) then (
			//writeln("Using new Random methods")
			self random = Random clone setSeed(Date clone now asNumber)
		) else (
			writeln("Using old random methods")
			self random = Object clone do(
				value := method(x, Number random(x))
			)
			Date clone now asNumber setRandomSeed
		)
		
		return self
	)	// init
	
	newGame := method(sJumps, tPolar, team1,
		self shortJumps = sJumps
		self teamPolarities = tPolar
		self currentState = GameState initialState(self, team1)
		self curRevealed = -1
		self moveTrace = Nil
	)
	
	legalDestType := method(pieceType, destType,
		(destType == 0) or (destType == pieceType) or (destType == (self dir at(pieceType) target))
	)
	
	nextPieceType := method(pType,
		notFound := 1
		while(notFound,
			pType = if(pType < 6, pType + 1, 1)
			notFound = (self teamPolarities at(pType) == 0)
		)
		return pType
	)
	
	nameOfColorToMove := method(
		return self dir at(self currentState pieceType) colorName
	)
	
	vertInc := method(horInc, horInc * (3 sqrt) / (2) ceil)
	
	centerX := method(cell, horInc, horInc * (cell col + (cell row / 2)))
	//centerY := method(cell, horInc, vertInc(horInc) * (cell row))
	
	paint := method(x0, y0, horInc, showPosEval,
		cs := self currentState
		slices := 6
		cSize := horInc / (3 sqrt) ceil
		pSize : cSize / (2) floor
		vInc := vertInc(horInc)
		//writeln("cSize=", cSize, ", pSize=", pSize, ", vertInc=", vInc)
		grayLev := 0.25
		glPushMatrix	// 1
		glTranslated(x0, y0, 0)
		
		// Draw arrow indicating color and direction ...
		glPushMatrix	// 1.1
		glTranslated(12 * horInc, -8 * vInc, 0)		// middle of board
		glRotated(cs pieceType * -60 + 30, 0, 0, 1)
		if (cs hasRealMove) then (
			self dir at(cs pieceType) arrowColor glColor
		) else (
			Colors at("gray") glColor
		)
		glBegin(GL_TRIANGLES)
		glVertex2d(horInc * 6.87, vInc)
		glVertex2d(horInc * 8.4, 0)
		glVertex2d(horInc * 6.87, -vInc)
		glEnd
		glPopMatrix		// 1.1

		glPushMatrix	// 1.2
		self cellRC foreach(row, cellR,
			glPushMatrix	// 1.2.1
			cellR foreach(col, cell,
				if (cell,
					quad := gluNewQuadric
					cell color glColor
					gluDisk(quad, 0, cSize, slices, 1)
					glColor4d(grayLev, grayLev, grayLev, 0.6)
					//glLineWidth(3)
					gluDisk(quad, cSize - 1, cSize, slices, 1)
					pType := cs getBoard at(cell pos)
					if (pType > 0,
						// Draw piece ...
						if (cell pos != self selectedPos,
							self dir at(pType) pieceColor glColor
							gluDisk(quad, 0, pSize, 90, 1)
						)
						self dir at(pType) pieceColor2 glColor		// darker outline
						gluDisk(quad, pSize - 1, pSize, 90, 1)
					)
					if (showPosEval,
						// Write the evaluation of the postion ...
						glPushMatrix
						glTranslated(-0.2 * horInc, -0.1 * vInc, 0)
						glScaled(0.08, 0.08, 0)
						glColor4d(0, 0, 0, 1)
						ev := self evaluator evaluation(cell pos, cs pieceType)
						glutStrokeString(0, ev asString(0, 1))
						glPopMatrix
					)
				)
				glTranslated(horInc, 0, 0)
			)
			glPopMatrix		// 1.2.1
			glTranslated(horInc / 2, -vInc, 0)
		)
		glPopMatrix		// 1.2
		
		move := currentRevealedMove			// possible new move
		if (move,
			self moveTrace = cs stepTrace(move)
		)
		
		// Draw the step trace of the last move, or possible new move ...
		if (self moveTrace,
			Colors at("darkGray") glColor
			//glLineWidth(1.2)
			glBegin(GL_LINE_STRIP)
			self moveTrace foreach(i, pos,
				cell := self cellP at(pos)
				glVertex2d(centerX(cell, horInc), -vInc * (cell row))
			)
			glEnd
			mtLast := self moveTrace count - 1
			tempSize := pSize * 0.27
			endSize := pSize * 0.39
			self moveTrace foreach(i, pos,
				glPushMatrix	// 1.3
				cell = self cellP at(pos)
				glTranslated(centerX(cell, horInc), -vInc * (cell row), 0)
				gluDisk(gluNewQuadric, if(i < mtLast, 0, endSize - 1),
							if(0 < i < mtLast, tempSize, endSize), slices, 1)
				glPopMatrix		// 1.3
			)
		)
		
		// Draw game progression bars ...
		barThick := -vInc * 0.3
		barMaxLength := horInc * 6.5
		tEval := self evaluator targetEvaluation
		glPushMatrix	// 1.4
		glTranslated(80, -14 * vInc, 0)
		Colors at("darkGray") glColor
		ChinaApp drawString(cs movesFromStart asString)
		glTranslated(0, -0.25 * vInc, 0)
		
		Colors at("gray") glColor
		glLineWidth(1)
		glBegin(GL_LINE_LOOP)
		glVertex2d(0, 0)
		glVertex2d(barMaxLength, 0)
		glVertex2d(barMaxLength, barThick * 6)
		glVertex2d(0, barThick * 6)
		glEnd
		cs evals foreach(i, e,
			self dir at(i + 1) arrowColor glColor
			barLength := barMaxLength * (tEval + e) / tEval
			glBegin(GL_QUADS)
			glVertex2d(0, 0)
			glVertex2d(barLength, 0)
			glVertex2d(barLength, barThick)
			glVertex2d(0, barThick)
			glEnd
			glTranslated(0, barThick, 0)
		)
		glPopMatrix			// 1.4

		glPopMatrix	// 1
	)
	
	paintMovingPiece := method(x, y, horInc,
		cs := self currentState
		cSize := horInc / (3 sqrt) ceil
		pSize : cSize / (2) floor
		glPushMatrix
		glTranslated(x, y, 0)
		quad := gluNewQuadric
		self dir at(cs pieceType) pieceColor glColor
		gluDisk(quad, 0, pSize, 90, 1)
		self dir at(cs pieceType) pieceColor2 glColor		// darker outline
		gluDisk(quad, pSize - 1, pSize, 90, 1)
		glPopMatrix
	)
	
	lastMove := method(self currentState creator)
	
	teamThatDidLastMove := method(
		return if(lastMove, self teamPolarities at(lastMove stateBefore pieceType), Nil)
	)
	
	teamToMove := method(
		return self teamPolarities at(self currentState pieceType)
	)
	
	humanMustSkip := method(
		return ((teamToMove == -1) and (self currentState hasRealMove == Nil))
	)
	
	clickedCell := method(x, y, horInc, btnState, devMode,
	writeln( "clickedCell: ", x, y )
		cs := self currentState
		row := 0 + (y / vertInc(horInc) + 0.5) floor
		col := 0 + ((x / horInc) - (row / 2) + 0.5) floor
		c := cellAtRowCol(row, col)
		if (c) then (
			pType := cs getBoard at(c pos)
			if (btnState == 0) then (
				// Mouse button is pressed
				//writeln("clickedCell: ", x, " ", y, " row=", row, " col=", col, " pType=", pType)
				if ((devMode == Nil) and (teamToMove == 1) and (pType > 0)) then (
					return -1								// machine to move
				)
				if (pType == cs pieceType) then (
					if (cs pieceTypeHasMadeIt) then (
						return -2
					) else (
						self selectedPos = c pos
						return Nil
					)
				) else (
					return if(pType > 0, -3, Nil)		// not the one to do a move, or empty
				)
			) elseif (btnState == 1) then (
				// Mouse button is released
				if (self selectedPos < 0, return Nil)
				move := cs acceptableMove(self selectedPos, c pos)
				if (move) then (
					self curRevealed = -1
					self moveTrace = Nil
					self currentState = move getStateAfter(1)
					self selectedPos = -1
					return 1
				) elseif (c pos == selectedPos) then (
					self selectedPos = -1
					return Nil								// released at the same cell
				) else (
					sType := cs getBoard at(selectedPos)
					self selectedPos = -1
					// Cell is already taken (pType > 0), or not legal move
					//writeln(sType, " ", c cType, " ", legalDestType(sType, c cType))
					return if(pType > 0, -4, if(legalDestType(sType, c cType), -5, -6))
				)
			)
		) elseif (self selectedPos >= 0) then (
			self selectedPos = -1
			return -7
		)
	)
	
	automaticMove := method(showDetails,
		cs := self currentState
		move := Nil
		if ((self variations) and (cs getPossibleMoves count > 1)) then (
			bestMoves := cs movesWithRelGainAtLeast(0.95)
			if (bestMoves first gain > 0) then (
				accumGain := 0
				bestMoves foreach(i, mv, accumGain = accumGain + mv gain)
				randGain := self random value(accumGain)
				if (showDetails,
					writeln(cs movesFromStart + 1, ": ", bestMoves count,
						" ag=", accumGain, " randGain=", randGain)
				)
				accumGain = 0
				move = bestMoves detect(i, mv,
					(accumGain = accumGain + mv gain) >= randGain
				)
			) else (
				// All moves have negative gain. Keep it simple ...
				move = bestMoves random
			)
			if (showDetails, writeln("gain of rand. move: ", move gain))
		) else (
			move = cs getPossibleMoves first
		)
		self curRevealed = -1
		self moveTrace = Nil
		info := Nil
		if (move isReal,
			self moveTrace = cs stepTrace(move)
			info = Buffer clone append((cs movesFromStart + 1) asString)
			info append(": count=", cs getPossibleMoves count asString)
			info append(", gain=", move gain asString)
		)
		self currentState = move getStateAfter(1);
		return info
	)
	
	pieceTypeThatJustMadeIt := method(
		if (lastMove,
			if (self currentState pieceTypeHasMadeIt(lastMove stateBefore pieceType),
				if (lastMove gain > 0, return lastMove stateBefore pieceType)
			)
		)
		return Nil
	)
	
	gameOver := method(
		notYet := self teamPolarities detect(i, tPol,
			(tPol != 0) and (self currentState pieceTypeHasMadeIt(i) == Nil)
		)
		return (notYet == Nil)
	)
	
	undoLastMove := method(
		if (lastMove,
			self currentState = lastMove stateBefore
			self curRevealed = -1
			self moveTrace = Nil
		)
	)
	
	currentRevealedMove := method(
		if (self curRevealed >= 0,
			m := self currentState getPossibleMoves at(self curRevealed)
			if (m isReal, return m)
		)
		return Nil
	)
	
	revealNextMove := method(inc,
		pMoves := self currentState getPossibleMoves
		mCount := pMoves count
		if (mCount > 0,
			if ((self curRevealed < 0) and (inc < 0), inc = 0)
			self curRevealed = self curRevealed + inc + mCount % mCount
			m := currentRevealedMove
			if (m and (m isReal),
				info := Buffer clone
				info append("Possible move ", (self curRevealed + 1) asString, "/")
				info append(mCount asString, ", gain=", m gain asString(0, 1))
				relGain := 0 + (m gain) / (pMoves first gain)
				info append(" (", relGain asString(0, 3), ")")
				return info asString
			)
		)
		return Nil
	)
	
	saveGame := method(filePath,
		try (
			moves := List clone
			gs := self currentState
			while (gs creator,
				moves push(gs creator)
				gs = gs creator stateBefore
			)
			file := File clone setPath(filePath)
			if (file exists, file remove)
			file open
			file write("newGame(", if(self shortJumps, "1", "Nil"), ", {")
			self teamPolarities foreach(i, tp,
				file write(tp asString)
				if (i < 6, file write(", "))
			)
			// Note: 'moves last' is now the first move in the game.
			file write("}, ",
				self teamPolarities at(moves last stateBefore pieceType) asString, ")\n")
			file write("moves({\n")
			m := Nil
			while (m = moves pop,
				file write("{", m startPos asString, ", ", m destPos asString, "},\n")
			)
			file write("Nil})\n")
			file close
		) catch (Exception, e,
			writeln("*** saveGame: ", e name, ": ", e description)
			return e
		)
		return Nil	// normal
	)
	
	loadGame := method(filePath,
		try (
			Object do(curlyBrackets := getSlot("list"))	// to enable {a, b, ...}
			
			// When the block below is called (in the doFile), the new empty game
			// has already been created (thanks to the newGame call in the doFile).
			moves := block(mvList,
				mvList foreach(i, mv,
					if (mv,
						move := self currentState acceptableMove(mv first, mv last)
						if (move) then (
							self currentState = move getStateAfter(1)
						) else (
							return mv	// bad move
						)
					)
				)
				return Nil
			)
			
			if (badMove := doFile(filePath)) then (
				return badMove
			) else (
				return File clone setPath(filePath)
			)
		) catch (Exception, e,
			writeln("*** loadGame: ", e name, ": ", e description)
			return e
		)
	)
	
)	// ChinaBoard


Dialog := Object clone do(
	setParent(OpenGL)
	prompt := Nil
	inBuf := Nil
	cursorPos := 0
	showCursor := Nil
	actionBlock := Nil
	prevDialog := Nil
	nextDialog := Nil
	
	new := method(pr, in, action, prev,
		newD := self clone
		newD prompt = pr
		newD inBuf = Buffer clone append(in)
		newD cursorPos = in length
		newD actionBlock = getSlot("action")
		newD prevDialog = prev
		return newD
	)
	
	handleKeyboard := method(key,
		if (key == 13,					// GLUT_KEY_RETURN
			return actionBlock(self)
		)
		if (key == 27,					// GLUT_KEY_ESC
			ChinaApp setMsg(Nil)
			return self prevDialog
		)
		if (key isPrint,
			self inBuf insert(key asCharacter, self cursorPos)
			self cursorPos = self cursorPos + 1
		)
		if (key == GLUT_KEY_DELETE,
			if (self cursorPos > 0,
				self inBuf removeFromTo(self cursorPos - 1, self cursorPos)
				self cursorPos = self cursorPos - 1
			)
		)
		return self
	)
	
	handleSpecial := method(key,
		if (key == GLUT_KEY_UP) then (
			self cursorPos = 0
		) elseif (key == GLUT_KEY_DOWN) then (
			self cursorPos = self inBuf length
		) elseif (key == GLUT_KEY_LEFT) then (
			if (self cursorPos > 0, self cursorPos = self cursorPos - 1)
		) elseif (key == GLUT_KEY_RIGHT) then (
			if (self cursorPos < self inBuf length, self cursorPos = self cursorPos + 1)
		)
	)
	
	prevDialogActionApproved := method(
		return self prevDialog actionBlock(self prevDialog, 1)
	)
	
	toggleCursor := method(self showCursor = if(self showCursor, Nil, self))
	
	input := method(self inBuf asString)
	inputLeft := method(input substring(0, self cursorPos))	// before cursor
	inputRight := method(input substring(self cursorPos))		// after cursor
	
	asList := method(list(self prompt, input))
)	// Dialog


//ChinaApp := Object clone do(
ChinaApp := Object clone setProto( Visual ) do (
	setParent(OpenGL)
	user := Nil
	winWidth := 640
	winHeight := 640
	bkgndColor := Color clone set(0.55, 0.7, 0.55, 1)
	board := ChinaBoard clone
	useAllColors := Nil
	shortJumps := 1
	team1 := -1					// the team to do the very first move (-1: human)
	horInc := 32
	boardLeft := -60
	fontSize := 16
	msgText := Nil
	dialog := Nil
	cursorInterval := 400	// millis
	mustSkipMsg := "(Type M to proceed to the next color.)"
	developerMode := Nil
	showPosEval := Nil
	motionX := Nil
	motionY := Nil
	paintList := Nil
	gameFilename := "game.txt"
	mouseIsDown := Nil
)

ChinaApp drawBorder := Nil

ChinaApp setMsg := method(msg,
	self msgText = if((msg type == "List") or (msg == Nil), msg, list(msg))
)

ChinaApp addMsg := method(msg,
	if (msg, if (self msgText, self msgText add(msg), setMsg(msg)))
)

ChinaApp boardStateIsInitial := method(
	return (self board currentState creator == Nil)
)

ChinaApp newGame := method(
	self board newGame(self shortJumps, self teamPolarities, self team1)
)

ChinaApp setBackground := method(
	self bkgndColor do(
		OpenGL glClearColor(red, green, blue, alpha)
	)
)

ChinaApp teamPolarities := method(
	if(self useAllColors, list(0, 1, 1, 1, -1, -1, -1), list(0, 0, 1, 0, 0, -1, 0))
)

ChinaApp dataPath := method(fileName, launchPath appendPath(fileName))

ChinaApp configure := method(
	configPath := dataPath("chinaConfig.io")
	try (
		if (File clone setPath(configPath) exists) then (
			configMap := doFile(configPath)
			self user = configMap at("user")
			if (bg := configMap at("bkgndColor"),
				self bkgndColor = bg
				if (self hasSlot("run"), setBackground)		// refresh
			)
			if (ww := configMap at("winWidth"), self winWidth = ww)
			if (wh := configMap at("winHeight"), self winHeight = wh)
			if (hi := configMap at("horInc"), self horInc = hi)
			self useAllColors = configMap at("useAllColors")
			self shortJumps = configMap at("shortJumps")
			return Nil	// normal
		) else (
			return ("No file '" .. configPath .. "'")
		)
	) catch (Exception, e,
		writeln("*** configure: ", e name, ": ", e description)
		return e description
	)
)

ChinaApp setupFont := method(
	if (Lobby hasSlot("ResourceManager") == Nil,
		rsrcPath := "./IoResources"
		if (Directory clone setPath(rsrcPath) exists) then (
			Importer addSearchPath(rsrcPath appendPath("Interface/Ion"))
			ResourceManager
			writeln("ResourceManager OK")
		) else (
			writeln("Couldn't find IoResources.")
		)
	)
	if (Lobby hasSlot("ResourceManager")) then (
		FontManager addPath(rsrcPath appendPath("Library/Fonts"))
		self font := FontManager item("Vera/Sans/Normal") setPixelSize(self fontSize)
	) else (
		writeln("Couldn't find any fonts.")
	)
)

ChinaApp drawString := method(string,
	if (self ?font) then (
		self font drawString(string)
	) else (
		glPushMatrix
		glScaled(0.14, 0.1, 0)
		glutStrokeString(0, string)
		glPopMatrix
	)
)

ChinaApp drawMessageBox := method(
	if (self dialog,
		self msgText = self dialog asList
	)
	if (self msgText,
		glPushMatrix
		glColor4d(1, 1, 1, 0.6)
		extBorder := 4
		lineHeight := self fontSize * 1.3
		boxHeight := lineHeight * (self msgText count + 1)
		glBegin(GL_QUADS)
		glVertex2d(extBorder, extBorder)
		glVertex2d(self winWidth - extBorder, extBorder)
		glVertex2d(self winWidth - extBorder, boxHeight)
		glVertex2d(extBorder, boxHeight)
		glEnd
		glTranslated(20, boxHeight - (self fontSize * 0.25), 0)
		glColor4d(0, 0.15, 0.1, 1)
		self msgText foreach(i, s,
			glTranslated(0, -lineHeight, 0)
			drawString(s)
		)
		if (self dialog and (self dialog showCursor),
			if (self ?font) then (
				glTranslated(self font widthOfString(self dialog inputLeft), 0, 0)
				glColor4d(1, 0, 0, 1)
				glBegin(GL_LINES)
				glVertex2d(0, -6)
				glVertex2d(0, 16)
				glEnd
			) else (
				glPushMatrix
				glScaled(0.14, 0.1, 0)
				glColor4d(0, 0, 0, 0)
				glutStrokeString(0, self dialog inputLeft)
				glColor4d(1, 0, 0, 1)
				glBegin(GL_LINES)
				glVertex2d(0, -60)
				glVertex2d(0, 150)
				glEnd
				glPopMatrix
			)
		)
		glPopMatrix
	)
)

ChinaApp boardTop := method(self horInc * 1.5)

//ChinaApp display := method(
ChinaApp drawVisual := method (
  Graphics stack (
        Graphics color( 0.55, 0.7, 0.55, 1 )
        Graphics drawSolidRect( 0, 0, width, height )
        glTranslated( 0, winHeight, 0 )
        glScaled( 1, -1, 1 )
	//glClear(GL_COLOR_BUFFER_BIT)
	//glLoadIdentity
	if (self paintList) then (
		//writeln("paintList call")
		self paintList call
	) else (
		self paintList = DisplayList clone
		//writeln("new paintList id=", self paintList id)
		self paintList begin
		self board paint(self boardLeft, self winHeight - boardTop, self horInc,
								self showPosEval)
		self paintList end
		self paintList call
	)
	if (self motionX and (self board selectedPos >= 0),
		self board paintMovingPiece(self motionX, self motionY, self horInc)
	)
	drawMessageBox
/*
	glFlush
	glutSwapBuffers
*/
  )
)

ChinaApp msgAboutWhatsNext := method(
	if (doneType := self board pieceTypeThatJustMadeIt,
		head := if(self board teamThatDidLastMove == 1,
			"My ", "Congratulations! Your "
		) .. (self board dir at(doneType) colorName)
		setMsg(head .. " color has just completed.")
	)
	if (self board gameOver) then (
		addMsg("GAME OVER. (Type G if you want to play again.)")
	) else (
		if (self board humanMustSkip, addMsg(self mustSkipMsg))
	)
)

ChinaApp setDialog := method(prompt, input, actionBlock,
	newDialog := Dialog new(prompt, input, getSlot("actionBlock"), self dialog)
	if (self dialog) then (
		self dialog nextDialog = newDialog
	) else (
		glutTimerFunc(self cursorInterval, 0)	// to get a blinking cursor
	)
	self dialog = newDialog
	return newDialog
)

ChinaApp loadGameWithDialog := method(
	setDialog("Load game from:", self gameFilename,
		block(thisDialog,
			res := self board loadGame(dataPath(thisDialog input))
			if (res type == "File") then (
				self gameFilename = res name
				fileDate := res lastDataChangeDate asString("%d-%b, %H:%M")
				setMsg(Buffer clone append("Game loaded from file '", res name,
							"' (", fileDate, ")"))
			) elseif (res type == "List") then (
				setMsg(Buffer clone append("Move ", res first, " -> ", res last, " not accepted"))
			) elseif (res type == "Exception") then (
				setMsg(res description)
			) else (
				setMsg("Loaded nothing (" .. (res type) .. ")")
			)
			self shortJumps = self board shortJumps
			self paintList = Nil
			return Nil
		)
	)
)

ChinaApp saveGameWithDialog := method(
	setDialog("Save game to:", self gameFilename,
		block(thisDialog, approved,
			file := File clone setPath(dataPath(thisDialog input))
			if ((file exists) and (approved == Nil)) then (
				setDialog("This file exists. Replace? (y/n)", "",
					block(thisDialog,
						if (thisDialog input upper beginsWith("Y")) then (
							return thisDialog prevDialogActionApproved
						) else (
							return thisDialog prevDialog
						)
					)
				)
				return thisDialog nextDialog
			) else (
				self gameFilename = thisDialog input
				err := self board saveGame(dataPath(thisDialog input))
				setMsg(if(err, err description,
					Buffer clone append("Game saved to '", self gameFilename, "'")))
				return Nil
			)
		)
	)
)

//ChinaApp keyboard := method(key, x, y,
ChinaApp keyDown := method( event,
	//writeln("keyboard: ", key)
	if (self dialog,
		self dialog = self dialog handleKeyboard(event key)
		self display
		return
	)
	kChar := event key asCharacter
	setMsg(Nil)
	if ((kChar upper == "H") or (kChar == "?"),
		setMsg(list("These are the most useful commands:",
			"  M - for the program to do a move",
			"  Z - to undo a move",
			"  G - to start a new game",
			"  B - to switch between who will begin the next game",
			"  A - to switch between using only two, or all siz colors",
			"  J - to switch between using short or long jumps",
			"  L - to load a game from a file",
			"  S - to save the current game to a file",
			"  C - to reload the configuration file",
			"(Click the mouse to hide this help.)"))
	)
	if (kChar upper == "B",
		self team1 = self team1 * -1
		if (boardStateIsInitial) then (
			newGame
			setMsg(if(self team1 == 1, "I'll begin. (Type M)",
						"OK, " .. if(self user, user .. ", ", "") .. "you start."))
		) else (
			setMsg("OK, " .. if(self team1 == 1, "I'll", "you can") .. " begin in the next game.")
		)
	)
	if (kChar upper == "A",
		self useAllColors = if(self useAllColors, Nil, 1)
		if (boardStateIsInitial) then (newGame) else (
			setMsg("In the next game (type G) the board will use " .. if(self useAllColors,
						"ALL SIX colors.", "ONLY TWO colors."))
		)
	)
	if (kChar upper == "J",
		self shortJumps = if(self shortJumps, Nil, 1)
		shortOrLong := if(self shortJumps, "SHORT jumps only.", "LONG jumps.")
		if (boardStateIsInitial) then (
			newGame
			setMsg("Now it's " .. shortOrLong)
		) else (
			setMsg("In the next game (type G) we'll allow " .. shortOrLong)
		)
	)
	if (kChar upper == "G", newGame)
	if (kChar upper == "M",
		showDetails := self developerMode and (kChar == "M")		// upper case
		if ((self board teamToMove == 1) or (self board humanMustSkip) or (self developerMode)) then (
			info := self board automaticMove(showDetails)
			msgAboutWhatsNext
		) else (
			setMsg("Please move one of your " .. (self board nameOfColorToMove) .. " pieces!")
		)
	)
	if (kChar upper == "Z",
		if ((self board teamThatDidLastMove == 1) and (self developerMode == Nil)) then (
			setMsg("You may only undo your own moves, not mine.")
		) else (
			self board undoLastMove
		)
	)
	if (kChar upper == "L", loadGameWithDialog)
	if (kChar upper == "S", saveGameWithDialog)
	if (kChar upper == "D",
		self developerMode = if(self developerMode, Nil, 1)
		if (self developerMode) then (
			setMsg("Beware: Developer mode! (Type D to get normal.)")
		) else (
			setMsg("You're now back in normal user mode.")
			self showPosEval = Nil
		)
	)
	if (self developerMode,
		if (kChar == "r", setMsg(self board revealNextMove(1)))
		if (kChar == "R", setMsg(self board revealNextMove(-1)))
		if (kChar upper == "E", self showPosEval = if(self showPosEval, Nil, 1))
		if (kChar == "$", testDialog)
	)
	if (kChar upper == "C",
		if (err := configure) then (
			setMsg(err)
		) else (
			t := Date clone now asString("%H:%M:%S")
			setMsg(t .. " - New configuration loaded")
		)
	)
	self paintList = Nil
	self display
)

ChinaApp special := method(key, x, y,
	//writeln("special: ", key)
	if (self dialog) then (
		self dialog handleSpecial(key)
	) else (
		if (key == GLUT_KEY_UP) then (
			self horInc = self horInc + 1
			setMsg("horInc = " .. horInc)
		) elseif (key == GLUT_KEY_DOWN) then (
			self horInc = self horInc - 1
			setMsg("horInc = " .. horInc)
		) elseif (key == GLUT_KEY_LEFT) then (
			self horInc = self horInc - 1
			setMsg("horInc = " .. horInc)
		) elseif (key == GLUT_KEY_RIGHT) then (
			self horInc = self horInc + 1
			setMsg("horInc = " .. horInc)
		)
		self paintList = Nil
	)
	self display
)

//ChinaApp motion := method(x, y,
ChinaApp mouseMove := method( event,
    if( mouseIsDown ) then (
	if (self board selectedPos >= 0) then (
		self motionX = event x
		self motionY = self winHeight - event y
		//self motionY = event y
		self display
	)
	invalidate()
    )
)

ChinaApp passiveMotion := method(x, y,
	if (self board moveTrace,
		self board moveTrace = Nil
		self paintList = Nil
		self display
	)
)

ChinaApp negatives := list(
	// Corresponding to clickedCell return values -1 through -7
	"It's my turn! Type M, and I'll move something myself ...",
	"That color has completed it's mission! Type M.",
	"Sorry, wrong color!",
	"Sorry, that cell is already taken!",
	"Sorry, that's just not a valid move!",
	"You cannot leave that piece in an area belonging to another color!",
	"Do you want to retire this guy?"
)

//ChinaApp mouse := method(button, state, x, y,
ChinaApp mouseDown := method( event,
        writeln( "mouseDown" )
        self mouseIsDown = 1
        
	if (self dialog) then (
		if ((self dialog ?finalFlag) isNil,
			setDialog("You cannot use the mouse while a dialog is active!", "",
				block(thisDialog, return thisDialog prevDialog)
			) finalFlag := 1
		)
	) else (
		res := self board clickedCell(event x - (self boardLeft), event y - boardTop,
						self horInc, 0, self developerMode)
		if (res == 1) then (
			msgAboutWhatsNext
		) elseif (res < 0) then (
			setMsg(self negatives at(-1 - res))
		) else (
			setMsg(Nil)
		)
		self motionX = Nil
		self motionY = Nil
		self paintList = Nil
	)
	self display
)

ChinaApp mouseUp := method( event,
        self mouseIsDown = Nil
        
	if (self dialog) then (
		if ((self dialog ?finalFlag) isNil,
			setDialog("You cannot use the mouse while a dialog is active!", "",
				block(thisDialog, return thisDialog prevDialog)
			) finalFlag := 1
		)
	) else (
		res := self board clickedCell(event x - (self boardLeft), event y - boardTop,
						self horInc, 1, self developerMode)
		if (res == 1) then (
			msgAboutWhatsNext
		) elseif (res < 0) then (
			setMsg(self negatives at(-1 - res))
		) else (
			setMsg(Nil)
		)
		self motionX = Nil
		self motionY = Nil
		self paintList = Nil
	)
	self display
)

ChinaApp Xreshape := method(w, h, 
	self winWidth = w
	self winHeight = h
	glViewport(0, 0, w, h)
	glMatrixMode(GL_PROJECTION)
	glLoadIdentity
	gluOrtho2D(0, w, 0, h)

	glMatrixMode(GL_MODELVIEW)
	glLoadIdentity
	setBackground
	display
)

ChinaApp Xtimer := method(v,
	//writeln("timer ", v)
	if (self dialog,
		self dialog toggleCursor
		glutTimerFunc(self cursorInterval, 0)
	)
	self display
)

ChinaApp run := method(
	hello := "Welcome to Chinese Checkers"
	if (self user, hello = hello .. ", " .. user)
	setMsg(list(hello .. "!", "You may type H to get help."))
/*	
	glutInitDisplayMode(GLUT_DOUBLE | GLUT_RGBA)
	glutInitWindowSize(self winWidth, self winHeight)
	glutInitWindowPosition(200, 60)
	glutInit
	glutCreateWindow("Chinese Checkers")
	glutEventTarget(self)
	glutDisplayFunc
	glutKeyboardFunc
	glutSpecialFunc
	glutMotionFunc
	glutMouseFunc
	glutPassiveMotionFunc
	glutReshapeFunc
	
	glEnable(GL_LINE_SMOOTH)
	glEnable(GL_BLEND)
	glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA)
		//glBlendFunc(GL_SRC_ALPHA, GL_ONE)
		//glHint(GL_LINE_SMOOTH_HINT, GL_NICEST)
	glutMainLoop
*/
)

ChinaApp testDialog := method(
	setDialog("Test:", "abc",
		block(thisDialog, approved,
			write("Test got Return, ")
			if ((thisDialog input beginsWith("ap")) and (approved == Nil)) then (
				writeln("but we need to confirm ...")
				setDialog("Really? (y/n)", "",
					block(thisDialog,
						write("Really got Return")
						if (thisDialog input == "y") then (
							return thisDialog prevDialogActionApproved
						) else (
							return thisDialog prevDialog
						)
					)
				)
				return thisDialog nextDialog
			) else (
				writeln("that's all.")
				setMsg("Input was: " .. (thisDialog input))
				return Nil
			)
		)
	)
)

ChinaApp do(
	configure
	setupFont
	newGame
	run
)

Window clone do (
  init := method (
    resend()
    addChild( china := ChinaApp clone do (
      width = 400; height = 300
      reshape = list( Reshape Size, Reshape Size )
    ))
    width = 640; height = 640 + 20; sizeChanged = 1
    focusedVisual = china
  )
)

