module:    inertia-test
synopsis:  Inertia test program
author:    Mike Austin
copyright: Copyright (C) 2005 Mike L. Austin.  All rights reserved.
license:   MIT/BSD, see LICENCE.txt for details

//
// inertia-test.dylan
//

define method make-from-string (string == #"<polygon>", #rest args) => (object :: <object>)
  apply (make, <polygon>, args);
end;

define method xadd-child (window :: <window>)
  curry (<window>_xadd-child, window);
end;

define method <window>_xadd-child (window :: <window>, child :: <shape>)
end;

define class <clock> (<widget>)
end;

define method draw-overlay (shape :: <shape>, clock :: <clock>)
  let time = get-decoded-time ();
  glTranslate (shape.shape-width / 2.0, shape.shape-height / 2.0, 0.0);
  with-glBegin ($GL-LINES)
    glVertex (0.0, 0.0);
    glVertex (cos (time.minutes * $double-pi), sin (time.minutes * $double-pi));
  end;
end;

begin
  format-out ("%=\n", make-from-string (as(<symbol>, "<polygon>")));
  
  define variable *editor* = make (<shape-editor>, left: 10.0, top: 10.0, width: 580.0, height: 380.0,
                                                   reshape: #[#"size", #"size"]);
  add-child (*editor*, make (<polygon>, left: 200.0, top: 200.0));
  add-child (*editor*, make (<spinning-polygon>, left: 300.0, top: 300.0));
  add-child (*editor*, make (<rectangle>, left: 400.0, top: 400.0));
  add-child (*editor*, make (<push-button>, caption: "Another"));

  define variable *window* = make (<window>, caption: "Window 1", left: 400.0, top: 200.0, width: 600.0, height: 400.0);
  add-child (*window*, *editor*);
  add-child (*window*, make (<push-button>, caption: "Press Me", reshape: #[#"move", #"move"],
                                            left: 190.0, top: 165.0));
  add-child (*screen*, make (<window>, caption: "Window 2", left: 500.0, top: 300.0));
  add-child (*screen*, make (<window>, client: make (<polygon>), left: 500.0, top: 300.0));
  add-child (*screen*, *window*);

  glutMainLoop ();
end;

