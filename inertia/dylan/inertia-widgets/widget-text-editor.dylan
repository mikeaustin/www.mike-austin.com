module:    inertia-shapes
synopsis:  Core UI widgets
author:    Mike Austin
copyright: Copyright (C) 2005 Mike L. Austin.  All rights reserved.
license:   MIT/BSD, see LICENCE.txt for details

//
// widget-text-editor.dylan
//

// -------------------------------------------------------------------------- //
// class definitions
// -------------------------------------------------------------------------- //

//define class <editor-line> (<object>)
//  slot line-buffer = make (<string>);
//end;

define class <text-editor> (<widget>)
  inherited slot fill-color = #[1.0, 1.0, 1.0, 1.0];
  slot editor-lines = make (<deque>);
  slot editor-cursor = make (<point>, x: 2, y: 0);
end;

define method initialize (editor :: <text-editor>, #rest init-args, #key content)
 => ()
  next-method ();
  push-last (editor.editor-lines, "ONE");
  push-last (editor.editor-lines, "TWO");
  push-last (editor.editor-lines, "THREE");
end;

define class <text-field> (<text-editor>)
  keyword height: = 25.0;
end;

// -------------------------------------------------------------------------- //
// method definitions
// -------------------------------------------------------------------------- //

define method draw-overlay (shape :: <shape>, editor :: <text-editor>) => ()
  let (cursor-x, cursor-y) = editor.editor-cursor.point-values;

  for (line in editor.editor-lines, top from 5 by 15)
    glColor (0.0, 0.0, 0.0);
    glRasterPos (5 + 0, top + 10);
    glutxBitmapString ($GLUT-BITMAP-HELVETICA-12, line);
  end;

  let pos = glutxBitmapLength ($GLUT-BITMAP-HELVETICA-12,
    copy-sequence (editor.editor-lines[cursor-y],
      start: 0, end: truncate (cursor-x)));

  with-glBegin ($GL-LINES)
    //glVertex (as(<double-float>, pos) + 5.0, as(<double-float>, cursor-y) +  5, 0.0);
    //glVertex (as(<double-float>, pos) + 5.0, as(<double-float>, cursor-y) + 17, 0.0);
    glVertex (as(<double-float>, pos) + 5.0, as(<double-float>, cursor-y * 15) + 17, 0.0);
    glVertex (as(<double-float>, pos) + 3.0, as(<double-float>, cursor-y * 15) + 19, 0.0);
    glVertex (as(<double-float>, pos) + 5.0, as(<double-float>, cursor-y * 15) + 17, 0.0);
    glVertex (as(<double-float>, pos) + 7.0, as(<double-float>, cursor-y * 15) + 19, 0.0);
  end;
end;

define method on-key-event
    (editor :: <text-editor>, event :: <key-down-event>, key :: <integer>)
 => ()
  format-out ("key: %=\n", key);
  if (key < 256)
    let (cursor-x, cursor-y) = editor.editor-cursor.point-values;
    format-out (">>> here\n");
    editor.editor-lines[cursor-y] :=
      replace-subsequence! (editor.editor-lines[cursor-y],
                            vector (as(<character>, key)),
                            start: cursor-x, end: cursor-x);
    editor.editor-cursor.point-x := editor.editor-cursor.point-x + 1;
    //lines[0].insert(key, x)
  end;
end;

define method on-key-event
    (editor :: <text-editor>, event :: <key-down-event>, key == $key-left)
 => ()
  if (editor.editor-cursor.point-x > 0)
    editor.editor-cursor.point-x := editor.editor-cursor.point-x - 1;
  end;
end;

define method on-key-event
    (editor :: <text-editor>, event :: <key-down-event>, key == $key-right)
 => ()
  if (editor.editor-cursor.point-x < editor.editor-lines[editor.editor-cursor.point-y].size)
    editor.editor-cursor.point-x := editor.editor-cursor.point-x + 1;
  end;
end;

define method on-key-event
    (editor :: <text-editor>, event :: <key-down-event>, key == $key-up)
 => ()
  if (editor.editor-cursor.point-y > 0)
    editor.editor-cursor.point-y := editor.editor-cursor.point-y - 1;
  end;
end;

define method on-key-event
    (editor :: <text-editor>, event :: <key-down-event>, key == $key-down)
 => ()
  if (editor.editor-cursor.point-y < editor.editor-lines.size - 1)
    editor.editor-cursor.point-y := editor.editor-cursor.point-y + 1;
  end;
end;

define method on-key-event
    (editor :: <text-editor>, event :: <key-down-event>, key == 13)
 => ()
  let (cursor-x, cursor-y) = editor.editor-cursor.point-values;
  let line = copy-sequence (editor.editor-lines[cursor-y], start: cursor-x);
  editor.editor-lines[cursor-y] :=
    replace-subsequence! (editor.editor-lines[cursor-y], #[], start: cursor-x);
  editor.editor-lines :=
    replace-subsequence! (editor.editor-lines, vector (line),
                          start: cursor-y + 1, end: cursor-y + 1);
  editor.editor-cursor := make (<point>, x: 0, y: cursor-y + 1);
end;

// -------------------------------------------------------------------------- //
// method definitions
// -------------------------------------------------------------------------- //

define method on-key-event
    (field :: <text-field>, event :: <key-down-event>, key == 13)
 => ()
end;

