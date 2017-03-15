module inertia.views

/*
local file = io.inFile( "font.raw" )
local font = file.readVector( "u8", file.size() )
file.close()

global font2 = Vector( "u8", #font )
local a
foreach ( i, v; font )
{
    if (i % 4 == 3)
        font2[ i ] = a
    else
        font2[ i ] = 256 - v
        
    a = v
}
*/

class Event
{
    type = null

    this( type: string )
    {
        :type = type
    }
}

class MouseEvent : Event
{
    point = [0, 0]

    this( type: string, point: array|Vector )
    {
        super( type )

        if (typeof(point) == "array")
            :point = Vector.fromArray( "i16", point )
        else
            :point = point
    }

    function handleEvent( view: View )
    {
        foreach (child; view.children, "reverse")
        {
            local point = :point - child.origin

            if (child.containsPoint( point ))
                return child.sendEvent( MouseEvent( :type, [point[0], point[1]] ) )
        }
        
        view.(:type)( :point )
        
        return view
    }
}

// ============================================================================================== //

class Effect
{
    function apply( view: View ) { }
}

class Shiny : Effect
{
    function apply( view: View )
    {
        gl.glBegin( gl.GL_QUAD_STRIP )
            gl.glColor4f( 1.0, 1.0, 1.0, 0.3 )
                gl.glVertex2f(              0,          0 )
                gl.glVertex2f( view.extent[0],          0 )
            gl.glColor4f( 1.0, 1.0, 1.0, 0.0 )
                gl.glVertex2f(              0,         75 )
                gl.glVertex2f( view.extent[0],         75 )
        gl.glEnd()
    }
}

class Glossy : Effect
{
    color1 = Vector.fromArray( "f32", [1.0, 1.0, 1.0, 0.5] )
    color2 = Vector.fromArray( "f32", [1.0, 1.0, 1.0, 0.1] )
    color3 = Vector.fromArray( "f32", [0.0, 0.0, 0.0, 0.01] )
    color4 = Vector.fromArray( "f32", [0.0, 0.0, 0.0, 0.0] )
    color5 = Vector.fromArray( "f32", [1.0, 1.0, 1.0, 0.5] )

    function apply( view: View )
    {
        gl.glBegin( gl.GL_QUADS )
            gl.glColor4fv( :color1 )
                gl.glVertex2f(              0,                  0 )
                gl.glVertex2f( view.extent[0],                  0 )
            gl.glColor4fv( :color2 )
                gl.glVertex2f( view.extent[0], view.extent[1] / 2 )
                gl.glVertex2f(              0, view.extent[1] / 2 )
        gl.glEnd()

        gl.glBegin( gl.GL_QUADS )
            gl.glColor4fv( :color3 )
                gl.glVertex2f(              0, view.extent[1] / 2 )
                gl.glVertex2f( view.extent[0], view.extent[1] / 2 )
            gl.glColor4fv( :color4 )
                gl.glVertex2f( view.extent[0],     view.extent[1] )
                gl.glVertex2f(              0,     view.extent[1] )
        gl.glEnd()
/*
        gl.glBegin( gl.GL_QUADS )
            gl.glColor4fv( :color2 )
                gl.glVertex2f(              0, view.extent[1] / 2 )
                gl.glVertex2f( view.extent[0], view.extent[1] / 2 )
            gl.glColor4fv( :color5 )
                gl.glVertex2f( view.extent[0],     view.extent[1] )
                gl.glVertex2f(              0,     view.extent[1] )
        gl.glEnd()
*/
    }
}

class Shaddow : Effect
{
    distance = 7.0
    alpha    = 0.3
    color1   = Vector.fromArray( "f32", [0.0, 0.0, 0.0, 0.1] )
    color2   = Vector.fromArray( "f32", [0.0, 0.0, 0.0, 0.0] )
    
