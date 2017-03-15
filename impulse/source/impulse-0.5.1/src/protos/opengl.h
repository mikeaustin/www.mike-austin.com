//
// protos/opengl.h
//
// Copyright (c) 2008-2009, Mike Austin
// All rights reserved.
//

#ifndef _IMPULSE_OPENGL_H_
#define _IMPULSE_OPENGL_H_

#include <cmath>

#ifdef __APPLE__
 #include <GLUT/glut.h>
#else
 #include <GL/gl.h>
 #include <GL/glu.h>
 #include <GL/glut.h>
#endif

#include "../impulse.h"
#include "string.h"
#include "block.h"

namespace impulse {

    extern Value _OpenGL_;

 //
 // class OpenGL
 //

 ///
 /// OpenGL is a prototype for the OpenGL 2D/3D graphics library.  It currently uses GLUT as its
 /// Windowing abstraction.  Call "gl display:" with a block to set the rendering function
 ///

    class OpenGL : public Frame {

     public:

        OpenGL( Frame* proto = _OpenGL_.getFrame() ) : Frame( proto ) { }
		
        string inspect() { return "[OpenGL]"; }

        static Block* display;

    };

    Block* OpenGL::display = NULL;

    class OpenGLProto : public OpenGL {
    
     public:

        OpenGLProto() : OpenGL( _Object_.getFrame() ) { }

        string inspect() { return "[OpenGLProto]"; }

        static void display()
        {
            if (!OpenGL::display) { cout << "OpenGL::display not set" << endl; return; }
            
            glClear( GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT );

            glMatrixMode( GL_PROJECTION );
                glLoadIdentity();
                gluPerspective( 45.0, 1.0, 1.0, 10.0 );
            glMatrixMode( GL_MODELVIEW );
            
            glLoadIdentity();
            glTranslatef( 0.0, 0.0, -3.0 );

            Array args;
            glBegin( GL_LINES );
                OpenGL::display->call( args, OpenGL::display );
            glEnd();
            
            glutSwapBuffers();
        }

        void initSlots()
        {
            _Lobby_.setSlot( Symbol::at( "gl" ), _OpenGL_ );

            setSlot( Symbol::at( "display:" ), new Method<OpenGLProto>( &OpenGLProto::_display_, _Block_.getFrame() ) );
            setSlot( Symbol::at( "main-loop" ), new Method<OpenGLProto>( &OpenGLProto::_mainLoop ) );
            setSlot( Symbol::at( "vertex:" ), new Method<OpenGLProto>( &OpenGLProto::_vertex_, _Point_.getFrame() ) );
            setSlot( Symbol::at( "color:" ), new Method<OpenGLProto>( &OpenGLProto::_color_, _Array_.getFrame() ) );

            static int argc = 0;
            static const char* argv[] = { "" };

            glutInit( &argc, (char**) argv );
            glutInitDisplayMode( GLUT_RGBA | GLUT_DOUBLE | GLUT_DEPTH );
            //glutInitWindowPosition( 20, 20 );
            glutCreateWindow( "Impulse" );
            glutReshapeWindow( 600, 600 );
            glutDisplayFunc( display );
            
            glBlendFunc( GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA );
            glEnable( GL_BLEND );
            glEnable( GL_LINE_SMOOTH );
        }

        Value _display_( Array& args, Value self )
        {
            OpenGL::display = args.at( 0 ).get<Block>();
            glutPostRedisplay();
            
            return _nil_;
        }

        Value _mainLoop( Array& args, Value self )
         { return glutMainLoop(), _nil_; }

        Value _vertex_( Array& args, Value self )
        {
            Value point = args.at( 0 );

            return glVertex2f( point.getX(), point.getY() ), _nil_;
        }

        Value _color_( Array& args, Value self )
        {
            Array& array = *args.at( 0 ).get<Array>();

            glColor4f( array.at( 0 ).getFloat(), array.at( 1 ).getFloat(), array.at( 2 ).getFloat(), array.at( 3 ).getFloat() );

            return _nil_;
        }
     
    };

    Value _OpenGL_ = new OpenGLProto();

}

#endif

