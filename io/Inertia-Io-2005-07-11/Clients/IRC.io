//
// IRCClient.io
//

Inertia do (

  IRCClient := Object clone do (

    socket := Nil
    //nickName := "MikeAustin_test"
    //userName := nickName
    //userEmail := nickName .. "@foo.com"

    nickname := "MikeAustin"
    username := nickname
    server   := "irc.freenode.net"
    port     := 6667
    channel  := "#io"
    xtarget  := Nil

    init := method (
      self socket := Socket clone
    )

    connect := method (
      socket setReadTimeout( 60 * 60 * 24 )
      SocketManager setSelectTimeout( 0 )
      Scheduler setSleepInterval( 0 )
      host := Host clone setName( server ) address
      socket setHost( host ) setPort( port ) connect
      if ( socket error, writeln( socket error ); System exit )
      socket write( "NICK ", nickname, "\r\n" )
      //socket write( "USER " .. userName .. " 0 0 " .. userEmail .. "\r\n" )
      socket write( "USER " .. username .. " 0 0 :" .. nickname .. "\r\n" )

      socket read
      writeln( socket readBuffer )
      socket readBuffer empty

      socket write( "JOIN " .. channel .. "\r\n" )

      while ( socket isOpen,
        socket read
        if ( socket readBuffer length != 0,
          if( xtarget ) then (
            xtarget at(0) perform( xtarget at(1), socket readBuffer asString )
          )
          socket readBuffer empty
        )
      )
    )

  )

  Nil after := method( "" )

)