    function apply( view: View )
    {
        gl.glBegin( gl.GL_QUAD_STRIP )
            gl.glColor4fv( :color1 );  gl.glVertex2f(              0, 0                          )
            gl.glColor4fv( :color2 );  gl.glVertex2f(              0, -:distance                 )
            gl.glColor4fv( :color1 );  gl.glVertex2f( view.extent[0], 0                          )
            gl.glColor4fv( :color2 );  gl.glVertex2f( view.extent[0], -:distance                 )

            gl.glColor4fv( :color1 );  gl.glVertex2f( view.extent[0],                          0 )
            gl.glColor4fv( :color2 );  gl.glVertex2f( view.extent[0] + :distance,              0 )
            gl.glColor4fv( :color1 );  gl.glVertex2f( view.extent[0],             view.extent[1] )
            gl.glColor4fv( :color2 );  gl.glVertex2f( view.extent[0] + :distance, view.extent[1] )

            gl.glColor4fv( :color1 );  gl.glVertex2f( view.extent[0], view.extent[1]             )
            gl.glColor4fv( :color2 );  gl.glVertex2f( view.extent[0], view.extent[1] + :distance )
            gl.glColor4fv( :color1 );  gl.glVertex2f(              0, view.extent[1]             )
            gl.glColor4fv( :color2 );  gl.glVertex2f(              0, view.extent[1] + :distance )

            gl.glColor4fv( :color1 );  gl.glVertex2f(              0, view.extent[1]             )
            gl.glColor4fv( :color2 );  gl.glVertex2f(     -:distance, view.extent[1]             )
            gl.glColor4fv( :color1 );  gl.glVertex2f(              0, 0                          )
            gl.glColor4fv( :color2 );  gl.glVertex2f(     -:distance, 0                          )

            gl.glColor4fv( :color1 );  gl.glVertex2f(              0, 0                          )
            gl.glColor4fv( :color2 );  gl.glVertex2f(              0, -:distance                 )
        gl.glEnd()
    }
}

Shiny.foo = function()
{
}

// ============================================================================================== //

class View : Object
{
    parent   = null
    children = null
    extent   = null
    fields   = null
    active   = false
    effects  = null

    content = Vector.fromArray( "f32", [0.875, 0.875, 0.875] )
    border  = Vector.fromArray( "f32", [0.5, 0.5, 0.5] )

    this( block = null, vararg )
    {
        :origin   = Vector.fromArray( "i16", [0, 0] )
        :extent   = Vector.fromArray( "i16", [100, 100] )
        :reshape  = ["", ""]
        :children = []
        :effects  = []
        :fields   = {}

        this.init( vararg )

        if (block) bindContext( block, this )()
    }

    function exec( block )
    {
        bindContext( block, this )( this )

        return this
    }

    function init() { }

    function setOrigin( extent: Vector )
    {
        :origin = extent
    }

    function setExtent( extent: Vector )
    {
        local delta = extent - :extent
        
        foreach (child; :children)
        {
            if (child.reshape[0] == "size" || child.reshape[1] == "size")
            {                
                local extent2 = child.extent.dup()
                
                if (child.reshape[0] == "size") extent2[0] = child.extent[0] + delta[0]
                if (child.reshape[1] == "size") extent2[1] = child.extent[1] + delta[1]

                child.setExtent( extent2 )
            }

            if (child.reshape[0] == "move" || child.reshape[1] == "move")
            {
                local origin2 = child.origin.dup()

                if (child.reshape[0] == "move") origin2[0] = child.origin[0] + delta[0]
                if (child.reshape[1] == "move") origin2[1] = child.origin[1] + delta[1]

                child.setOrigin( origin2 )
            }
        }

        :extent = extent
    }

    function screenOrigin()
    {
        local view   = this
        local origin = :origin.dup()
        
        while (view.parent)
        {
            origin += view.parent.origin
            view = view.parent
        }
        
        return origin
    }

 //
 // Hierarchy
 //

    /*function opEquals( other )
    {
        return this == other
    }*/

    function addChild( child: View )
    {
        child.parent = this

        :children.append( child )

        return child
    }

