module:    inertia-shapes
synopsis:  Core UI widgets
author:    Mike Austin
copyright: Copyright (C) 2005 Mike L. Austin.  All rights reserved.
license:   MIT/BSD, see LICENCE.txt for details

//
// widget-screen.dylan
//

//define class <screen> (<rectangle>)
define class <screen> (<widget>)
  inherited slot fill-color = vector (1.0, 1.0, 1.0, 1.0);
  slot mouse-origin :: <point>;
  slot grabbed-shape :: false-or (<shape>) = #f;
end;

define method class-name (screen :: <screen>) "<screen>" end;

define method add-child (screen :: <screen>, child :: <shape>) => ()
  screen.responder := child;
  next-method ()
end;

// <screen> handles mouse grabbing and setting the mouse location in mouse-origin

define method send-event
    (screen :: <screen>, event :: <mouse-event>, button :: <mouse-button>)
 => (result :: <shape>)
  screen.mouse-origin := event.origin;
  next-method ();
end;

define method send-event
    (screen :: <screen>, event :: <mouse-motion-event>, button :: <mouse-button>)
 => (result :: <shape>)
  let shape = next-method ();
  if (screen.grabbed-shape ~= #f & shape ~= screen.grabbed-shape)
    on-mouse-event (screen.grabbed-shape, make (<mouse-exit-event>,
                                                origin: event.origin), button);
    screen.grabbed-shape := shape;
    on-mouse-event (screen.grabbed-shape, make (<mouse-enter-event>,
                                                origin: event.origin), button);
  end;
  shape;
end;

define method send-event
    (screen :: <screen>, event :: <mouse-down-event>, button :: <mouse-button>)
 => (result :: <shape>)
  screen.grabbed-shape := next-method (screen, event, button);
  screen.grabbed-shape;
end;

define method send-event
    (screen :: <screen>, event :: <mouse-drag-event>, button :: <mouse-button>)
 => (result :: <shape>)
  event.origin := event.origin - screen.grabbed-shape.screen-origin;
  on-mouse-event (screen.grabbed-shape, event, button);
  screen.grabbed-shape;
end;

define method send-event
    (screen :: <screen>, event :: <mouse-up-event>, button :: <mouse-button>)
 => (result :: <shape>)
  on-mouse-event (screen.grabbed-shape, event, button);
  screen.grabbed-shape;
end;

// -------------------------------------------------------------------------- //

define method send-event
    (screen :: <screen>, event :: <key-down-event>, key :: <integer>)
 => (result :: <shape>)
  send-event (screen.responder, event, key);
end;

define method responder-setter (value :: <shape>, shape :: <screen>)
  format-out ("here\n");
  if (shape.responder ~= value)
    if (shape.responder)
      send-event (shape.responder, make (<focus-lost-event>), #f);
    end;
    send-event (value, make (<focus-gained-event>), #f);
    shape.%responder := value;
  end;
  value;
end;

