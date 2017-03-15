module:    inertia
synopsis:  Inertia model-view
author:    Mike Austin
copyright: Copyright (C) 2005 Mike L. Austin.  All rights reserved.
license:   MIT/BSD, see LICENCE.txt for details

//
// inertia-models.dylan
//

define class <channel> (<object>)
  slot listeners = make (<table>);
end;

define class <model> (<object>)
  slot model-channel = make (<channel>);
end;

define class <range-model> (<model>)
  slot range-minimum = 0;
  slot range-maximum = 9;
  slot range-value = 0;
end;

// -------------------------------------------------------------------------- //
// channel method definitions
// -------------------------------------------------------------------------- //

define method add-listener (channel :: <channel>, listener :: <object>,
                            message :: <symbol>, function :: <function>)
  channel.listeners[message] :=
    add! (element (channel.listeners, message, default: #[]),
          vector (listener, function));
end;

define method broadcast (channel :: <channel>, message :: <symbol>)
  for (listener in channel.listeners[message])
    apply (listener[1], vector (listener[0]));
  end;
end;

// -------------------------------------------------------------------------- //
// model method definitions
// -------------------------------------------------------------------------- //

define method set-value (model :: <range-model>, value :: <number>)
  model.range-value := value;
  broadcast (model.model-channel, #"value-changed");
end;

define method set-metrics (model :: <range-model>, minimum, maximum)
  model.range-minimum := minimum;
  model.range-maximum := maximum;
  broadcast (model.model-channel, #"metrics-changed");
end;

define method metrics-changed (object :: <object>)
end;


define class <slider> (<object>)
  slot model;
end;

define method initialize (slider :: <slider>, #rest args, #key)
  set-model (slider, make (<range-model>));
end;

define method set-model (slider :: <slider>, model :: <model>)
  slider.model := model;
  add-listener (model.model-channel, slider, #"value-changed", value-changed);
  add-listener (model.model-channel, slider, #"metrics-changed", metrics-changed);
end;

define method metrics-changed (slider :: <slider>)
  format-out ("metrics-changed (<slider>, %=)\n", slider.model.range-minimum);
end;

define method value-changed (slider :: <slider>)
  format-out ("value-changed (<slider>, %=)\n", slider.model.range-value);
end;