    function removeChild( child: View )
    {
        child.parent = null
        //:children.find( child )
        local index = :children.findIf( \item -> item is child )
        :children.pop( index )

        return child
    }
    
    function bringToFront()
    {
        local parent = :parent
        
        parent.removeChild( this )
        parent.addChild( this )
    }

    function opIndexAssign( index, value )
    {
        :fields[ index ] = value

        this.addChild( value )
    }

    function opIndex( index )
    {
        return :fields[ index ]
    }

 //
 // Drawing
 //

    function draw()
    {
        gl.glPushMatrix()

            gl.glTranslatef( :origin[0], :origin[1], 0 )

            :drawClient()
            :drawEffects()
            :drawOverlay()
            :drawBorder()

        gl.glPopMatrix()
    }

    function drawClient()
    {
        :drawContent()
        :drawChildren()
    }

    function drawContent()
    {
        gl.glColor3fv( :content )

        gl.glRects( 0, 0, :extent[0], :extent[1] )
    }

    function drawEffects()
    {
        foreach (effect; :effects)
            effect.apply( this )
    }

    function drawChildren()
    {
        foreach (child; :children)
        {
            child.draw()
        }
    }

    function drawOverlay() { }

    function drawBorder()
    {
        gl.glPolygonMode( gl.GL_BACK, gl.GL_LINE )
        gl.glColor3fv( :border )
        gl.glRectf( 0 - 0.5, 0 - 0.5, :extent[0] + 0.5, :extent[1] + 0.5 )
        gl.glPolygonMode( gl.GL_BACK, gl.GL_FILL )

        gl.glBegin( gl.GL_LINE_LOOP )
            gl.glColor4f( 1.0, 1.0, 1.0, 0.3 )
                gl.glVertex2f( 0.5, :extent[1] - 0.5 )
                gl.glVertex2f( 0.5, 0.5 );
                gl.glVertex2f( :extent[0] - 0.5, 0.5 )
            gl.glColor4f( 0.0, 0.0, 0.0, 0.1 )
                gl.glVertex2f( :extent[0] - 0.5, 0.5 )
                gl.glVertex2f( :extent[0] - 0.5, :extent[1] - 0.5 )
                gl.glVertex2f( 0.5, :extent[1] - 0.5 )
        gl.glEnd()
    }
    
 //
 // Events
 //

    function sendEvent( event: Event )
    {
        local result = event.handleEvent( this )
        
        return result
    }

    function containsPoint( point: Vector )
    {
        return point[0] >= 0 && point[0] <= :extent[0] &&
               point[1] >= 0 && point[1] <= :extent[1]
    }
    
    function mouseDown( point: Vector ) { writeln( this, ":mouseDown: ", point[0], " ", point[1] ) }
    function mouseUp( point: Vector ) { writeln( this, ":mouseUp: ", point[0], " ", point[1] ) }
    function mouseMove( point: Vector ) { writeln( this, ":mouseMove: ", point[0], " ", point[1] ) }
}

// ============================================================================================== //

class Screen : View
{
    grabbedView = null
    
    function sendEvent( event: Event )
    {
        local view = null

        if (:grabbedView)
            view = :grabbedView.sendEvent( MouseEvent( event.type,
                    event.point - :grabbedView.screenOrigin() ) )
        else
            view = super.sendEvent( event )

        if (view is this) { }
        else
        if (event.type == "mouseDown")
            :grabbedView = view
        else
        if (event.type == "mouseUp")
            :grabbedView = null

        return view
    }
}

class TitleBar : View
{
    function init()
    {
        :content = Vector.fromArray( "f32", [0.65, 0.75, 0.85] )
        :effects.append( Glossy )
        :reshape = ["size", ""]
    }

    function drawOverlay()
    {
        super.drawOverlay()
/*        
        gl.glPixelStorei( gl.GL_UNPACK_ALIGNMENT, 1 )
        gl.glPixelStorei( gl.GL_UNPACK_ROW_LENGTH, 759 )

        gl.glPixelZoom( 1, -1 )
        gl.glRasterPos2i( 0, 5 )
        gl.glDrawPixels( 759, 17, gl.GL_RGBA, gl.GL_UNSIGNED_BYTE, font2 )
*/
    }
    
