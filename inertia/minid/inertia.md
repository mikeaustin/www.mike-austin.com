module inertia

import sdl
import gl

import views

//                                                                           //
// ========================================================================= //
//                                                                           //

local width  = 1024
local height = 768

global screen = views.Screen $ \
{
    :extent  = Vector.fromArray( "i16", [width, height] )
    //:content = Vector.fromArray( "f32", [0.4, 0.4, 0.4] )
    //:content = Vector.fromArray( "f32", [1.0, 1.0, 1.0] )
    //:content = Vector.fromArray( "f32", [0.6, 0.8, 1.0] )
    :content = Vector.fromArray( "f32", [0.65, 0.75, 0.85] )
}

local window = views.Window $ \
{
    :origin = Vector.fromArray( "i16", [10, 10] )
    :extent = Vector.fromArray( "i16", [400, 300] )
    
    this["button"] = views.Button $ \
    {
        :origin = Vector.fromArray( "i16", [150, 50] )
        :extent = Vector.fromArray( "i16", [100, 25] )
        :reshape = ["center", "center"]
        :action = \ -> screen.addChild( views.Window() )
    }, "Press Me!"
}

screen.addChild( views.Window() )
screen.addChild( window )

function initSDL()
{
    sdl.init( sdl.initEverything )

    sdl.gl.setAttribute( sdl.gl.bufferSize, 32 )
    sdl.gl.setAttribute( sdl.gl.depthSize, 16 )
    sdl.gl.setAttribute( sdl.gl.doubleBuffer, 1 )

    sdl.setCaption( "MiniD-Inertia" )
    sdl.showCursor( true )

    if (!sdl.setVideoMode( width, height, 32, sdl.opengl | sdl.hwSurface ))
        if(!sdl.setVideoMode( width, height, 32, sdl.opengl | sdl.swSurface ))
            throw "Could not set video mode"
}

function initGL()
{
    gl.load()

    gl.glViewport( 0, 0, width, height )

    gl.glMatrixMode( gl.GL_PROJECTION )

        gl.glLoadIdentity()
        gl.gluOrtho2D( 0, width, height, 0 )

    gl.glMatrixMode( gl.GL_MODELVIEW )
    
    //gl.glFrontFace( gl.GL_CW )
    gl.glEnable( gl.GL_LINE_SMOOTH )
    gl.glBlendFunc( gl.GL_SRC_ALPHA, gl.GL_ONE_MINUS_SRC_ALPHA )
    gl.glEnable( gl.GL_BLEND )
}

initSDL()
initGL()

local quit  = false
local mouse = Vector.fromArray( "i16", [0, 0] )
local mouseState = false

sdl.event.setHandler $ sdl.event.mouseButton, \state, button
{
    mouseState = state
    
    if (state == true)
        screen.sendEvent( views.MouseEvent( "mouseDown", [mouse[0], mouse[1]] ) )
    else
        screen.sendEvent( views.MouseEvent( "mouseUp", [mouse[0], mouse[1]] ) )
}

sdl.event.setHandler $ sdl.event.mouseMotion, \x, y, xd, yd
{
    mouse[0] = x
    mouse[1] = y

    if (mouseState == true)
        screen.sendEvent( views.MouseEvent( "mouseMove", [mouse[0], mouse[1]] ) )
}

while( !quit )
{
    sdl.event.poll()
    
    gl.glClear(gl.GL_COLOR_BUFFER_BIT | gl.GL_DEPTH_BUFFER_BIT)

        screen.draw()
 
    sdl.gl.swapBuffers()
}

