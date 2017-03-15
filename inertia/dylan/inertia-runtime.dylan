module:    inertia
synopsis:  Inertia initializations
author:    Mike Austin
copyright: Copyright (C) 2005 Mike L. Austin.  All rights reserved.
license:   MIT/BSD, see LICENCE.txt for details

//
// inertia-runtime.dylan
//

define variable *function-table* = make (<table>);

define macro method-definer
  { define ?adjectives:* method ?:name ?rest:* end }
   => { define ?adjectives dylan-method ?name ?rest end;
        *function-table*[?#"name"] := ?name }
end;

define generic make-from-symbol (symbol :: <symbol>, #rest init-args, #key);
define method make-from-symbol (symbol :: <symbol>, #rest init-args, #key) end;

define class <persistent> (<object>)
  each-subclass slot fields = make (<table>);
end;

define class <field> (<object>)
  slot category = "general", init-keyword: category:;
  slot getter, init-keyword: getter:;
  slot setter, init-keyword: setter:;
end;

// -------------------------------------------------------------------------- //

define method table (#rest args, #key, #all-keys)
  let table = make(<table>);
  for (i from 0 below args.size by 2)
    table[args[i]] := args[i + 1];
  end;
  table;
end;

define method duplicate (string :: <string>, count :: <integer>)
  let stream = make (<string-stream>, direction: #"output");
  while (count ~= 0)
    write (stream, string);
    count := count - 1;
  end;
  stream-contents (stream);
end;

define method build-object (object :: <persistent>, filename :: <string>, #key)
  let stream = make (<file-stream>, locator: filename, direction: #"input");
  build-object (object, stream);
end;

define method build-object (object :: <persistent>, stream :: <stream>, #key level = 0)
  block (return)
    let name = #f;
    let value = #f;

    while (~stream-at-end? (stream))
      block (break)
        while (whitespace? (peek (stream)))
          read (stream, 1);
        end;

        if (peek (stream) == '#')
          read-line (stream);
        end;

        let data = read-to (stream, ' ');
        if (data = "object")
          let data = read-to (stream, ' ');
          let name = as(<symbol>, copy-sequence (data, start: 0, end: data.size - 1));
          let value = read-line (stream);
          format-out ("%sobject [%s] [%s]\n", duplicate (" ", level * 2), name, value);
          let child = make-from-symbol (as(<symbol>, value));
          build-object (child, stream, level: level + 1);
          *function-table*[name] := child;
          add-child (object, child);
          break ();
        elseif (data = "end")
          return ();
        end;

        name := as(<symbol>, copy-sequence (data, start: 0, end: data.size - 1));

        let data = read-line (stream);
        value := case
          digit? (data[0]) => string-to-float (data);
          data[0] == '\"' => copy-sequence (data, start: 1, end: data.size - 1);
          alpha? (data[0]) => *function-table*[as(<symbol>, data)];
        end;

        format-out ("%s[%s] [%s]\n", duplicate (" ", level * 2), name, value);
        object.fields[name].setter (value, object);
      end block;
    end while;
  cleanup
    close (stream);
  exception (xerror :: <error>)
    //apply (format-out, xerror.condition-format-string, xerror.condition-format-arguments);
  end;
end;

define method perform (method-name :: <symbol>, #rest args)
  apply (*function-table*[method-name], args);
end;