    function drawBorder()
    {
        super.drawBorder()
        
        gl.glBegin( gl.GL_LINES )
            gl.glColor4f( 1.0, 1.0, 1.0, 0.5 )
                gl.glVertex2f( :extent[0] + 1.5, 0.5 )
                gl.glVertex2f( :extent[0] + 1.5, :extent[1] + 1.5 )
                gl.glVertex2f( :extent[0] + 1.5, :extent[1] + 1.5 )
                gl.glVertex2f( -1.5, :extent[1] + 1.5 )
            gl.glColor4f( 0.0, 0.0, 0.0, 0.1 )
                gl.glVertex2f( -1.5, :extent[1] + 1.5 )
                gl.glVertex2f( -1.5, 0.5 )
        gl.glEnd()
    }

    function mouseDown( point: Vector )
    {
        super.mouseDown( point )

        :active = true
        :mouse  = point
    }

    function mouseMove( point: Vector )
    {
        super.mouseMove( point )

        if (:active) :parent.origin += point - :mouse
    }

    function mouseUp( point: Vector )
    {
        super.mouseUp( point )

        :active = false
    }
}

class Sizer : View
{
    function init()
    {
        :reshape = ["move", "move"]
    }
    
    function mouseDown( point: Vector )
    {
        super.mouseDown( point )

        :active = true
        :mouse  = point
    }

    function mouseMove( point: Vector )
    {
        super.mouseMove( point )

        //if (:active) :parent.extent = point - :mouse
        if (:active) :parent.setExtent( :parent.extent + (point - :mouse) )
    }

    function mouseUp( point: Vector )
    {
        super.mouseUp( point )

        :active = false
    }
}

class Window : View
{
    titlebar = null
    size     = null
    
    function init()
    {
        :extent  = Vector.fromArray( "i16", [400, 300] )
        :effects.append( Shiny, Shaddow )
        
        local window = this
        
        :titlebar = TitleBar $ \
        {
            :origin  = Vector.fromArray( "i16", [25, 0] )
            :extent  = Vector.fromArray( "i16", [window.extent[0] - 50, 25] )
        }
        
        :addChild( :titlebar )
        
        :sizer = Sizer $ \
        {
            :origin  = Vector.fromArray( "i16", [window.extent[0] - 25, window.extent[1] - 25] )
            :extent  = Vector.fromArray( "i16", [25, 25] )
        }
        
        :addChild( :sizer )
    }

    function setExtent( extent: Vector )
    {
        if (extent[0] < 100 || extent[1] < 100)
        {
            :setExtent( Vector.fromArray( "i16", [math.max( extent[0], 100 ), math.max( extent[1], 100 )] ) )
        }
        else super.setExtent( extent )
    }

    function drawClient()
    {
        gl.glScissor( :origin[0], 768 - :origin[1] - :extent[1], :extent[0], :extent[1] )
        gl.glEnable( gl.GL_SCISSOR_TEST )

        super.drawClient()

        gl.glDisable( gl.GL_SCISSOR_TEST )
    }

    function sendEvent( event: Event )
    {
        :bringToFront()
        
        return super.sendEvent( event )
    }
}

class Button : View
{
    caption = ""
    action = null

    function init( caption: string )
    {
        :caption = caption
        :content = Vector.fromArray( "f32", [0.9375, 0.734375, 0.16796875] )
        :effects.append( Glossy )
    }

    function drawOverlay()
    {
        gl.glColor4f( 0.0, 0.0, 0.0, 0.1 )
        if (:active) gl.glRects( 0, 0, :extent[0], :extent[1] )
    }

    function mouseDown( point: Vector )
    {
        super.mouseDown( point )

        :active = true
        :mouse  = point
    }

    function mouseUp( point: Vector )
    {
        super.mouseUp( point )

        if (:active) :click()

        :active = false
    }

    function click()
    {
        :action()
    }

}

